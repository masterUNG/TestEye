import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TechnicianCancel extends StatefulWidget {
  const TechnicianCancel({Key? key}) : super(key: key);

  @override
  _TechnicianCancelState createState() => _TechnicianCancelState();
}

class _TechnicianCancelState extends State<TechnicianCancel> {
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
        title: Text('Technician cancel'),
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
                        '**If technician reply Cancel**',
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
                      Divider(thickness: 2),
                      Text(
                        'Details :',
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text('xxxxxxxxxxxxxxx'),
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
