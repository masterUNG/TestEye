import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CancelForm extends StatefulWidget {
  const CancelForm({Key? key}) : super(key: key);

  @override
  _CancelFormState createState() => _CancelFormState();
}

class _CancelFormState extends State<CancelForm> {
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
        title: Text('Cancel Form'),
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
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 250),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Some reason';
                      } else {}
                    },
                    maxLines: 4,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Reason for cancellation',
                      hintText: 'EX: Sorry for cancel because.....',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    height: 50,
                    width: 370,
                    child: FlatButton(
                      textColor: Colors.white,
                      color: Colors.blueAccent,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {}
                      },
                      child: Text(
                        'Cancel Customer',
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
          ),
        ),
      ),
    );
  }
}
