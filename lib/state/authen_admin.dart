import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:joelfindtechnician/alertdialog/my_dialog.dart';
import 'package:joelfindtechnician/state/admin_service.dart';
import 'package:joelfindtechnician/utility/my_constant.dart';

class AuthenAdmin extends StatefulWidget {
  const AuthenAdmin({Key? key}) : super(key: key);

  @override
  _AuthenAdminState createState() => _AuthenAdminState();
}

class _AuthenAdminState extends State<AuthenAdmin> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Auhten Admin'),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                buildEmail(),
                buildPassword(),
                buildLogin(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> checkAuthen() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((value) => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> AdminService()), (route) => false));
              
    }).catchError(
        (value) => MyDialog().normalDialog(context, value.code, value.message));
  }

  ElevatedButton buildLogin() {
    return ElevatedButton(
      onPressed: () {
        if (formKey.currentState!.validate()) {
          List<String> adminEmails = MyConstant.adminEmails;
          bool status = false;
          for (var item in adminEmails) {
            if (emailController.text == item) {
              status = true;
            }
          }

          if (status) {
            print('Admin Status');
            checkAuthen();
          } else {
            MyDialog().normalDialog(context, 'Email Faill', 'No Admin');
          }
        }
      },
      child: Text('Login'),
    );
  }

  Container buildEmail() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: 250,
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please fill Email';
          } else {
            return null;
          }
        },
        controller: emailController,
        decoration: InputDecoration(
          labelText: 'email :',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Container buildPassword() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: 250,
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please fill Password';
          } else {
            return null;
          }
        },
        controller: passwordController,
        decoration: InputDecoration(
          labelText: 'Password :',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
