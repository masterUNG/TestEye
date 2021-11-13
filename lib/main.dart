// @dart=2.9

import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:joelfindtechnician/customer_state/create_post.dart';
import 'package:joelfindtechnician/customer_state/login_success.dart';
import 'package:joelfindtechnician/partner_state/home_page.dart';
import 'package:joelfindtechnician/state/community_page.dart';
import 'package:joelfindtechnician/state/login_page.dart';


final Map<String, WidgetBuilder> map = {
  // '/loginPage': (BuildContext context) => LoginPage(),
  // '/homePage': (BuildContext context) => HomePage(),
  // '/authenAdmin': (BuildContext context) => AuthenAdmin(),
  // '/adminService': (BuildContext context) => AdminService(),
  // '/myReferance': (BuildContext context) => MyReferance(),
  // '/addReferance': (BuildContext context) => AddReferance(),
};

String firstPage;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // firstPage = '/loginPage';
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:LoginPage(),
      // routes: map,
      // initialRoute: firstPage,
    );
  }
}

class Splash extends StatefulWidget {
  const Splash({Key key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[700],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              '',
              height: 120,
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
