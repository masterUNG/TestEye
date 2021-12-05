import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:joelfindtechnician/models/answer_model.dart';
import 'package:joelfindtechnician/models/notification_model.dart';
import 'package:joelfindtechnician/models/postcustomer_model.dart';
import 'package:joelfindtechnician/models/replypost_model.dart';
import 'package:joelfindtechnician/models/user_model_old.dart';
import 'package:joelfindtechnician/state/show_image_post.dart';
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
  List<bool> showAnswerTextFields = [];
  List<bool> showIconSentAnswers = [];
  List<List<AnswerModel>> listAnswerModels = [];
  List<String> docIdReplyPosts = [];
  List<List<String>> listDocIdAnswers = [];
  List<File?> fileAnswers = [];
  List<TextEditingController> answerControllers = [];

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

  processTakePhotoAnswer(ImageSource source, int index) async {
    try {
      var result = await ImagePicker().getImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
      );
      setState(() {
        fileAnswers[index] = File(result!.path);
      });
    } catch (e) {}
  }

  Future<void> readDataNotification() async {
    if (postCustomerModels.isNotEmpty) {
      setState(() {
        load = true;
      });
      postCustomerModels.clear();
      replyPostModels.clear();
      showAddPhotoReplyPost = false;
      file = null;
      fileAnswers.clear();
      docIdNotifications.clear();
      listAnswerModels.clear();
      docIdReplyPosts.clear();
      listDocIdAnswers.clear();
      showIconSentAnswers.clear();
      showAnswerTextFields.clear();
      answerControllers.clear();
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

          // for MyNotification
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

    // For ReadPost on Postcustomer
    await Firebase.initializeApp().then((value) async {
      await FirebaseFirestore.instance
          .collection('postcustomer')
          .where('job', isEqualTo: message)
          .get()
          .then((value) async {
        for (var item in value.docs) {
          docIdReply = item.id;
          print('###4dec message ==> $message');
          print('###4dec doc of postcoustomer ==>> $docIdReply');
          PostCustomerModel model = PostCustomerModel.fromMap(item.data());

          await FirebaseFirestore.instance
              .collection('postcustomer')
              .doc(docIdReply)
              .collection('replypost')
              .orderBy('timeReply', descending: true)
              .get()
              .then((value) async {
            print('#4dec value ==>> ${value.docs}');

            if (value.docs.isNotEmpty) {
              for (var item in value.docs) {
                showAnswerTextFields.add(false);
                showIconSentAnswers.add(false);
                fileAnswers.add(null);
                answerControllers.add(TextEditingController());

                String docIdReplyPost2 = item.id;

                List<AnswerModel> answerModels = [];
                List<String> docIdAnswers = [];

                await FirebaseFirestore.instance
                    .collection('postcustomer')
                    .doc(docIdReply)
                    .collection('replypost')
                    .doc(docIdReplyPost2)
                    .collection('answer')
                    .orderBy('timePost', descending: false)
                    .get()
                    .then((value) {
                  if (value.docs.isNotEmpty) {
                    for (var item in value.docs) {
                      AnswerModel answerModel =
                          AnswerModel.fromMap(item.data());
                      answerModels.add(answerModel);
                      docIdAnswers.add(item.id);
                    }
                  }
                });

                ReplyPostModel replyPostModel =
                    ReplyPostModel.fromMap(item.data());

                if (replyPostModel.status == 'online') {
                  setState(() {
                    replyPostModels.add(replyPostModel);
                    docIdNotifications.add(item.id);
                    listAnswerModels.add(answerModels);
                    docIdReplyPosts.add(docIdReplyPost2);
                    listDocIdAnswers.add(docIdAnswers);
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
                    newName(),
                    ShowText(title: postCustomerModels[0].job),
                    Divider(thickness: 2),
                    newProvince(),
                    Divider(thickness: 2),
                    newReply(context),
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
                    replyPostModels.isEmpty ? SizedBox() : listReplyPost(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget listReplyPost() {
    return ListView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: replyPostModels.length,
      itemBuilder: (context, index) => Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 80, bottom: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      child: CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                            replyPostModels[index].pathImage),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                      width: 180,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShowText(
                            title: replyPostModels[index].name,
                            textStyle: MyConstant().h2Style(),
                          ),
                          ShowText(
                              title: TimeToString(
                                      timestamp:
                                          replyPostModels[index].timeReply)
                                  .findString()),
                          ShowText(title: replyPostModels[index].reply),
                        ],
                      ),
                    ),
                    userModelOld!.uid != replyPostModels[index].uid
                        ? SizedBox()
                        : IconButton(
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: ListTile(
                                    leading: ShowImage(),
                                    title: ShowText(
                                      title: 'Comfime Delete Reply ?',
                                      textStyle: MyConstant().h2Style(),
                                    ),
                                    subtitle: ShowText(
                                        title:
                                            'คุณต้องการจะลบ Reple จริงๆ หรือ'),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        Map<String, dynamic> map = {};
                                        map['status'] = 'offline';

                                        print('##4dec map => $map');
                                        print(
                                            '##4dec docIdNoit = ${docIdNotifications[index]}');

                                        await FirebaseFirestore.instance
                                            .collection('postcustomer')
                                            .doc(docIdReply)
                                            .collection('replypost')
                                            .doc(docIdNotifications[index])
                                            .update(map)
                                            .then((value) =>
                                                readDataNotification());
                                      },
                                      child: Text('OK'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('NO'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: Icon(Icons.delete_forever),
                          ),
                  ],
                ),
                replyPostModels[index].urlImagePost.isEmpty
                    ? SizedBox()
                    : Container(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        width: 150,
                        height: 120,
                        child: InkWell(
                          onTap: () {
                            print('Click');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ShowImagePost(
                                    pathImage:
                                        replyPostModels[index].urlImagePost),
                              ),
                            );
                          },
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => ShowImage(),
                            placeholder: (context, url) => ShowProgress(),
                            imageUrl: replyPostModels[index].urlImagePost,
                          ),
                        ),
                      ),
                listAnswerModels[index].isEmpty
                    ? SizedBox()
                    : newListAnswer(
                        listAnswerModels[index], docIdReplyPosts[index]),
                TextButton(
                  onPressed: () {
                    setState(() {
                      showAnswerTextFields[index] = true;
                    });
                  },
                  child: Text('ตอบกลับ'),
                ),
                showAnswerTextFields[index]
                    ? Row(
                        children: [
                          SizedBox(
                            width: 30,
                          ),
                          newCircleAvatar(userModelOld!.img),
                          Container(
                            width: 150,
                            height: 50,
                            child: TextFormField(
                              controller: answerControllers[index],
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  setState(() {
                                    showIconSentAnswers[index] = false;
                                  });
                                } else {
                                  setState(() {
                                    showIconSentAnswers[index] = true;
                                  });
                                }
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
                                              title: 'Take Photo Answer',
                                              textStyle: MyConstant().h2Style(),
                                            ),
                                            subtitle: ShowText(
                                                title:
                                                    'Please Choose Camera or Gallery'),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                processTakePhotoAnswer(
                                                    ImageSource.camera, index);
                                              },
                                              child: Text('Camera'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                processTakePhotoAnswer(
                                                    ImageSource.gallery, index);
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
                                    icon: Icon(Icons.add_a_photo)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                          ),
                          ((showIconSentAnswers[index]) ||
                                  (fileAnswers[index] != null))
                              ? IconButton(
                                  onPressed: () async {
                                    if (fileAnswers[index] == null) {
                                      // No Image Upload
                                      processInsertNewAnswer(
                                          answerControllers[index].text,
                                          '',
                                          index);
                                    } else {
                                      String nameImage =
                                          'answer/${Random().nextInt(100000000)}.jpg';
                                      FirebaseStorage storage =
                                          FirebaseStorage.instance;
                                      Reference reference = storage
                                          .ref()
                                          .child('answer/$nameImage');
                                      UploadTask uploadTask = reference
                                          .putFile(fileAnswers[index]!);
                                      await uploadTask.whenComplete(() async {
                                        await reference
                                            .getDownloadURL()
                                            .then((value) {
                                          String urlImage = value;
                                          processInsertNewAnswer(
                                            answerControllers[index].text,
                                            urlImage,
                                            index,
                                          );
                                        });
                                      });
                                    }
                                  },
                                  icon: Icon(Icons.cloud_upload_outlined),
                                )
                              : SizedBox()
                        ],
                      )
                    : SizedBox(),
                fileAnswers[index] == null
                    ? SizedBox()
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 100, bottom: 16),
                            width: 120,
                            height: 100,
                            child: Image.file(
                              fileAnswers[index]!,
                              fit: BoxFit.cover,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                fileAnswers[index] = null;
                              });
                            },
                            icon: Icon(Icons.clear),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget newListAnswer(List<AnswerModel> answerModels, String docIdReplyPost) {
    List<Widget> widgets = [];

    for (var model in answerModels) {
      if (model.status == 'online') {
        widgets.add(
          Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 30,
                  ),
                  newCircleAvatar(model.urlPost),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShowText(
                          title: model.namePost,
                          textStyle: MyConstant().h2Style(),
                        ),
                        ShowText(
                          title: TimeToString(timestamp: model.timePost)
                              .findString(),
                        ),
                        ShowText(title: model.answer),
                      ],
                    ),
                  ),
                  userModelOld!.name == model.namePost
                      ? IconButton(
                          onPressed: () async {
                            print(
                                '#5dec ==> delete at doc ==>> $docIdReplyPost');
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: ListTile(
                                  leading: ShowImage(),
                                  title: ShowText(
                                    title: 'Comfirm Delete',
                                    textStyle: MyConstant().h2Style(),
                                  ),
                                  subtitle: ShowText(
                                      title: 'Delete ${model.answer} ?'),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.pop(context);

                                      print('docCustomer ==> $docIdReply');
                                      await FirebaseFirestore.instance
                                          .collection('postcustomer')
                                          .doc(docIdReply)
                                          .collection('replypost')
                                          .doc(docIdReplyPost)
                                          .collection('answer')
                                          .where('answer',
                                              isEqualTo: model.answer)
                                          .get()
                                          .then((value) async {
                                        for (var item in value.docs) {
                                          String docIdAnswer = item.id;
                                          print(
                                              'delete at doc ==>> $docIdAnswer');

                                          Map<String, dynamic> data = {};
                                          data['status'] = 'offline';

                                          await FirebaseFirestore.instance
                                              .collection('postcustomer')
                                              .doc(docIdReply)
                                              .collection('replypost')
                                              .doc(docIdReplyPost)
                                              .collection('answer')
                                              .doc(docIdAnswer)
                                              .update(data)
                                              .then((value) =>
                                                  readDataNotification());
                                        }
                                      });
                                    },
                                    child: Text('Delete'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('Cancel'),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: Icon(Icons.delete_outline),
                        )
                      : SizedBox(),
                ],
              ),
              model.urlImage.isEmpty
                  ? SizedBox()
                  : Container(
                      width: 100,
                      height: 80,
                      child: InkWell(
                        onTap: () {
                          print('Click');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ShowImagePost(pathImage: model.urlImage),
                            ),
                          );
                        },
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: model.urlImage,
                          placeholder: (context, url) => ShowProgress(),
                          errorWidget: (context, url, error) => ShowImage(),
                        ),
                      ),
                    ),
            ],
          ),
        );
      }
    }

    return Column(
      children: widgets,
    );
  }

  Widget newReply(BuildContext context) {
    return Container(
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
                              title: 'Please Choose Camera or Gallery',
                              textStyle: MyConstant().h4Style(),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                processTakePhoto(ImageSource.camera);
                              },
                              child: Text('Camera'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                processTakePhoto(ImageSource.gallery);
                              },
                              child: Text('Gallery'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context),
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
                      await Firebase.initializeApp().then((value) async {
                        String nameImage =
                            'reply${Random().nextInt(100000000)}.jpg';
                        FirebaseStorage storage = FirebaseStorage.instance;
                        Reference reference =
                            storage.ref().child('replypost/$nameImage');
                        UploadTask task = reference.putFile(file!);
                        await task.whenComplete(() async {
                          await reference.getDownloadURL().then((value) {
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
    );
  }

  Row newProvince() {
    return Row(
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
    );
  }

  Row newName() {
    return Row(
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
              title: TimeToString(timestamp: postCustomerModels[0].timePost)
                  .findString(),
              textStyle: MyConstant().h4Style(),
            ),
          ],
        ),
      ],
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

  Future<void> processInsertNewAnswer(
      String answer, String urlImage, int index) async {
    AnswerModel answerModel = AnswerModel(
        answer: answer,
        namePost: userModelOld!.name,
        urlPost: userModelOld!.img,
        urlImage: urlImage,
        timePost: Timestamp.fromDate(DateTime.now()),
        status: 'online');

    print('docPostcustomer ==> $docIdReply');
    print('docReplyPost ==>> ${docIdReplyPosts[index]}');

    await FirebaseFirestore.instance
        .collection('postcustomer')
        .doc(docIdReply)
        .collection('replypost')
        .doc(docIdNotifications[index])
        .collection('answer')
        .doc()
        .set(answerModel.toMap())
        .then((value) => readDataNotification());
  }
}
