import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:joelfindtechnician/models/notification_model.dart';
import 'package:joelfindtechnician/models/postcustomer_model.dart';
import 'package:joelfindtechnician/models/user_model_old.dart';
import 'package:joelfindtechnician/utility/my_constant.dart';
import 'package:joelfindtechnician/utility/time_to_string.dart';
import 'package:joelfindtechnician/widgets/show_progress.dart';
import 'package:joelfindtechnician/widgets/show_text.dart';

class ShowDetailNoti extends StatefulWidget {
  final String title, message, docId;
  final UserModelOld userModelOld;
  const ShowDetailNoti(
      {Key? key,
      required this.userModelOld,
      required this.title,
      required this.message,
      required this.docId})
      : super(key: key);

  @override
  _ShowDetailNotiState createState() => _ShowDetailNotiState();
}

class _ShowDetailNotiState extends State<ShowDetailNoti> {
  String? title, message, docUser;
  List<PostCustomerModel> postCustomerModels = [];
  bool load = true;
  UserModelOld? userModelOld;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    title = widget.title;
    message = widget.message;
    docUser = widget.docId;
    userModelOld = widget.userModelOld;
    print(
        '#28nov ค่าที่ได้จากการคลิก Noti ที่ ShowDetailNoti ==>> $title, $message');
    readDataNotification();
  }

  Future<void> readDataNotification() async {
    if (postCustomerModels.isNotEmpty) {
      postCustomerModels.clear();
    }

    await Firebase.initializeApp().then((value) async {
      await FirebaseFirestore.instance
          .collection('postcustomer')
          .where('job', isEqualTo: message)
          .get()
          .then((value) {
        for (var item in value.docs) {
          PostCustomerModel model = PostCustomerModel.fromMap(item.data());
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
          : Column(
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
                newCircleAvatar(userModelOld!.img),
              ],
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
}
