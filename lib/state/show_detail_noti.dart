import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:joelfindtechnician/models/notification_model.dart';
import 'package:joelfindtechnician/models/postcustomer_model.dart';
import 'package:joelfindtechnician/models/replypost_model.dart';
import 'package:joelfindtechnician/models/user_model_old.dart';
import 'package:joelfindtechnician/utility/my_constant.dart';
import 'package:joelfindtechnician/utility/time_to_string.dart';
import 'package:joelfindtechnician/widgets/show_image.dart';
import 'package:joelfindtechnician/widgets/show_progress.dart';
import 'package:joelfindtechnician/widgets/show_text.dart';

class ShowDetailNoti extends StatefulWidget {
  final String title, message;
  final UserModelOld userModelOld;
  const ShowDetailNoti({
    Key? key,
    required this.userModelOld,
    required this.title,
    required this.message,
  }) : super(key: key);

  @override
  _ShowDetailNotiState createState() => _ShowDetailNotiState();
}

class _ShowDetailNotiState extends State<ShowDetailNoti> {
  String? title, message;
  List<PostCustomerModel> postCustomerModels = [];
  bool load = true;
  UserModelOld? userModelOld;
  File? file;
  bool showAddPhotoReplyPost = false; // true show Icon
  TextEditingController textEditingController = TextEditingController();

  String? docIdReply;

