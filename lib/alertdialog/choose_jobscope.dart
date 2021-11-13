import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChooseJobScope {
  Future<Null> normalDialog(BuildContext context) async {
    int? _selectJobScope;
    showDialog(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(8),
        child: AlertDialog(
          title: Column(children: [
            Row(
              children: [
                Radio(
                  activeColor: Colors.amber,
                  value: 1,
                  groupValue: _selectJobScope,
                  onChanged: (value) {},
                ),
                SizedBox(width: 10),
                Text(
                  'Type 1',
                ),
              ],
            ),
            Row(
              children: [
                Radio(
                  activeColor: Colors.amber,
                  value: 2,
                  groupValue: _selectJobScope,
                  onChanged: (value) {},
                ),
                SizedBox(width: 10),
                Text(
                  'Type 2',
                ),
              ],
            ),
            Row(
              children: [
                Radio(
                  activeColor: Colors.amber,
                  value: 2,
                  groupValue: _selectJobScope,
                  onChanged: (value) {},
                ),
                SizedBox(width: 10),
                Text(
                  'Type 3',
                ),
              ],
            ),
            Row(
              children: [
                Radio(
                  activeColor: Colors.amber,
                  value: 2,
                  groupValue: _selectJobScope,
                  onChanged: (value) {},
                ),
                SizedBox(width: 10),
                Text(
                  'Type 4',
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
