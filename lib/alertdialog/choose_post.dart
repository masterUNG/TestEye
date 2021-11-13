import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChoosePost {
  Future<Null> normalDialog(
      BuildContext context, String title, String message) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          leading: Icon(
            Icons.add,
            color: Colors.orange,
          ),
          title: Text(
            title,
            style: GoogleFonts.lato(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(message),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
