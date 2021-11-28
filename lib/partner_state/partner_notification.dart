import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:joelfindtechnician/customer_state/social_service.dart';
import 'package:joelfindtechnician/models/notification_model.dart';
import 'package:joelfindtechnician/models/user_model_old.dart';
import 'package:joelfindtechnician/state/community_page.dart';
import 'package:joelfindtechnician/partner_state/home_page.dart';
import 'package:joelfindtechnician/partner_state/mywallet.dart';
import 'package:joelfindtechnician/partner_state/partner_aboutus.dart';
import 'package:joelfindtechnician/partner_state/partner_contactus.dart';
import 'package:joelfindtechnician/partner_state/partner_howtouseapp.dart';
import 'package:joelfindtechnician/partner_state/partner_orderhistory.dart';
import 'package:joelfindtechnician/partner_state/partner_signin.dart';
import 'package:joelfindtechnician/partner_state/partner_termandconditon.dart';
import 'package:joelfindtechnician/state/show_detail_noti.dart';
import 'package:joelfindtechnician/utility/my_constant.dart';
import 'package:joelfindtechnician/utility/time_to_string.dart';
import 'package:joelfindtechnician/widgets/show_progress.dart';
import 'package:joelfindtechnician/widgets/show_text.dart';

class PartnerNotification extends StatefulWidget {
  final String? docUser;
  final UserModelOld? userModelOld;
  const PartnerNotification({Key? key, this.docUser, this.userModelOld})
      : super(key: key);

  @override
  _PartnerNotificationState createState() => _PartnerNotificationState();
}

class _PartnerNotificationState extends State<PartnerNotification> {
  String? docUser;
  bool load = true;
  bool? haveData;
  UserModelOld? userModelOld;

  List<NotificationModel> notificationModels = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    docUser = widget.docUser;
    userModelOld = widget.userModelOld;
    readAllNoti();
  }

  Future<void> readAllNoti() async {
    if (notificationModels.isNotEmpty) {
      notificationModels.clear();
    }

    await Firebase.initializeApp().then((value) async {
      await FirebaseFirestore.instance
          .collection('user')
          .doc(docUser)
          .collection('mynotification')
          .orderBy('timeNoti', descending: true)
          .get()
          .then((value) {
        if (value.docs.isEmpty) {
          setState(() {
            load = false;
            haveData = false;
          });
        } else {
          for (var item in value.docs) {
            NotificationModel model = NotificationModel.fromMap(item.data());
            setState(() {
              load = false;
              haveData = true;
              notificationModels.add(model);
            });
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final User = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: newAppBar(context),
      body: load
          ? ShowProgress()
          : haveData!
              ? ListView.builder(
                  itemCount: notificationModels.length,
                  itemBuilder: (context, index) => buildContent(
                    notificationModels[index].message,
                    TimeToString(timestamp: notificationModels[index].timeNoti)
                        .findString(),
                    notificationModels[index].status,
                    notificationModels[index].title,
                  ),
                )
              : Center(
                  child: ShowText(
                  title: 'ไม่มี การแจ้งเตือนเลย',
                  textStyle: MyConstant().h1Style(),
                )),
      endDrawer: newDrawer(context, User),
    );
  }

  Widget buildContent(
      String message, String dateStr, String status, String title) {
    return GestureDetector(
      onTap: () {
        print('#28nov You Click message --> $message');
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShowDetailNoti(
                  userModelOld: userModelOld!, title: title, message: message),
            ));
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blue,
            ),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 30, 0),
                child: Container(
                  width: 200,
                  child: ShowText(
                    title: message,
                    textStyle: status == 'unread'
                        ? MyConstant().h2Style()
                        : MyConstant().h4Style(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  dateStr,
                  style: GoogleFonts.lato(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Drawer newDrawer(BuildContext context, User User) {
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
                      builder: (context) => HomePage(),
                    ),
                    (route) => false);
              },
              child: DrawerHeader(
                padding: EdgeInsets.fromLTRB(10, 60, 10, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(radius: 20, backgroundColor: Colors.blue),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                  Icons.person_outline,
                ),
                title: Text('Go to service'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CommunityPage()));
                },
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ListTile(
                leading: Icon(
                  Icons.account_balance_wallet_outlined,
                ),
                title: Text('My Wallet'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyWallet()));
                },
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
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => PartnerNotification()));
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
                          builder: (context) => PartnerOrderHistory()));
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
                          builder: (context) => PartnerAboutUs()));
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
                          builder: (context) => PartnerContactUs()));
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
                          builder: (context) => PartnerHowtoUseApp()));
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
                          builder: (context) => PartnerTermAndCondiotion()));
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
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => PartnerSignin()),
                      (route) => false);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar newAppBar(BuildContext context) {
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
      title: Text('Partner Notification'),
    );
  }
}
