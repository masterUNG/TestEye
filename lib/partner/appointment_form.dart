import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppointmentForm extends StatefulWidget {
  const AppointmentForm({Key? key}) : super(key: key);

  @override
  _AppointmentFormState createState() => _AppointmentFormState();
}

class _AppointmentFormState extends State<AppointmentForm> {
  DateTime? date;
  TimeOfDay? time;

  final _formKey = GlobalKey<FormState>();

  String getTime() {
    if (time == null) {
      return 'Confirm Time';
    } else {
      final hours = time!.hour.toString().padLeft(2, '0');
      final minutes = time!.minute.toString().padLeft(2, '0');
      return '$hours:$minutes';
    }
  }

  String getDate() {
    if (date == null) {
      return 'Confirm Date';
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
        title: Text('Appointment Form'),
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
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            SizedBox(height: 250),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Text(
                'Make an appointment to see the job site to get an accurate estimate',
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
                      return 'Please Enter some details';
                    } else {}
                  },
                  maxLines: 4,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Detail',
                    hintText:
                        'EX: work it alot of details need appointment to see the job site to get an accuate estimate and will decare how much for see job site or free if finally ctm confirm or not',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 40, left: 20),
              child: Text(
                'Confirm or Cahnge Date and Time',
                style: GoogleFonts.lato(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.orange),
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
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
                  'Appointment Customer',
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
