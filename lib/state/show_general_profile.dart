import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:joelfindtechnician/customer_state/social_service.dart';
import 'package:joelfindtechnician/models/reference_model.dart';
import 'package:joelfindtechnician/models/user_model_old.dart';
import 'package:joelfindtechnician/partner_state/choose_image.dart';
import 'package:joelfindtechnician/partner_state/edditTest.dart';

import 'package:joelfindtechnician/partner_state/home_page.dart';
import 'package:joelfindtechnician/partner_state/mywallet.dart';
import 'package:joelfindtechnician/partner_state/partner_aboutus.dart';
import 'package:joelfindtechnician/partner_state/partner_contactus.dart';
import 'package:joelfindtechnician/partner_state/partner_howtouseapp.dart';
import 'package:joelfindtechnician/partner_state/partner_notification.dart';
import 'package:joelfindtechnician/partner_state/partner_orderhistory.dart';
import 'package:joelfindtechnician/partner_state/partner_signin.dart';
import 'package:joelfindtechnician/partner_state/partner_termandconditon.dart';

import 'package:joelfindtechnician/state/community_page.dart';
import 'package:joelfindtechnician/state/show_photo_ref.dart';

import 'package:joelfindtechnician/state/show_review.dart';

import 'package:joelfindtechnician/utility/my_constant.dart';
import 'package:joelfindtechnician/widgets/show_progress.dart';

class ShowGeneralProfile extends StatefulWidget {
  final String uidTechnic;
  const ShowGeneralProfile({Key? key, required this.uidTechnic})
      : super(key: key);

  @override
  _ShowGeneralProfileState createState() => _ShowGeneralProfileState();
}

