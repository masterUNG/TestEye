import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:joelfindtechnician/customer_state/ctm_aboutus.dart';
import 'package:joelfindtechnician/customer_state/ctm_contactus.dart';
import 'package:joelfindtechnician/customer_state/ctm_howtouseapp.dart';
import 'package:joelfindtechnician/customer_state/ctm_notification.dart';
import 'package:joelfindtechnician/customer_state/ctm_ordethistory.dart';
import 'package:joelfindtechnician/state/login_page.dart';
import 'package:joelfindtechnician/customer_state/login_success.dart';
import 'package:joelfindtechnician/customer_state/social_service.dart';
import 'package:joelfindtechnician/state/community_page.dart';

class CustomerTermandConditon extends StatefulWidget {
  const CustomerTermandConditon({Key? key}) : super(key: key);

  @override
  _CustomerTermandConditonState createState() =>
      _CustomerTermandConditonState();
}

class _CustomerTermandConditonState extends State<CustomerTermandConditon> {
  @override
  Widget build(BuildContext context) {
    final User = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: Text('Customer Term And Condition'),
      ),
      endDrawer: Drawer(
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
                          backgroundImage: NetworkImage(User.photoURL!)),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            User.displayName!,
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
                    Icons.person_outline,
                  ),
                  title: Text('Go to services'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CommunityPage()));
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
      ),
    );
  }
}
