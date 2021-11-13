import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:joelfindtechnician/customer_state/ctm_aboutus.dart';
import 'package:joelfindtechnician/customer_state/ctm_contactus.dart';
import 'package:joelfindtechnician/customer_state/ctm_howtouseapp.dart';
import 'package:joelfindtechnician/customer_state/ctm_notification.dart';
import 'package:joelfindtechnician/customer_state/ctm_ordethistory.dart';
import 'package:joelfindtechnician/customer_state/ctm_termandconditon.dart';
import 'package:joelfindtechnician/state/login_page.dart';
import 'package:joelfindtechnician/customer_state/social_service.dart';
import 'package:joelfindtechnician/state/community_page.dart';

class LoginSuccess extends StatefulWidget {
  @override
  _LoginSuccessState createState() => _LoginSuccessState();
}

class _LoginSuccessState extends State<LoginSuccess> {
  final User = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundImage: NetworkImage(User.photoURL!),
                  ),
                  SizedBox(height: 8),
                  Text(
                    User.displayName!,
                    style: GoogleFonts.lato(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    ' ' + User.email!,
                    style: GoogleFonts.lato(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 40),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: FlatButton(
                        padding: EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        color: Color(0xFFF5F6F9),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CommunityPage(userSocialbol: true,)));
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.design_services_outlined,
                              color: Colors.orange,
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Text(
                                'Go to Service',
                                style: GoogleFonts.lato(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios)
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: FlatButton(
                        padding: EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        color: Color(0xFFF5F6F9),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CustomerNotification()));
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.notification_important_outlined,
                              color: Colors.orange,
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Text(
                                'Notification',
                                style: GoogleFonts.lato(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios)
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: FlatButton(
                        padding: EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        color: Color(0xFFF5F6F9),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CustomerOrderHistory()));
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.shopping_bag_outlined,
                              color: Colors.orange,
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Text(
                                'Order History',
                                style: GoogleFonts.lato(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios)
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: FlatButton(
                        padding: EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        color: Color(0xFFF5F6F9),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CustomerAboutUs()));
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.person_pin_circle_outlined,
                              color: Colors.orange,
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Text(
                                'About Us',
                                style: GoogleFonts.lato(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios)
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: FlatButton(
                        padding: EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        color: Color(0xFFF5F6F9),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CustomerContactUs()));
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.message_outlined,
                              color: Colors.orange,
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Text(
                                'Contact Us',
                                style: GoogleFonts.lato(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios)
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: FlatButton(
                        padding: EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        color: Color(0xFFF5F6F9),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CustomerHowtouseApp()));
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.label_important_outline,
                              color: Colors.orange,
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Text(
                                'How to use App',
                                style: GoogleFonts.lato(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios)
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: FlatButton(
                        padding: EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        color: Color(0xFFF5F6F9),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CustomerTermandConditon()));
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.warning_amber_outlined,
                              color: Colors.orange,
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Text(
                                'Term and condition',
                                style: GoogleFonts.lato(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios)
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: FlatButton(
                        padding: EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        color: Color(0xFFF5F6F9),
                        onPressed: () {
                          SocialService().signOut();
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.power_settings_new,
                              color: Colors.orange,
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Text(
                                'SignOut',
                                style: GoogleFonts.lato(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios)
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
