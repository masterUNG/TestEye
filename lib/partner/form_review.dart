import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FormReview extends StatefulWidget {
  const FormReview({Key? key}) : super(key: key);

  @override
  _FormReviewState createState() => _FormReviewState();
}

class _FormReviewState extends State<FormReview> {
  final _formKey = GlobalKey<FormState>();
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
        title: Text('Review Form'),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            SizedBox(height: 250),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Text(
                'Please comment your satisfaction level',
                style: GoogleFonts.lato(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 24),
              child: Form(
                key: _formKey,
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter some comment';
                    } else {}
                  },
                  maxLines: 4,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Comment',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
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
                  'Review',
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
      ),
    );
  }
}
