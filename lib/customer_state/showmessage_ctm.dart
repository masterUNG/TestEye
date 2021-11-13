import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:joelfindtechnician/alertdialog/ctm_appointment.dart';
import 'package:joelfindtechnician/alertdialog/ctm_cancel.dart';
import 'package:joelfindtechnician/alertdialog/ctmAppointment_success.dart';
import 'package:joelfindtechnician/alertdialog/ctmCancel_success.dart';
import 'package:joelfindtechnician/alertdialog/my_dialog.dart';
import 'package:joelfindtechnician/partner/job_done.dart';

class ShowMessageCustomer extends StatefulWidget {
  const ShowMessageCustomer({Key? key}) : super(key: key);

  @override
  _ShowMessageCustomerState createState() => _ShowMessageCustomerState();
}

class _ShowMessageCustomerState extends State<ShowMessageCustomer> {
  SpeedDial _speedDial() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 25),
      children: [
        SpeedDialChild(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Jobdone()));
          },
          backgroundColor: Colors.amber,
          child: Icon(
            Icons.done_all_outlined,
          ),
          label: 'Job done',
          labelBackgroundColor: Colors.amber,
          labelStyle: GoogleFonts.lato(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ],
    );
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
        title: Text('Show Message Customer'),
        actions: [
          InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Icon(Icons.emoji_emotions_outlined),
            ),
          ),
        ],
      ),
      floatingActionButton: _speedDial(),
    );
  }
}