  List<ReplyPostModel> replyPostModels = [];
  String? docIdUser, docIdMyNotification;
  List<String> docIdNotifications = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    title = widget.title;
    message = widget.message;
    userModelOld = widget.userModelOld;
    print(
        '#28nov ค่าที่ได้จากการคลิก Noti ที่ ShowDetailNoti ==>> $title, $message');
    readDataNotification();
  }

  processTakePhoto(ImageSource source) async {
    try {
      var result = await ImagePicker().getImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
      );
      setState(() {
        file = File(result!.path);
      });
    } catch (e) {}
  }

  Future<void> readDataNotification() async {
    if (postCustomerModels.isNotEmpty) {
      postCustomerModels.clear();
      replyPostModels.clear();
      showAddPhotoReplyPost = false;
      file = null;
      docIdNotifications.clear();
    }

    await Firebase.initializeApp().then((value) async {
      await FirebaseFirestore.instance
          .collection('user')
          .where('uid', isEqualTo: userModelOld!.uid)
          .get()
          .then((value) async {
        for (var item in value.docs) {
          docIdUser = item.id;
          print('#4dec docIdUser ==>> $docIdUser');

          await FirebaseFirestore.instance
              .collection('user')
              .doc(docIdUser)
              .collection('mynotification')
              .where('message', isEqualTo: message)
              .get()
              .then((value) async {
            for (var item in value.docs) {
              docIdMyNotification = item.id;
              print('#4dec  docIdMyNoti ==>> $docIdMyNotification');

              NotificationModel notificationModel =
                  NotificationModel.fromMap(item.data());
              if (notificationModel.status == 'unread') {
                Map<String, dynamic> map = {};
                map['status'] = 'read';
                await FirebaseFirestore.instance
                    .collection('user')
                    .doc(docIdUser)
                    .collection('mynotification')
                    .doc(docIdMyNotification)
                    .update(map)
                    .then((value) {
                  print('#4dec Update Success');
                });
              }
            }
          });
        }
      });
    });

    await Firebase.initializeApp().then((value) async {
      await FirebaseFirestore.instance
          .collection('postcustomer')
          .where('job', isEqualTo: message)
          .get()
          .then((value) async {
        for (var item in value.docs) {
          docIdReply = item.id;
          print('#4dec docIdReply ==>> $docIdReply');
          PostCustomerModel model = PostCustomerModel.fromMap(item.data());

          await FirebaseFirestore.instance
              .collection('postcustomer')
              .doc(docIdReply)
              .collection('replypost')
              .orderBy('timeReply', descending: true)
              .get()
              .then((value) {
            print('#4dec value ==>> ${value.docs}');

            if (value.docs.isNotEmpty) {
              for (var item in value.docs) {
                ReplyPostModel replyPostModel =
                    ReplyPostModel.fromMap(item.data());

                if (replyPostModel.status == 'online') {
                  setState(() {
                    replyPostModels.add(replyPostModel);
                    docIdNotifications.add(item.id);
                  });
                }
              }
            }
          });

          setState(() {
            load = false;
            postCustomerModels.add(model);
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Show Detail Notification'),
      ),
      body: load
          ? ShowProgress()
          : GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              behavior: HitTestBehavior.opaque,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        newCircleAvatar(postCustomerModels[0].pathUrl),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShowText(
                              title: postCustomerModels[0].name,
                              textStyle: MyConstant().h2Style(),
                            ),
                            ShowText(
                              title: TimeToString(
                                      timestamp: postCustomerModels[0].timePost)
                                  .findString(),
                              textStyle: MyConstant().h4Style(),
                            ),
                          ],
                        ),
                      ],
                    ),
                    ShowText(title: postCustomerModels[0].job),
                    Divider(thickness: 2),
                    Row(
                      children: [
                        Icon(Icons.location_on),
                        ShowText(title: postCustomerModels[0].district),
                        SizedBox(width: 8),
                        Icon(Icons.location_on),
                        ShowText(title: postCustomerModels[0].amphur),
                        SizedBox(width: 8),
                        Icon(Icons.location_on),
                        ShowText(title: postCustomerModels[0].province),
                      ],
                    ),
                    Divider(thickness: 2),
                    Container(
                      margin: EdgeInsets.only(left: 16),
                      child: Row(
                        children: [
                          newCircleAvatar(userModelOld!.img),
                          Container(
                            width: 200,
                            height: 80,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: TextFormField(
                                controller: textEditingController,
                                onChanged: (value) {
                                  setState(() {
                                    showAddPhotoReplyPost = true;
                                    if (value.isEmpty) {
                                      showAddPhotoReplyPost = false;
                                    }
                                  });
                                },
                                decoration: InputDecoration(
                                  suffix: IconButton(
                                    onPressed: () async {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: ListTile(
                                            leading: ShowImage(),
                                            title: ShowText(
                                              title: 'Take Photo',
                                              textStyle: MyConstant().h2Style(),
                                            ),
                                            subtitle: ShowText(
                                              title:
                                                  'Please Choose Camera or Gallery',
                                              textStyle: MyConstant().h4Style(),
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                processTakePhoto(
                                                    ImageSource.camera);
                                              },
                                              child: Text('Camera'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                processTakePhoto(
                                                    ImageSource.gallery);
                                              },
                                              child: Text('Gallery'),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text('Cancel'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    icon: Icon(Icons.add_a_photo_outlined),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          ((showAddPhotoReplyPost) || (file != null))
                              ? IconButton(
                                  onPressed: () async {
                                    if (file == null) {
                                      processInsertPostCustomer('');
                                    } else {
                                      await Firebase.initializeApp()
                                          .then((value) async {
                                        String nameImage =
                                            'reply${Random().nextInt(100000000)}.jpg';
                                        FirebaseStorage storage =
                                            FirebaseStorage.instance;
                                        Reference reference = storage
                                            .ref()
                                            .child('replypost/$nameImage');
                                        UploadTask task =
                                            reference.putFile(file!);
                                        await task.whenComplete(() async {
                                          await reference
                                              .getDownloadURL()
                                              .then((value) {
                                            processInsertPostCustomer(value);
                                          });
                                        });
                                      });
                                    }
                                  },
                                  icon: Icon(Icons.send_outlined))
                              : SizedBox(),
                        ],
                      ),
                    ),
                    file == null
                        ? SizedBox()
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 64),
                                width: 230,
                                height: 200,
                                child: Image.file(
                                  file!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    file = null;
                                  });
                                },
                                icon: Icon(Icons.clear_sharp),
                              ),
                            ],
                          ),
                    replyPostModels.isEmpty
                        ? SizedBox()
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemCount: replyPostModels.length,
                            itemBuilder: (context, index) => Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 80, bottom: 4),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4, horizontal: 8),
                                            child: CircleAvatar(
                                              backgroundImage:
                                                  CachedNetworkImageProvider(
                                                      replyPostModels[index]
                                                          .pathImage),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 4, horizontal: 16),
                                            width: 180,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade300,
                                              borderRadius:
                                                  BorderRadius.circular(300),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ShowText(
                                                  title: replyPostModels[index]
                                                      .name,
                                                  textStyle:
                                                      MyConstant().h2Style(),
                                                ),
                                                ShowText(
                                                    title: TimeToString(
                                                            timestamp:
                                                                replyPostModels[
                                                                        index]
                                                                    .timeReply)
                                                        .findString()),
                                                ShowText(
                                                    title:
                                                        replyPostModels[index]
                                                            .reply),
                                              ],
                                            ),
                                          ),
                                          userModelOld!.uid !=
                                                  replyPostModels[index].uid
                                              ? SizedBox()
                                              : IconButton(
                                                  onPressed: () async {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          AlertDialog(
                                                        title: ListTile(
                                                          leading: ShowImage(),
                                                          title: ShowText(
                                                            title:
                                                                'Comfime Delete Reply ?',
                                                            textStyle:
                                                                MyConstant()
                                                                    .h2Style(),
                                                          ),
                                                          subtitle: ShowText(
                                                              title:
                                                                  'คุณต้องการจะลบ Reple จริงๆ หรือ'),
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            onPressed:
                                                                () async {
                                                              Navigator.pop(
                                                                  context);
                                                              Map<String,
                                                                      dynamic>
                                                                  map = {};
                                                              map['status'] =
                                                                  'offline';

                                                              print(
                                                                  '##4dec map => $map');
                                                              print(
                                                                  '##4dec docIdNoit = ${docIdNotifications[index]}');

                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'postcustomer')
                                                                  .doc(
                                                                      docIdReply)
                                                                  .collection(
                                                                      'replypost')
                                                                  .doc(docIdNotifications[
                                                                      index])
                                                                  .update(map)
                                                                  .then((value) =>
                                                                      readDataNotification());
                                                            },
                                                            child: Text('OK'),
                                                          ),
                                                          TextButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    context),
                                                            child: Text('NO'),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                  icon: Icon(
                                                      Icons.delete_forever),
                                                ),
                                        ],
                                      ),
                                      replyPostModels[index]
                                              .urlImagePost
                                              .isEmpty
                                          ? SizedBox()
                                          : Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 8),
                                              width: 150,
                                              height: 120,
                                              child: CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                errorWidget:
                                                    (context, url, error) =>
                                                        ShowImage(),
                                                placeholder: (context, url) =>
                                                    ShowProgress(),
                                                imageUrl: replyPostModels[index]
                                                    .urlImagePost,
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
            ),
    );
  }

  Container newCircleAvatar(String url) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      width: 48,
      height: 48,
      child: CircleAvatar(
        backgroundImage: CachedNetworkImageProvider(url),
      ),
    );
  }

  Future<void> processInsertPostCustomer(String urlImagePost) async {
    String name = userModelOld!.name;
    String pathImage = userModelOld!.img;
    String reply = textEditingController.text;

    DateTime dateTime = DateTime.now();
    Timestamp timeReply = Timestamp.fromDate(dateTime);

    String uid = userModelOld!.uid;
    String status = 'online';

    ReplyPostModel model = ReplyPostModel(
        name: name,
        pathImage: pathImage,
        reply: reply,
        timeReply: timeReply,
        uid: uid,
        urlImagePost: urlImagePost,
        status: status);

    await Firebase.initializeApp().then((value) async {
      await FirebaseFirestore.instance
          .collection('postcustomer')
          .doc(docIdReply)
          .collection('replypost')
          .doc()
          .set(model.toMap())
          .then((value) {
        print('#28nov Insert Reply Success');
        textEditingController.text = '';
        file = null;
        readDataNotification();
      });
    });
  }
}
