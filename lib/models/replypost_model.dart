import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ReplyPostModel {
  final String name;
  final String pathImage;
  final String reply;
  final Timestamp timeReply;
  final String uid;
  final String urlImagePost;
  final String status;
  ReplyPostModel({
    required this.name,
    required this.pathImage,
    required this.reply,
    required this.timeReply,
    required this.uid,
    required this.urlImagePost,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'pathImage': pathImage,
      'reply': reply,
      'timeReply': timeReply,
      'uid': uid,
      'urlImagePost': urlImagePost,
      'status': status,
    };
  }

  factory ReplyPostModel.fromMap(Map<String, dynamic> map) {
    return ReplyPostModel(
      name: map['name'],
      pathImage: map['pathImage'],
      reply: map['reply'],
      timeReply: map['timeReply'],
      uid: map['uid'],
      urlImagePost: map['urlImagePost'],
      status: map['status'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ReplyPostModel.fromJson(String source) => ReplyPostModel.fromMap(json.decode(source));
}
