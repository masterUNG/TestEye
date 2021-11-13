import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:joelfindtechnician/alertdialog/cancelReportform_success.dart';
import 'package:joelfindtechnician/alertdialog/jobdone_success.dart';
import 'package:joelfindtechnician/alertdialog/partner_cancel.dart';
import 'package:joelfindtechnician/forms/partner_confirm.dart';



class ShowMessagePartner extends StatefulWidget {
  const ShowMessagePartner({Key? key}) : super(key: key);

  @override
  _ShowMessagePartnerState createState() => _ShowMessagePartnerState();
}

class _ShowMessagePartnerState extends State<ShowMessagePartner> {
  SpeedDial _speedDial() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 25),
      children: [
        // SpeedDialChild(
          // onTap: () {
            // Navigator.push(context,
                // MaterialPageRoute(builder: (context) => ConfirmReportForm()));
          // },
          // backgroundColor: Colors.amber,
          // child: Icon(
            // Icons.check_circle_outline,
          // ),
          // label: 'Confirm report form',
          // labelBackgroundColor: Colors.amber,
          // labelStyle: GoogleFonts.lato(
            // color: Colors.white,
            // fontWeight: FontWeight.bold,
            // fontSize: 15,
          // ),
        // ),
        // SpeedDialChild(
          // onTap: () {
            // PartnerrCancel().normalDialog(context, '', '');
          // },
          // backgroundColor: Colors.amber,
          // child: Icon(
            // Icons.cancel_presentation_outlined,
          // ),
          // label: 'Cancel report form',
          // labelBackgroundColor: Colors.amber,
          // labelStyle: GoogleFonts.lato(
            // color: Colors.white,
            // fontWeight: FontWeight.bold,
            // fontSize: 15,
          // ),
        // ),
        // SpeedDialChild(
        // onTap: () {
        // Navigator.push(context,
        // MaterialPageRoute(builder: (context) => AppointmentForm()));
        // },
        // backgroundColor: Colors.amber,
        // child: Icon(
        // Icons.calendar_today_outlined,
        // ),
        // label: 'Appointment',
        // labelBackgroundColor: Colors.amber,
        // labelStyle: GoogleFonts.lato(
        // color: Colors.white,
        // fontWeight: FontWeight.bold,
        // fontSize: 15,
        // ),
        // ),
        // SpeedDialChild(
        // onTap: () {
        // Navigator.push(context,
        // MaterialPageRoute(builder: (context) => OfferPriceForm()));
        //
        // backgroundColor: Colors.amber,
        // child: Icon(
        // Icons.reply,
        // ),
        // label: 'Offer price',
        // labelBackgroundColor: Colors.amber,
        // labelStyle: GoogleFonts.lato(
        // color: Colors.white,
        // fontWeight: FontWeight.bold,
        // fontSize: 15,
        // ),
        // ),
        SpeedDialChild(
          onTap: () {},
          backgroundColor: Colors.amber,
          child: Icon(
            Icons.replay,
          ),
          label: 'Confirm',
          labelBackgroundColor: Colors.amber,
          labelStyle: GoogleFonts.lato(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        SpeedDialChild(
          onTap: () {
           PartnerrCancel().normalDialog(context, 'ยกเลิกงาน', 'คุณแน่ใจที่จะยกเลิกงานใช่ไหม ?');
           
          },
          backgroundColor: Colors.amber,
          child: Icon(
            Icons.cancel_outlined,
          ),
          label: 'cancel',
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
        title: Text('Show Message Partner'),
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
