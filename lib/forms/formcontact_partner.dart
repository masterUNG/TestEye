import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:joelfindtechnician/alertdialog/choose_post.dart';
import 'package:joelfindtechnician/alertdialog/my_dialog.dart';
import 'package:joelfindtechnician/alertdialog/select_province.dart';

class FormContactPartner extends StatefulWidget {
  const FormContactPartner({Key? key}) : super(key: key);

  @override
  _FormContactPartnerState createState() => _FormContactPartnerState();
}

class _FormContactPartnerState extends State<FormContactPartner> {
  DateTime? date;
  TimeOfDay? time;
  int? _selectChoice;
  File? image;
  String? imgUrl;

  _imageFromCamera() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.camera);
    final pickedImageFile = File(pickedImage!.path);
    setState(() {
      image = pickedImageFile;
    });
  }

  _imageFromGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    final pickedImageFile = File(pickedImage!.path);
    setState(() {
      image = pickedImageFile;
    });
  }

  final _formKey = GlobalKey<FormState>();

  String getTime() {
    if (time == null) {
      return 'Appointment Time';
    } else {
      final hours = time!.hour.toString().padLeft(2, '0');
      final minutes = time!.minute.toString().padLeft(2, '0');

      return '$hours:$minutes';
    }
  }

  String getDate() {
    if (date == null) {
      return 'Appointment Date';
    } else {
      return '${date!.day}/${date!.month}/${date!.year}';
    }
  }

  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2022),
    );
    if (newDate == null) return;

    setState(() => date = newDate);
  }

  Future pickTime(BuildContext context) async {
    final initialTime = TimeOfDay(hour: 9, minute: 0);
    final newTime = await showTimePicker(
      context: context,
      initialTime: time ?? initialTime,
    );

    if (newTime == null) return;

    setState(() {
      time = newTime;
    });
  }

  @override
  Widget build(BuildContext context) {
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
        title: Text('Foam contact technician'),
        // actions: [
        // InkWell(
        // onTap: () {},
        // child: Padding(
        // padding: const EdgeInsets.all(15),
        // child: IconButton(
        // onPressed: () {
        // showDialog(
        // context: context,
        // builder: (BuildContext context) {
        // return AlertDialog(
        // title: Center(
        // child: Text(
        // 'Choose Profile Photo',
        // style: GoogleFonts.lato(
        // fontWeight: FontWeight.bold,
        // color: Colors.purpleAccent,
        // ),
        // ),
        // ),
        // content: SingleChildScrollView(
        // child: Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        // children: [
        // FlatButton.icon(
        // onPressed: () {
        // _imageFromCamera();
        // Navigator.of(context).pop();
        // },
        // icon: Icon(Icons.camera,
        // color: Colors.purpleAccent),
        // label: Text('Camera'),
        // ),
        // FlatButton.icon(
        // onPressed: () {
        // _imageFromGallery();
        // Navigator.of(context).pop();
        // },
        // icon: Icon(
        // Icons.image,
        // color: Colors.purpleAccent,
        // ),
        // label: Text('Gallery'),
        // ),
        // ],
        // ),
        // ),
        // );
        // },
        // );
        // },
        // icon: Icon(Icons.camera_alt_outlined),
        // ),
        // ),
        // ),
        // ],
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please type your name';
                      } else {}
                    },
                    decoration: InputDecoration(
                      labelText: 'Customer Name',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please type your phone number';
                      } else {}
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please type your email address';
                      } else {}
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      ChoosePost()
                          .normalDialog(context, 'Please choose your post', '');
                    },
                    icon: Icon(Icons.add),
                    label: Text('Please Add your post to job Description'),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    validator: (value) {
                      // if (value!.isEmpty) {
                      // return 'Please type job description';
                      // } else {}
                    },
                    maxLines: 8,
                    decoration: InputDecoration(
                      labelText: 'Job Description',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    validator: (value) {
                      // if (value!.isEmpty) {
                      // return 'Please type your address';
                      // } else {}
                    },
                    decoration: InputDecoration(
                      labelText: 'Address',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        child: Text('ตำบล'),
                      ),
                      Container(
                        child: Text('อำเภอ'),
                      ),
                      Container(
                        child: Text('จังหวัด'),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      FlatButton.icon(
                        onPressed: () {
                          pickDate(context);
                        },
                        icon: Icon(
                          Icons.date_range_outlined,
                          size: 30,
                          color: Colors.orange,
                        ),
                        label: Text(getDate()),
                      ),
                      FlatButton.icon(
                        padding: EdgeInsets.only(right: 10),
                        onPressed: () {
                          pickTime(context);
                        },
                        icon: Icon(
                          Icons.watch_later_outlined,
                          size: 30,
                          color: Colors.orange,
                        ),
                        label: Text(getTime()),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Column(
                    children: [
                      Row(
                        children: [
                          Radio(
                            activeColor: Colors.amber,
                            value: 1,
                            groupValue: _selectChoice,
                            onChanged: (value) {
                              setState(() {
                                _selectChoice = 1;
                              });
                            },
                          ),
                          SizedBox(width: 10),
                          Text(
                            'ให้ช่างส่งใบเสนอราคาให้',
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Radio(
                            activeColor: Colors.amber,
                            value: 2,
                            groupValue: _selectChoice,
                            onChanged: (value) {
                              setState(() {
                                _selectChoice = 2;
                              });
                            },
                          ),
                          SizedBox(width: 10),
                          Text(
                            'นัดหมายช่างเพื่อดูหน้างานจริง',
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      Container(
                        height: 50,
                        width: 330,
                        child: FlatButton(
                          textColor: Colors.white,
                          color: Colors.blueAccent,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {}
                          },
                          child: Text(
                            'Sent foam to technician',
                            style: GoogleFonts.lato(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
