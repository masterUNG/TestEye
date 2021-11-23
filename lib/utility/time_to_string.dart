import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TimeToString {
  final Timestamp timestamp;
  TimeToString({
    required this.timestamp,
  });

  String findString() {
    DateTime dateTime = timestamp.toDate();
    DateFormat dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    String result = dateFormat.format(dateTime);
    return result;
  }
}
