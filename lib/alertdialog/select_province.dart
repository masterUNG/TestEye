import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectProvince {
  Future<Null> normalDialog(BuildContext context) async {
    int? _selectJobScope;
    showDialog(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(8),
        child: AlertDialog(
          title: Column(
            children: [
              Row(
                children: [
                  Radio(
                    activeColor: Colors.amber,
                    value: 0,
                    groupValue: _selectJobScope,
                    onChanged: (value) {},
                  ),
                  SizedBox(width: 10),
                  Text(
                    'ChiangMai',
                  ),
                ],
              ),
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
                    'Bangkok',
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
                    'Chonburi',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  } //endNormal
}
