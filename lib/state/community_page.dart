import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:joelfindtechnician/alertdialog/my_dialog.dart';
import 'package:joelfindtechnician/customer_state/create_post.dart';
import 'package:joelfindtechnician/customer_state/ctm_aboutus.dart';
import 'package:joelfindtechnician/customer_state/ctm_contactus.dart';
import 'package:joelfindtechnician/customer_state/ctm_howtouseapp.dart';
import 'package:joelfindtechnician/customer_state/ctm_notification.dart';
import 'package:joelfindtechnician/customer_state/ctm_ordethistory.dart';
import 'package:joelfindtechnician/customer_state/ctm_termandconditon.dart';
import 'package:joelfindtechnician/models/answer_model.dart';
import 'package:joelfindtechnician/models/postcustomer_model.dart';
import 'package:joelfindtechnician/models/replypost_model.dart';
import 'package:joelfindtechnician/models/typetechnic_array.dart';

import 'package:joelfindtechnician/state/list_technic_where_type.dart';
import 'package:joelfindtechnician/state/login_page.dart';
import 'package:joelfindtechnician/customer_state/login_success.dart';
import 'package:joelfindtechnician/customer_state/social_service.dart';
import 'package:joelfindtechnician/models/user_model_old.dart';
import 'package:joelfindtechnician/state/show_image_post.dart';
import 'package:joelfindtechnician/utility/find_user_by_uid.dart';
import 'package:joelfindtechnician/utility/my_constant.dart';
import 'package:joelfindtechnician/utility/time_to_string.dart';
import 'package:joelfindtechnician/widgets/show_image.dart';
import 'package:joelfindtechnician/widgets/show_progress.dart';
import 'package:joelfindtechnician/widgets/show_text.dart';

import 'edit_post.dart';

class CommunityPage extends StatefulWidget {
  final bool? userSocialbol;
  const CommunityPage({Key? key, this.userSocialbol}) : super(key: key);

  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final User = FirebaseAuth.instance.currentUser!;
  UserModelOld? userModelOld;
  bool load = true;
  File? image;

  List<String> provinces = MyConstant.provinces;

  String? provinceChoosed;
  List<String> serviceGroups = [];
  List<String> paths = MyConstant.pathImageIcons;
  List<Color> colors = MyConstant.colors;
  List<PostCustomerModel> postCustomerModels = [];
  bool loadPost = true;
  bool? userSocial;
  List<String> docIdPostCustomers = [];

  // bool showPostIcon = false;
  List<TextEditingController> replyControllers = [];
  List<Widget> replyWidgets = [];
  List<bool> showPostIcons = [];
  List<File?> files = [];

  List<List<ReplyPostModel>> listReplyPostModels = [];
  List<List<String>> listDocIdReplys = [];

  String urlImagePostStr = '';
  List<String> docIdReplys = [];

  List<List<bool>> listTextFieldAnswers = [];
  List<List<bool>> listIconAnswers = [];
  List<List<File?>> listFilePostAnswers = [];
  List<List<String>> listAnswers = [];
  List<List<String>> listDocIdReplyAnswers = [];

  List<List<List<AnswerModel>>> listOflistAnswerModels = [];
  List<List<List<String>>> listOflistIdAnswers = [];

  List<List<String>> myListDocIdReplyPosts = [];

  late String nameUserLogin;

  void buildSetup() {
    postCustomerModels.clear();
    docIdPostCustomers.clear();
    listReplyPostModels.clear();
    listDocIdReplys.clear();
    docIdReplys.clear();
    replyControllers.clear();
    replyWidgets.clear();
    listTextFieldAnswers.clear();
    listIconAnswers.clear();
    listFilePostAnswers.clear();
    listAnswers.clear();
    listDocIdReplyAnswers.clear();
    listOflistAnswerModels.clear();
    listOflistIdAnswers.clear();
    myListDocIdReplyPosts.clear();
  }