class _ShowGeneralProfileState extends State<ShowGeneralProfile> {
  SpeedDial _speedDial() {
    return SpeedDial(
      onPress: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChooseImage(
              userModelOld: userModelOld!,
            ),
          ),
        ).then((value) => findReference());
      },
      animatedIconTheme: IconThemeData(size: 25),
      child: Icon(Icons.add),
    );
  }

  final databaseReference = FirebaseFirestore.instance;
  var firebaseUser = FirebaseAuth.instance.currentUser!;

  String? docUser;

  UserModelOld? userModelOld;
  List<ReferenceModel> referenceModels = [];
  bool load = true;
  List<String> docIdRefs = [];
  String? uidTechnic;

  @override
  void initState() {
    super.initState();

    uidTechnic = widget.uidTechnic;
    print('##### uidTechnic => $uidTechnic');

    findUser();
  }

  Future<Null> findUser() async {
    await Firebase.initializeApp().then((value) async {
      final firebaseUser = FirebaseAuth.instance.currentUser;

      await FirebaseFirestore.instance
          .collection('user')
          .where('uid', isEqualTo: uidTechnic)
          .get()
          .then((value) {
        for (var item in value.docs) {
          docUser = item.id;
          setState(() {
            userModelOld = UserModelOld.fromMap(item.data());
            findReference();
          });
        }
      });
    });
  }

  Future<void> findReference() async {
    if (referenceModels.isNotEmpty) {
      referenceModels.clear();
    }
    await Firebase.initializeApp().then((value) async {
      await FirebaseFirestore.instance
          .collection('user')
          .where('uid', isEqualTo: userModelOld!.uid)
          .get()
          .then((value) async {
        for (var item in value.docs) {
          String docId = item.id;
          await FirebaseFirestore.instance
              .collection('user')
              .doc(docId)
              .collection('referjob')
              .orderBy('datejob', descending: true)
              .get()
              .then((value) {
            print('#### value findreference ==> ${value.docs}');
            if (value.docs.isNotEmpty) {
              for (var item in value.docs) {
                ReferenceModel model = ReferenceModel.fromMap(item.data());
                setState(() {
                  referenceModels.add(model);
                  docIdRefs.add(item.id);
                  load = false;
                });
              }
            } else {
              setState(() {
                load = false;
              });
            }
          });
        }
      });
    });
  }

  final User = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppbar(context),
      floatingActionButton: _speedDial(),
      endDrawer: buildDrawer(context),
      body: userModelOld == null ? ShowProgress() : buildContent(),
    );
  }

  Widget buildContent() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 10),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
            child: CircleAvatar(
              radius: 35,
              backgroundImage: userModelOld!.img.isEmpty
                  ? NetworkImage(MyConstant.urlNoAvatar)
                  : NetworkImage(userModelOld!.img),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, top: 5),
            child: Text(
              userModelOld!.name,
              style: GoogleFonts.lato(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Text(
              userModelOld!.jobScope,
              style: GoogleFonts.lato(
                fontSize: 17,
                color: Colors.grey,
              ),
            ),
          ),
          builButton(),
          load
              ? ShowProgress()
              : referenceModels.isEmpty
                  ? Expanded(child: Center(child: Text('no reference')))
                  : listReference(),
        ],
      );

  Widget listReference() => Padding(
        padding: const EdgeInsets.all(4.0),
        child: GridView.builder(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            maxCrossAxisExtent: 160,
          ),
          itemBuilder: (context, index) => GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ShowPhotoRefer(
                  referenceModel: referenceModels[index],
                  docIdRef: docIdRefs[index],
                  docUser: docUser!,
                ),
              ),
            ).then((value) => findReference()),
            child: Container(
              width: 100,
              height: 100,
              child: Image.network(referenceModels[index].image,
                  fit: BoxFit.cover),
            ),
          ),
          itemCount: referenceModels.length,
        ),
      );

  Row builButton() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 5, top: 8),
            child: FlatButton(
              height: 40,
              // minWidth: 170,
              color: Colors.blue,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ShowReview()));
              },
              child: Text(
                'Review',
                style: GoogleFonts.lato(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        // Expanded(
        // flex: 1,
        // child: Padding(
        // padding: const EdgeInsets.only(
        // top: 8,
        // ),
        // child: FlatButton(
        // height: 40,
        // minWidth: 170,
        // color: Colors.blue,
        // onPressed: () {
        // Navigator.push(
        // context,
        // MaterialPageRoute(
        // builder: (context) =>
        // EdditTest(userModelOld: userModelOld!),
        // ),
        // ).then((value) => findUser());
        // },
        // child: Text(
        // 'Eddit Profile',
        // style: GoogleFonts.lato(
        // color: Colors.white,
        // fontWeight: FontWeight.bold,
        // fontSize: 17,
        // ),
        // ),
        // shape: RoundedRectangleBorder(
        // borderRadius: BorderRadius.circular(10),
        // ),
        // ),
        // ),
        // ),
      ],
    );
  } // end column

  StreamBuilder<QuerySnapshot<Map<String, dynamic>>> buildStream() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('user').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView(
            children: snapshot.data!.docs.map(
          (e) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
                  child: CircleAvatar(
                    radius: 35,
                    backgroundImage: NetworkImage(e['img']),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, top: 5),
                  child: Text(
                    e['name'],
                    style: GoogleFonts.lato(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                  child: Text(
                    e['about'],
                    style: GoogleFonts.lato(
                      fontSize: 17,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 5, top: 8),
                      child: FlatButton(
                        height: 40,
                        minWidth: 170,
                        color: Colors.blue,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ShowReview()));
                        },
                        child: Text(
                          'Review',
                          style: GoogleFonts.lato(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 8,
                      ),
                      child: FlatButton(
                        height: 40,
                        minWidth: 170,
                        color: Colors.blue,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EdditTest(userModelOld: userModelOld!),
                            ),
                          ).then((value) => findUser());
                        },
                        child: Text(
                          'Eddit Profile',
                          style: GoogleFonts.lato(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ); // end column
          },
        ).toList());
      },
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
                title: Text('Go to services'),
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PartnerNotification()));
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

  AppBar buildAppbar(BuildContext context) {
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
      title: Text('Show Profile'),
    );
  }
}
