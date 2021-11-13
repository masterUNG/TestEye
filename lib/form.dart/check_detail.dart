import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class CheckDetail extends StatefulWidget {
  const CheckDetail({Key? key}) : super(key: key);

  @override
  _CheckDetailState createState() => _CheckDetailState();
}

class _CheckDetailState extends State<CheckDetail> {
  File? image;
  int? _selectChoice;

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
        title: Text('Check detail'),
      ),
      body: Container(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Shop name :',
                        style: GoogleFonts.lato(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Customer name :',
                        style: GoogleFonts.lato(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Email address :',
                        style: GoogleFonts.lato(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Tax ID :',
                        style: GoogleFonts.lato(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Order number :',
                        style: GoogleFonts.lato(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Appointment Date :',
                        style: GoogleFonts.lato(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Divider(thickness: 3),
                      SizedBox(height: 8),
                      Text(
                        'Address :',
                        style: GoogleFonts.lato(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Divider(thickness: 3),
                      SizedBox(height: 8),
                      Text(
                        'Detail of work :',
                        style: GoogleFonts.lato(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Divider(thickness: 3),
                      Text(
                        'Total Price :',
                        style: GoogleFonts.lato(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Divider(thickness: 3),
                      Text(
                        'Payment methods :',
                        style: GoogleFonts.lato(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Column(
                      // children: [
                      // Row(
                      // children: [
                      // Radio(
                      // activeColor: Colors.amber,
                      // value: 1,
                      // groupValue: _selectChoice,
                      // onChanged: (value) {
                      // setState(() {
                      // _selectChoice = 1;
                      // });
                      // },
                      // ),
                      // SizedBox(width: 10),
                      // Text('QR Code')
                      // ],
                      // ),
                      // Row(
                      // children: [
                      // Radio(
                      // activeColor: Colors.amber,
                      // value: 2,
                      // groupValue: _selectChoice,
                      // onChanged: (value) {
                      // setState(() {
                      // _selectChoice = 2;
                      // });
                      // },
                      // ),
                      // SizedBox(width: 10),
                      // Text(
                      // 'Credit Card',
                      // ),
                      // ],
                      // ),
                      // ],
                      // ),
                      Container(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        child: GridView.count(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Card(
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      InkWell(
                                        onTap: () {},
                                        child: Icon(
                                          Icons.qr_code,
                                        ),
                                      ),
                                      Text(
                                        'QR Code',
                                        style: GoogleFonts.lato(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                color: Colors.amberAccent,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Card(
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      InkWell(
                                          onTap: () {},
                                          child: Icon(Icons.credit_card)),
                                      Text(
                                        'Credit card',
                                        style: GoogleFonts.lato(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                color: Colors.amberAccent,
                              ),
                            ),
                          ],
                        ),

                        // TextButton.icon(
                        // onPressed: () {
                        // showDialog(
                        // context: context,
                        // builder: (BuildContext context) {
                        // return AlertDialog(
                        // title: Center(
                        // child: Text(
                        // 'Choose your slip',
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
                        // icon: Icon(Icons.upload_outlined),
                        // label: Text(
                        // 'Upload Slip',
                        // ),
                        // ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50,
                child: FlatButton(
                  textColor: Colors.white,
                  color: Colors.blueAccent,
                  onPressed: () {},
                  child: Text(
                    'Continue Payment',
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
            ),
          ],
        ),
      ),
    );
  }
}
