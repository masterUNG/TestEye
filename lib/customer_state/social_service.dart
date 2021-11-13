import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:joelfindtechnician/alertdialog/error_reset.dart';
import 'package:joelfindtechnician/alertdialog/error_signup.dart';
import 'package:joelfindtechnician/alertdialog/success_reset.dart';
import 'package:joelfindtechnician/alertdialog/success_signup.dart';
import 'package:joelfindtechnician/customer_state/login_success.dart';
import 'package:joelfindtechnician/partner_state/home_page.dart';
import '../alertdialog/error_signin.dart';

class SocialService {
  // signUp(String email, String password, context) {
  // return FirebaseAuth.instance
  // .createUserWithEmailAndPassword(email: email, password: password)
  // .then((value) async {
  // print('Signup Success');

  // showDialog(
  // context: context,
  // builder: (context) =>
  // SignUpSuccess(title: '', discription: '', buttonText: ''));
  // }).catchError((e) {
  // SignUpError(title: '', discription: '', buttonText: '')
  // .errorsignup(context, e);
  // });
  // }

  resetPasswordLink(String email, context) {
    FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((value) {
      print('success');
      showDialog(
          context: context,
          builder: (context) => SuccessResetPassword(
              title: 'Success', discription: '', buttonText: ''));
    }).catchError((e) {
      ErrorResetPassword(title: '', discription: '', buttonText: '')
          .errordialog(context, e);
    });
  }

  Future<void> signIn(String email, String password, context) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((val) async {

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    }).catchError((e) {
      ErrorSignIn(buttonText: '', title: '', discription: '')
          .errorDialog(context, e);
    });
  }

  signOut() {
    FirebaseAuth.instance.signOut();
  }

  loginfb(context) async {
    final fb = FacebookLogin();

    final res = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);

    switch (res.status) {
      case FacebookLoginStatus.success:
        final FacebookAccessToken accessToken = res.accessToken!;
        final AuthCredential authCredential =
            FacebookAuthProvider.credential(accessToken.token);
        final result =
            await FirebaseAuth.instance.signInWithCredential(authCredential);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => LoginSuccess(),
          ),
        );

        final profile = await fb.getUserProfile();
        print('Hello, ${profile!.name}! You ID: ${profile.userId}');

        final imageUrl = await fb.getProfileImageUrl(width: 100);
        print('Your profile image: $imageUrl');

        final email = await fb.getUserEmail();

        if (email != null) print('And your email is $email');

        break;
      case FacebookLoginStatus.cancel:
        break;
      case FacebookLoginStatus.error:
        print('Error while log in: ${res.error}');
        break;
    }
  }

  Future<void> googlesignIn(context) async {
    
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginSuccess(),
      ),
    );
  }
}
