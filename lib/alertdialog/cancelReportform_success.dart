import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class CancelReportFormSuccess extends StatefulWidget {
  const CancelReportFormSuccess({Key? key}) : super(key: key);

  @override
  _CancelReportFormSuccessState createState() => _CancelReportFormSuccessState();
}

class _CancelReportFormSuccessState extends State<CancelReportFormSuccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('assets/images/check.png'),
              ),
              Text(
                'Your Cancel Was Don!',
                style: GoogleFonts.lato(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 30),
              Container(
                child: FlatButton(
                  height: 40,
                  minWidth: 330,
                  color: Colors.blue,
                  onPressed: () {},
                  child: Text(
                    'OK',
                    style: GoogleFonts.lato(
                      fontSize: 20,
                      color: Colors.white,
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
      ),
    );
  }
}