  _imageFromCamera(int index) async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(
        source: ImageSource.camera, maxWidth: 800, maxHeight: 800);
    final pickedImageFile = File(pickedImage!.path);
    setState(() {
      files[index] = pickedImageFile;
    });
  }

  _imageFromGallery(int index) async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(
        source: ImageSource.gallery, maxWidth: 800, maxHeight: 800);
    final pickedImageFile = File(pickedImage!.path);
    setState(() {
      files[index] = pickedImageFile;
    });
  }

  @override
  void initState() {
    super.initState();

    userSocial = widget.userSocialbol;
    // print('## userSocial ==> $userSocial');
    if (userSocial == null) {
      userSocial = false;
    }

    if (!userSocial!) {
      readUserProfile();
    } else {
      nameUserLogin = User.displayName.toString();
    }

    if (User.displayName != null) {
      load = false;
    }

    findServiceGroup();
  }

  Future<void> findServiceGroup() async {
    if (serviceGroups.isNotEmpty) {
      serviceGroups.clear();
    }

    if (provinceChoosed == null) {
      await Firebase.initializeApp().then((value) async {
        await FirebaseFirestore.instance.collection('user').get().then((value) {
          for (var item in value.docs) {
            TypeTechnicArrayModel typeTechnicArrayModel =
                TypeTechnicArrayModel.fromMap(item.data());

            if (serviceGroups.isEmpty) {
              List<String> strings = typeTechnicArrayModel.typeTechnics;
              for (var item in strings) {
                setState(() {
                  serviceGroups.add(item);
                });
              }
            } else {
              if (checkGroup(typeTechnicArrayModel.typeTechnics)) {
                List<String> strings = typeTechnicArrayModel.typeTechnics;
                for (var item in strings) {
                  setState(() {
                    serviceGroups.add(item);
                  });
                }
              }
            }
          }
          // print('## serviceProvince ==> $serviceGroups');
        });
      });
    } else {
      await Firebase.initializeApp().then((value) async {
        await FirebaseFirestore.instance
            .collection('user')
            .where('province', isEqualTo: provinceChoosed)
            .get()
            .then((value) {
          for (var item in value.docs) {
            TypeTechnicArrayModel typeTechnicArrayModel =
                TypeTechnicArrayModel.fromMap(item.data());

            if (serviceGroups.isEmpty) {
              List<String> strings = typeTechnicArrayModel.typeTechnics;
              for (var item in strings) {
                setState(() {
                  serviceGroups.add(item);
                });
              }
            } else {
              if (checkGroup(typeTechnicArrayModel.typeTechnics)) {
                List<String> strings = typeTechnicArrayModel.typeTechnics;
                for (var item in strings) {
                  setState(() {
                    serviceGroups.add(item);
                  });
                }
              }
            }
          }
          // print('## serviceProvince ==> $serviceGroups');
        });
      });
    }
  }

  bool checkGroup(List<String> typeTechnics) {
    bool result = true;
    for (var item1 in typeTechnics) {
      for (var item2 in serviceGroups) {
        if (item1 == item2) {
          result = false;
        }
      }
    }
    return result;
  }

  Future<void> readUserProfile() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseFirestore.instance
          .collection('user')
          .where('uid', isEqualTo: User.uid)
          .get()
          .then((value) async {
        for (var item in value.docs) {
          String docId = item.id;
          await FirebaseFirestore.instance
              .collection('user')
              .doc(docId)
              .get()
              .then((value) {
            setState(() {
              load = false;
              userModelOld = UserModelOld.fromMap(value.data()!);
              nameUserLogin = userModelOld!.name;
              // print('## name user login = ${userModelOld!.name}');
            });
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      floatingActionButton: provinceChoosed == null
          ? SizedBox()
          : userSocial!
              ? buildFloating(context)
              : SizedBox(),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: SafeArea(
            child: Container(
              child: Column(
                children: [
                  dropdownProvince(),
                  buildBanner(),
                  buildTitle(),
                  serviceGroups.isEmpty
                      ? ShowProgress()
                      : gridViewTypeTechnic(),
                  provinceChoosed == null ? SizedBox() : listPost(),
                ],
              ),
            ),
          ),
        ),
      ),
      endDrawer: load ? Drawer() : buildDrawer(context),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
      ),
      title: Text('Community Page'),
    );
  }

  Widget listPost() => loadPost
      ? ShowProgress()
      : Column(
          children: [
            buildTitleListPost(),
            Divider(thickness: 2),
            ListView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: postCustomerModels.length,
              itemBuilder: (context, index) {
                files.add(null);
                replyControllers.add(TextEditingController());
                showPostIcons.add(false);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildIconAnName(index),
                        userSocial!
                            ? User.uid == postCustomerModels[index].uidCustomer
                                ? buildMenuDeletePost(index)
                                : SizedBox()
                            : SizedBox(),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ShowText(
                        title: cutWord(postCustomerModels[index].job),
                      ),
                    ),
                    showGridImage(postCustomerModels[index].pathImages),
                    Divider(thickness: 2),
                    Row(
                      children: [
                        Icon(Icons.location_on),
                        ShowText(title: postCustomerModels[index].district),
                        SizedBox(width: 8),
                        Icon(Icons.location_on),
                        ShowText(title: postCustomerModels[index].amphur),
                        SizedBox(width: 8),
                        Icon(Icons.location_on),
                        ShowText(title: postCustomerModels[index].province),
                      ],
                    ),
                    Divider(thickness: 2),

                    buildReplyPost(index),
                    // replyWidgets[index],
                    Divider(thickness: 2),
                  ],
                );
              },
            ),
          ],
        );

  String? chooseAction;

  Widget buildMenuDeletePost(int index) {
    List<String> titles = ['Delete', 'Edit'];
    return DropdownButton(
        icon: Icon(Icons.more_horiz),
        onChanged: (value) {
          setState(() {
            switch (value) {
              case 'Delete':
                confirmDeletePost(index);
                break;
              case 'Edit':
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EditPost(docId: docIdPostCustomers[index]),
                    )).then((value) => readPostCustomerData());
                break;
              default:
            }
          });
        },
        value: chooseAction,
        items: titles
            .map(
              (e) => DropdownMenuItem<String>(
                child: Text(e),
                value: e,
              ),
            )
            .toList());

    // return IconButton(
    //   onPressed: () {},
    //   icon: Icon(Icons.more_horiz),
    // );
  }

  Future<void> confirmDeletePost(int index) async {
    // print('### delete post at id = ${docIdPostCustomers[index]}');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          leading: ShowImage(),
          title: ShowText(
            title: 'Confirm Delete ?',
            textStyle: MyConstant().h2Style(),
          ),
          subtitle: ShowText(title: 'คุณต้องการลบ Post ใช่ไหม ?'),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Map<String, dynamic> data = {};
              data['status'] = 'offline';
              await Firebase.initializeApp().then((value) async {
                await FirebaseFirestore.instance
                    .collection('postcustomer')
                    .doc(docIdPostCustomers[index])
                    .update(data)
                    .then((value) => readPostCustomerData());
              });

              Navigator.pop(context);
            },
            child: Text('Confirm'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Container buildIconAnName(int index) {
    return Container(
      width: 300,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(postCustomerModels[index].pathUrl),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShowText(
                title: protectWord(postCustomerModels[index].name),
                textStyle: MyConstant().h2Style(),
              ),
              ShowText(
                title: showData(postCustomerModels[index].timePost),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container buildTitleListPost() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Row(
        children: [
          Row(
            children: [
              ShowText(
                title: 'List Post',
                textStyle: MyConstant().h2Style(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  TextEditingController replyController = TextEditingController();

  Widget buildReplyPost(int index) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CircleAvatar(
                backgroundImage: userSocial!
                    ? CachedNetworkImageProvider(User.photoURL.toString())
                    : CachedNetworkImageProvider(userModelOld!.img),
              ),
            ),
            Column(
              children: [
                Container(
                  width: 250,
                  height: 80,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 16),
                    child: TextFormField(
                      controller: replyControllers[index],
                      onChanged: (value) {
                        setState(() {
                          showPostIcons[index] = true;
                          if (value.isEmpty) {
                            showPostIcons[index] = false;
                          }
                        });
                      },
                      decoration: InputDecoration(
                        suffix: IconButton(
                          onPressed: () async {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Center(
                                    child: Text(
                                      'Choose Profile Photo',
                                      style: GoogleFonts.lato(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.purpleAccent,
                                      ),
                                    ),
                                  ),
                                  content: SingleChildScrollView(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        FlatButton.icon(
                                          onPressed: () {
                                            _imageFromCamera(index);
                                            Navigator.of(context).pop();
                                          },
                                          icon: Icon(Icons.camera,
                                              color: Colors.purpleAccent),
                                          label: Text('Camera'),
                                        ),
                                        FlatButton.icon(
                                          onPressed: () {
                                            _imageFromGallery(index);
                                            Navigator.of(context).pop();
                                          },
                                          icon: Icon(
                                            Icons.image,
                                            color: Colors.purpleAccent,
                                          ),
                                          label: Text('Gallery'),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          icon: Icon(Icons.camera_alt_outlined),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                files[index] == null
                    ? SizedBox()
                    : Container(
                        width: 250,
                        height: 200,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.file(files[index]!),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    files[index] = null;
                                  });
                                },
                                icon: Icon(Icons.clear))
                          ],
                        ),
                      ),
              ],
            ),
            (showPostIcons[index]) || (files[index] != null)
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: IconButton(
                      onPressed: () async {
                        if (files[index] != null) {
                          String nameFile =
                              'reply$index${Random().nextInt(10000000)}.jpg';
                          FirebaseStorage storage = FirebaseStorage.instance;
                          Reference reference =
                              storage.ref().child('replypost/$nameFile');
                          UploadTask task = reference.putFile(files[index]!);
                          await task.whenComplete(() async {
                            await reference
                                .getDownloadURL()
                                .then((value) async {
                              urlImagePostStr = value.toString();
                              files[index] = null;
                              await processAddReply(index);
                            });
                          });
                        } else {
                          await processAddReply(index);
                        }
                      },
                      icon: Icon(Icons.send_outlined),
                    ),
                  )
                : SizedBox(),
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemCount: listReplyPostModels[index].length,
          itemBuilder: (context, index2) => Container(
            margin: EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 36, right: 8, top: 4, bottom: 4),
                  child: Container(
                    width: 36,
                    height: 36,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          listReplyPostModels[index][index2].pathImage),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(30)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShowText(
                              title: listReplyPostModels[index][index2].name,
                              textStyle: MyConstant().h2Style(),
                            ),
                            ShowText(
                              title: dateCut(
                                  listReplyPostModels[index][index2].timeReply),
                              textStyle: MyConstant().h4Style(),
                            ),
                            Container(
                              constraints: BoxConstraints(maxWidth: 220),
                              child: ShowText(
                                  title:
                                      listReplyPostModels[index][index2].reply),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ((listReplyPostModels[index][index2].urlImagePost ==
                                null) ||
                            (listReplyPostModels[index][index2]
                                .urlImagePost
                                .isEmpty))
                        ? SizedBox()
                        : Container(
                            margin: EdgeInsets.symmetric(vertical: 16),
                            width: 250,
                            height: 200,
                            child: InkWell(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ShowImagePost(
                                      pathImage: listReplyPostModels[index]
                                              [index2]
                                          .urlImagePost),
                                ),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: listReplyPostModels[index][index2]
                                    .urlImagePost,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                    listOflistAnswerModels[index][index2].isEmpty
                        ? SizedBox()
                        : createGroupAnswer(
                            listOflistAnswerModels[index][index2],
                            index,
                            index2,
                            listOflistIdAnswers[index][index2],
                          ),
                    TextButton(
                      onPressed: () {
                        print(
                            '### index => $index, index2 => $index2, iconAnswer ==> ${listIconAnswers[index][index2]}');
                        setState(() {
                          listTextFieldAnswers[index][index2] = true;
                        });
                      },
                      child: ShowText(title: 'ตอบกลับ'),
                    ),
                    listTextFieldAnswers[index][index2]
                        ? Column(
                            children: [
                              Row(
                                children: [
                                  userSocial!
                                      ? Text('iconaa')
                                      : Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 4),
                                          width: 36,
                                          height: 36,
                                          child: CircleAvatar(
                                            backgroundImage:
                                                CachedNetworkImageProvider(
                                                    userModelOld!.img),
                                          ),
                                        ),
                                  Container(
                                    width: 150,
                                    child: TextFormField(
                                      onChanged: (value) {
                                        setState(() {
                                          if (value.isNotEmpty) {
                                            listIconAnswers[index][index2] =
                                                true;
                                            listAnswers[index][index2] =
                                                value.trim();
                                          } else {
                                            listIconAnswers[index][index2] =
                                                false;
                                          }
                                        });
                                        print(
                                            '### iconAnswer After Click ==> ${listIconAnswers[index][index2]}');
                                      },
                                      decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                            onPressed: () async {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                  title: ListTile(
                                                    leading: ShowImage(),
                                                    title: ShowText(
                                                      title:
                                                          'Choose Source Image ?',
                                                      textStyle: MyConstant()
                                                          .h2Style(),
                                                    ),
                                                    subtitle: ShowText(
                                                        title:
                                                            'Please Choose Camera or Gallery'),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        answerTakePhoto(
                                                            ImageSource.camera,
                                                            index,
                                                            index2);
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text('Camera'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        answerTakePhoto(
                                                            ImageSource.gallery,
                                                            index,
                                                            index2);
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text('Gallery'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      child: Text('Cancel'),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                            icon: Icon(
                                                Icons.add_a_photo_outlined)),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                      ),
                                    ),
                                  ),
                                  ((listIconAnswers[index][index2]) ||
                                          (listFilePostAnswers[index][index2] !=
                                              null))
                                      ? IconButton(
                                          onPressed: () async {
                                            String answer =
                                                listAnswers[index][index2];

                                            String namePost, urlPost;
                                            if (userSocial!) {
                                              namePost = User.displayName!;
                                              urlPost = User.photoURL!;
                                            } else {
                                              namePost = userModelOld!.name;
                                              urlPost = userModelOld!.img;
                                            }

                                            DateTime dateTime = DateTime.now();
                                            Timestamp timePost =
                                                Timestamp.fromDate(dateTime);

                                            if (listFilePostAnswers[index]
                                                    [index2] ==
                                                null) {
                                              AnswerModel answerModel =
                                                  AnswerModel(
                                                      answer: answer,
                                                      namePost: namePost,
                                                      urlPost: urlPost,
                                                      urlImage: '',
                                                      timePost: timePost,
                                                      status: 'online');
                                              processInsertAnswer(
                                                  answerModel, index, index2);
                                            } else {
                                              await Firebase.initializeApp()
                                                  .then((value) async {
                                                String nameFile =
                                                    'answer$index$index2${Random().nextInt(1000000)}.jpg';
                                                FirebaseStorage storage =
                                                    FirebaseStorage.instance;
                                                Reference reference = storage
                                                    .ref()
                                                    .child('answer/$nameFile');
                                                UploadTask task =
                                                    reference.putFile(
                                                        listFilePostAnswers[
                                                            index][index2]!);
                                                await task
                                                    .whenComplete(() async {
                                                  await reference
                                                      .getDownloadURL()
                                                      .then((value) {
                                                    String urlImage =
                                                        value.toString();
                                                    AnswerModel answerModel =
                                                        AnswerModel(
                                                            answer: answer,
                                                            namePost: namePost,
                                                            urlPost: urlPost,
                                                            urlImage: urlImage,
                                                            timePost: timePost,
                                                            status: 'online');
                                                    processInsertAnswer(
                                                        answerModel,
                                                        index,
                                                        index2);
                                                  });
                                                });
                                              });
                                            }

                                            print(
                                                '### answer ==> $answer, namePost ==> $namePost');
                                            print('### urlPost = $urlPost');
                                          },
                                          icon:
                                              Icon(Icons.cloud_upload_outlined),
                                        )
                                      : SizedBox(),
                                ],
                              ),
                              listFilePostAnswers[index][index2] == null
                                  ? SizedBox()
                                  : Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 16),
                                          width: 150,
                                          height: 130,
                                          child: Image.file(
                                            listFilePostAnswers[index][index2]!,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              setState(() {
                                                listFilePostAnswers[index]
                                                    [index] = null;
                                              });
                                            },
                                            icon: Icon(Icons.cancel_outlined))
                                      ],
                                    ),
                            ],
                          )
                        : SizedBox(),
                  ],
                ),
                userSocial!
                    ? SizedBox()
                    : User.uid == listReplyPostModels[index][index2].uid
                        ? IconButton(
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: ListTile(
                                    leading: ShowImage(),
                                    title: ShowText(
                                      title: 'Confirm Delete ?',
                                      textStyle: MyConstant().h2Style(),
                                    ),
                                    subtitle: ShowText(
                                        title: listReplyPostModels[index]
                                                [index2]
                                            .reply),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        Map<String, dynamic> data = {};
                                        data['status'] = 'offline';

                                        // print(
                                        //     '### docId of Postcustomer ==>> ${docIdPostCustomers[index]}');
                                        // print(
                                        //     '### docId of ReplyPost ==>> ${listDocIdReplys[index][index2]}');

                                        await FirebaseFirestore.instance
                                            .collection('postcustomer')
                                            .doc(docIdPostCustomers[index])
                                            .collection('replypost')
                                            .doc(listDocIdReplys[index][index2])
                                            .update(data)
                                            .then((value) {
                                          print('### update Success');
                                          readPostCustomerData();
                                          Navigator.pop(context);
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
                            icon: Icon(Icons.delete_forever_outlined),
                          )
                        : SizedBox(),
              ],
            ),
          ),
        ),
      ],
    );
  } // end

  Future<void> processAddReply(int index) async {
    String reply = replyControllers[index].text;
    // print('### reply = $reply');
    DateTime dateTime = DateTime.now();
    Timestamp timestamp = Timestamp.fromDate(dateTime);
    String name = userModelOld!.name;
    String pathImage = userModelOld!.img;
    String uid = userModelOld!.uid;
    ReplyPostModel replyPostModel = ReplyPostModel(
      name: name,
      pathImage: pathImage,
      reply: reply,
      timeReply: timestamp,
      uid: uid,
      urlImagePost: urlImagePostStr,
      status: '',
    );
    await FirebaseFirestore.instance
        .collection('postcustomer')
        .doc(docIdPostCustomers[index])
        .collection('replypost')
        .doc()
        .set(replyPostModel.toMap())
        .then((value) {
      setState(() {
        replyControllers[index].text = '';
        showPostIcons[index] = false;
        readPostCustomerData();
      });
    });
  }

  Widget showGridImage(List<String> pathImages) {
    return pathImages.isEmpty
        ? SizedBox()
        : GridView.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200),
            itemBuilder: (context, index) => Container(
              width: 150,
              height: 150,
              child: InkWell(
                onTap: () {
                  // print('## ${pathImages[index]}');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ShowImagePost(pathImage: pathImages[index])));
                },
                child: CachedNetworkImage(
                  imageUrl: pathImages[index],
                  fit: BoxFit.cover,
                  placeholder: (context, url) => ShowProgress(),
                  errorWidget: (context, url, error) => ShowImage(),
                ),
              ),
            ),
            itemCount: pathImages.length,
            physics: ScrollPhysics(),
            shrinkWrap: true,
          );
  }

  UserModelOld? MyUserModelOld;

  Future<void> findUserLogin(String uid) async {
    await FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo: uid)
        .get()
        .then((value) {
      for (var item in value.docs) {
        setState(() {
          MyUserModelOld = UserModelOld.fromMap(item.data());
        });
      }
    });
  }

  GridView gridViewTypeTechnic() {
    return GridView.builder(
      gridDelegate:
          SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 250),
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: serviceGroups.length,
      itemBuilder: (context, index) => InkWell(
        onTap: () {
          if (provinceChoosed == null) {
            MyDialog().normalDialog(
                context, 'Non Province', 'Please Choose Province');
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListTechnicWhereType(
                      province: provinceChoosed!,
                      typeTechnic: serviceGroups[index]),
                ));
          }
        },
        child: Card(
            color: colors[index],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  child: ShowImage(
                    path: paths[index],
                  ),
                ),
                ShowText(
                  title: serviceGroups[index],
                  textStyle: MyConstant().h2Style(),
                ),
              ],
            )),
      ),
    );
  }

  FloatingActionButton buildFloating(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreatePost(province: provinceChoosed!),
          ),
        ).then((value) => readPostCustomerData());
      },
      child: Icon(
        Icons.edit_rounded,
      ),
    );
  }

  Container serviceGridView() {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15),
      child: GridView.count(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        children: [
          Card(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/images/aircon.png', color: Colors.blue),
                  Text(
                    'Airconditioner',
                    style: GoogleFonts.lato(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text('Installing Airconditioner'),
                  Text('and fixing accessary')
                ],
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            color: Colors.amberAccent,
          ),
          Card(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/electricity.png',
                  ),
                  Text(
                    'Electricity',
                    style: GoogleFonts.lato(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text('Design Installing and fixing'),
                  Text('electricity systems'),
                ],
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            color: Colors.redAccent,
          ),
          Card(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/toilet.png',
                  ),
                  Text(
                    'Plumbling',
                    style: GoogleFonts.lato(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text('Design Installing and fixing'),
                  Text('asseecsary of toilet'),
                ],
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            color: Colors.pinkAccent,
          ),
        ],
      ),
    );
  }

  Padding buildTitle() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text(
        'Our Services',
        style: GoogleFonts.lato(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  CarouselSlider buildBanner() {
    return CarouselSlider(
      items: [0, 1, 2, 3].map((item) {
        return Image.asset(
          'assets/images/display_login.jpg',
          fit: BoxFit.cover,
          width: 300,
        );
      }).toList(),
      options: CarouselOptions(
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 2,
      ),
    );
  }

  Container dropdownProvince() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      margin: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: DropdownButton(
        value: provinceChoosed,
        hint: Text(
          'Please Choose your area',
        ),
        onChanged: (value) {
          docIdPostCustomers.clear();
          postCustomerModels.clear();
          loadPost = true;

          setState(() {
            provinceChoosed = value.toString();
            findServiceGroup();
          });

          readPostCustomerData();
        },
        items: provinces
            .map(
              (e) => DropdownMenuItem<String>(
                child: Text(e),
                value: e,
              ),
            )
            .toList(),
      ),
    );
  }

  Drawer buildDrawer(BuildContext context) {
    return Drawer(
      child: Material(
        color: Colors.blue,
        child: ListView(
          children: [
            InkWell(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginSuccess(),
                    ),
                    (route) => false);
              },
              child: DrawerHeader(
                padding: EdgeInsets.fromLTRB(10, 60, 10, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(User.photoURL == null
                            ? userModelOld!.img.isEmpty
                                ? MyConstant.urlNoAvatar
                                : userModelOld!.img
                            : User.photoURL!)),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          User.displayName == null
                              ? userModelOld!.name
                              : User.displayName!,
                          style: GoogleFonts.lato(
                            fontSize: 17,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          User.email!,
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ListTile(
                leading: Icon(
                  Icons.notification_important_outlined,
                ),
                title: Text('Notification'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CustomerNotification()));
                },
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ListTile(
                leading: Icon(
                  Icons.shopping_bag_outlined,
                ),
                title: Text('Order History'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CustomerOrderHistory()));
                },
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ListTile(
                leading: Icon(Icons.person_pin_circle_sharp),
                title: Text('About Us'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CustomerAboutUs()));
                },
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ListTile(
                leading: Icon(
                  Icons.message_outlined,
                ),
                title: Text(
                  'Contact Us',
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CustomerContactUs()));
                },
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ListTile(
                leading: Icon(
                  Icons.label_important_outlined,
                ),
                title: Text('How to use App'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CustomerHowtouseApp()));
                },
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ListTile(
                leading: Icon(
                  Icons.warning_amber_outlined,
                ),
                title: Text('Term and Conditon'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CustomerTermandConditon()));
                },
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ListTile(
                leading: Icon(
                  Icons.power_settings_new,
                ),
                title: Text('SignOut'),
                onTap: () {
                  SocialService().signOut();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LoginPage()),
                      (route) => false);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> readPostCustomerData() async {
    buildSetup();

    await FirebaseFirestore.instance
        .collection('postcustomer')
        .orderBy('timePost', descending: true)
        .get()
        .then((value) async {
      for (var item in value.docs) {
        PostCustomerModel postCustomerModel =
            PostCustomerModel.fromMap(item.data());
        if (postCustomerModel.status != 'offline') {
          if (postCustomerModel.province == provinceChoosed) {
            List<ReplyPostModel> replyPostModels = [];
            String docIdPostcustomer = item.id;

            List<bool> textFieldAnswers = [];
            List<bool> iconAnswers = [];
            List<File?> postFileAnswers = [];
            List<String> answers = [];
            List<String> docIdReplyAnswers = [];
            List<List<AnswerModel>> listAnswerModels = [];
            List<List<String>> listIdAnswers = [];

            List<String> myDocIdReplyPosts = [];

            await FirebaseFirestore.instance
                .collection('postcustomer')
                .doc(docIdPostcustomer)
                .collection('replypost')
                .orderBy('timeReply', descending: true)
                .get()
                .then((value) async {
              for (var item in value.docs) {
                textFieldAnswers.add(false);
                iconAnswers.add(false);
                postFileAnswers.add(null);
                answers.add('');
                docIdReplyAnswers.add(item.id);

                String docIdReply = item.id;

                ReplyPostModel replyPostModel =
                    ReplyPostModel.fromMap(item.data());

                if (replyPostModel.status != 'offline') {
                  String myDocIdReplyPost = item.id;
                  myDocIdReplyPosts.add(myDocIdReplyPost);

                  replyPostModels.add(replyPostModel);
                  docIdReplys.add(docIdReply);

                  List<AnswerModel> answerModels = [];
                  List<String> idAnswers = [];

                  await FirebaseFirestore.instance
                      .collection('postcustomer')
                      .doc(docIdPostcustomer)
                      .collection('replypost')
                      .doc(docIdReply)
                      .collection('answer')
                      .get()
                      .then((value) {
                    for (var item in value.docs) {
                      // print('@@ item ==> ${item.data()}');
                      AnswerModel answerModel =
                          AnswerModel.fromMap(item.data());
                      answerModels.add(answerModel);

                      String idAnswer = item.id;
                      idAnswers.add(idAnswer);
                    }
                  });

                  listAnswerModels.add(answerModels);
                  listIdAnswers.add(idAnswers);
                }
              }
            });

            // int i = 0;
            setState(() {
              loadPost = false;
              postCustomerModels.add(postCustomerModel);
              docIdPostCustomers.add(docIdPostcustomer);
              listReplyPostModels.add(replyPostModels);
              listDocIdReplys.add(docIdReplys);
              listTextFieldAnswers.add(textFieldAnswers);
              listIconAnswers.add(iconAnswers);
              listFilePostAnswers.add(postFileAnswers);
              listAnswers.add(answers);
              listDocIdReplyAnswers.add(docIdReplyAnswers);
              listOflistAnswerModels.add(listAnswerModels);
              listOflistIdAnswers.add(listIdAnswers);

              myListDocIdReplyPosts.add(myDocIdReplyPosts);
            });
            // i++;
          }
        }
      }
    });
  }

  String protectWord(String name) {
    String result = name;
    // result = result.substring(0, 3);
    // result = '$result xxxxx';
    return result;
  }

  String cutWord(String string) {
    String result = string;
    // if (result.length > 150) {
    // result = result.substring(0, 150);
    // result = '$result ...';
    // }

    return result;
  }

  String showData(Timestamp timePost) {
    // print('### timePOst ==> $timePost');
    String result;

    DateTime dateTime = timePost.toDate();
    // print('### dateTime ==>> $dateTime');
    DateFormat dateFormt = DateFormat('dd MMM yyyy    HH:mm');
    result = dateFormt.format(dateTime);

    return result;
  }

  String dateCut(Timestamp timeReply) {
    DateTime dateTime = timeReply.toDate();
    DateFormat dateFormat = DateFormat('dd-MMM-yyyy HH:mm');
    String result = dateFormat.format(dateTime);
    return result;
  }

  Future<void> answerTakePhoto(
      ImageSource source, int index, int index2) async {
    try {
      var result = await ImagePicker().getImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
      );
      setState(() {
        listFilePostAnswers[index][index2] = File(result!.path);
      });
    } catch (e) {}
  }

  Future<void> processInsertAnswer(
    AnswerModel answerModel,
    int index,
    int index2,
  ) async {
    // print('@@ processInsertAnswer Work');
    String docIdPostCustomer = docIdPostCustomers[index];
    String docIdReplyAnswer = listDocIdReplyAnswers[index][index2];
    // print('@@ docIdPostCustomer = $docIdPostCustomer');
    // print('@@ docIdReplyAnswer = $docIdReplyAnswer');

    await Firebase.initializeApp().then((value) async {
      await FirebaseFirestore.instance
          .collection('postcustomer')
          .doc(docIdPostCustomer)
          .collection('replypost')
          .doc(docIdReplyAnswer)
          .collection('answer')
          .doc()
          .set(answerModel.toMap())
          .then((value) {
        readPostCustomerData();
      });
    });
  }

  Widget createGroupAnswer(List<AnswerModel> answerModels, int index,
      int index2, List<String> idAnswers) {
    List<Widget> widgets = [];

    int i = 0;
    for (var item in answerModels) {
      if (item.status == 'online') {
        widgets.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    width: 36,
                    height: 36,
                    child: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                        item.urlPost,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.grey.shade300,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShowText(
                            title: item.namePost,
                            textStyle: MyConstant().h2Style(),
                          ),
                          ShowText(
                              title: TimeToString(timestamp: item.timePost)
                                  .findString()),
                          Container(
                            constraints: BoxConstraints(maxWidth: 150),
                            child: ShowText(title: item.answer),
                          ),
                        ],
                      ),
                    ),
                  ),
                  nameUserLogin == item.namePost
                      ? IconButton(
                          onPressed: () async {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: ListTile(
                                  leading: ShowImage(),
                                  title: ShowText(title: 'Confrim Delete'),
                                  subtitle: ShowText(title: item.answer),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: ()async {
                                      Navigator.pop(context);

                                      Timestamp timestamp = item.timePost;
                            print('@@@ index = $index, index2 = $index2');
                            print(
                                '@@@ docPostcustomer ==> ${docIdPostCustomers[index]}');
                            print(
                                '@@@ myDocId ===>>> ${myListDocIdReplyPosts[index]}');
                            // print(
                            //     '@@@ docPostcustorer ==> ${docIdPostCustomers}');
                            print(
                                '@@@ docReplypost ==> ${myListDocIdReplyPosts[index][index2]}');
                            Map<String, dynamic> map = {};
                            map['status'] = 'offline';

                            await FirebaseFirestore.instance
                                .collection('postcustomer')
                                .doc(docIdPostCustomers[index])
                                .collection('replypost')
                                .doc(myListDocIdReplyPosts[index][index2])
                                .collection('answer')
                                .where('timePost', isEqualTo: timestamp)
                                .get()
                                .then((value) async {
                              for (var item in value.docs) {
                                String docAnswer = item.id;
                                print('@@@ docAnswer ==> $docAnswer');

                                await FirebaseFirestore.instance
                                    .collection('postcustomer')
                                    .doc(docIdPostCustomers[index])
                                    .collection('replypost')
                                    .doc(myListDocIdReplyPosts[index][index2])
                                    .collection('answer')
                                    .doc(docAnswer)
                                    .update(map)
                                    .then((value) => readPostCustomerData());
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
              item.urlImage.isEmpty
                  ? SizedBox()
                  : Container(
                      margin: EdgeInsets.only(left: 52),
                      width: 150,
                      height: 120,
                      child: InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ShowImagePost(pathImage: item.urlImage),
                          ),
                        ),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: item.urlImage,
                          placeholder: (context, url) => ShowProgress(),
                        ),
                      ),
                    ),
            ],
          ),
        );
      }
      i++;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      ),
    );
  }
}
