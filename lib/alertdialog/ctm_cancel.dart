import 'package:flutter/material.dart';
import 'package:joelfindtechnician/alertdialog/ctmCancel_success.dart';

class CustomerCancel {
  Future<Null> normalDialog(
      BuildContext context, String title, String message) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          leading: Icon(Icons.warning),
          title: Text(title),
          subtitle: Text(message),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CustomerCancelSuccess()),
                  (route) => true),
              child: Text('OK'))
        ],
      ),
    );
  }
}
