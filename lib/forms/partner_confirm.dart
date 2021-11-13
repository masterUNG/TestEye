import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PartnerConfirm extends StatefulWidget {
  const PartnerConfirm({Key? key}) : super(key: key);

  @override
  _PartnerConfirmState createState() => _PartnerConfirmState();
}

class _PartnerConfirmState extends State<PartnerConfirm> {
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
        title: Text('Partner Confirm'),
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
                      Row(
                        children: [
                          Text(
                            'Shop Name :',
                          ),
                          SizedBox(width: 10),
                          Text(
                            'xxxxxxxxxx',
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            'Customer Name :',
                          ),
                          SizedBox(width: 10),
                          Text(
                            'xxxxxxxxxx',
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            'Order number :',
                          ),
                          SizedBox(width: 10),
                          Text(
                            'xxxxxxxxxx',
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            'Appointment Date :',
                          ),
                          SizedBox(width: 10),
                          Text(
                            'xxxxxxxxxx',
                          ),
                        ],
                      ),
                      Divider(thickness: 2),
                      Text(
                        'Confirm Job :',
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        'xxxxxxxxxxxxxxx',
                      ),
                      Divider(thickness: 2),
                      Row(
                        children: [
                          Text(
                            'Total Price :',
                            style: GoogleFonts.lato(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text('xxxxx'),
                        ],
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
                    'Sent foam to Customer',
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
