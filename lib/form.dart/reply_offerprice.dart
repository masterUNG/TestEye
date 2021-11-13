import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReplyOfferPrice extends StatefulWidget {
  const ReplyOfferPrice({Key? key}) : super(key: key);

  @override
  _ReplyOfferPriceState createState() => _ReplyOfferPriceState();
}

class _ReplyOfferPriceState extends State<ReplyOfferPrice> {
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
        title: Text('Reply offer price'),
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
                        '**If technician reply Offer Price**',
                        style: GoogleFonts.lato(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Shop Name',
                        style: GoogleFonts.lato(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Text(
                            'Reply time :',
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
                            'Expire time :',
                            style: GoogleFonts.lato(
                              color: Colors.red,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            'xxxxxxxxxx',
                            style: GoogleFonts.lato(
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            'Appointment time :',
                          ),
                          SizedBox(width: 10),
                          Text(
                            'xxxxxxxxxx',
                          ),
                        ],
                      ),
                      Divider(thickness: 2),
                      Row(
                        children: [
                          Text(
                            'Offer Price :',
                            style: GoogleFonts.lato(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text('xxxxx'),
                        ],
                      ),
                      Divider(thickness: 2),
                      Text(
                        'Details :',
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text('xxxxxxxxxxxxxxx'),
                      Divider(thickness: 2),
                      Text(
                        'Waranty :',
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        'xxxxxxxxxxxxxxx',
                      ),
                    ],
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
