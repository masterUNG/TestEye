import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FormtoTechnician extends StatefulWidget {
  const FormtoTechnician({Key? key}) : super(key: key);

  @override
  _FormtoTechnicianState createState() => _FormtoTechnicianState();
}

class _FormtoTechnicianState extends State<FormtoTechnician> {
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
        title: Text('Form to technician'),
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
                        'Customer Name',
                        style: GoogleFonts.lato(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Text(
                            'Order number:',
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
                            'Appointment :',
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
                            'Order Summit :',
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
                            'Expire time:',
                            style: GoogleFonts.lato(color: Colors.red),
                          ),
                          SizedBox(width: 10),
                          Text(
                            'xxxxxxxxxx',
                            style: GoogleFonts.lato(color: Colors.red),
                          ),
                        ],
                      ),
                      Divider(thickness: 2),
                      Row(
                        children: [
                          Text(
                            'Remark :',
                          ),
                          SizedBox(width: 10),
                          Text(
                            'xxxxxxxxxx',
                          ),
                        ],
                      ),
                      Divider(thickness: 2),
                      Text(
                        'Job Description :',
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
                      ),
                      Divider(thickness: 2),
                      Text(
                        'Detail of work :',
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
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
