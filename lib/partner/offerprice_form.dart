import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class OfferPriceForm extends StatefulWidget {
  const OfferPriceForm({Key? key}) : super(key: key);

  @override
  _ReplyPageState createState() => _ReplyPageState();
}

class _ReplyPageState extends State<OfferPriceForm> {
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
        title: Text('Offer Price Form'),
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
                  SizedBox(height: 150),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Offer Price';
                      } else {}
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Offer Price',
                      hintText:  'Baht',
                      prefixIcon: Icon(Icons.money),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
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
                          'EX: The price included everything no more charge',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Yor warranty';
                      } else {}
                    },
                    maxLines: 4,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'warranty',
                      hintText:
                          'Ex: Warranty Product and some problem about installing 1 year',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.only(right: 60),
                    child: Text(
                      'Confirm or Cahnge Date and Time',
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
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
                        'Reply Customer',
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
