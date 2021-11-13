import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class AnswerModel {
  final String answer;
  final String namePost;
  final String urlPost;
  final String urlImage;
  final Timestamp timePost;
  final String status;
  AnswerModel({
    required this.answer,
    required this.namePost,
    required this.urlPost,
    required this.urlImage,
    required this.timePost,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'answer': answer,
      'namePost': namePost,
      'urlPost': urlPost,
      'urlImage': urlImage,
      'timePost': timePost,
      'status': status,
    };
  }

  factory AnswerModel.fromMap(Map<String, dynamic> map) {
    return AnswerModel(
      answer: map['answer'],
      namePost: map['namePost'],
      urlPost: map['urlPost'],
      urlImage: map['urlImage'],
      timePost: map['timePost'],
      status: map['status'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AnswerModel.fromJson(String source) => AnswerModel.fromMap(json.decode(source));
}
