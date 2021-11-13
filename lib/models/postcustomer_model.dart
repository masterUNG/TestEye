import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class PostCustomerModel {
  final String address;
  final String amphur;
  final String district;
  final String job;
  final List<String> pathImages;
  final String province;
  final Timestamp timePost;
  final List<String> typeTechnics;
  final String uidCustomer;
  final String name;
  final String pathUrl;
  final String status;
  PostCustomerModel({
    required this.address,
    required this.amphur,
    required this.district,
    required this.job,
    required this.pathImages,
    required this.province,
    required this.timePost,
    required this.typeTechnics,
    required this.uidCustomer,
    required this.name,
    required this.pathUrl,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'amphur': amphur,
      'district': district,
      'job': job,
      'pathImages': pathImages,
      'province': province,
      'timePost': timePost,
      'typeTechnics': typeTechnics,
      'uidCustomer': uidCustomer,
      'name': name,
      'pathUrl': pathUrl,
      'status': status,
    };
  }

  factory PostCustomerModel.fromMap(Map<String, dynamic> map) {
    return PostCustomerModel(
      address: map['address'],
      amphur: map['amphur'],
      district: map['district'],
      job: map['job'],
      pathImages: List<String>.from(map['pathImages']),
      province: map['province'],
      timePost: map['timePost'],
      typeTechnics: List<String>.from(map['typeTechnics']),
      uidCustomer: map['uidCustomer'],
      name: map['name'],
      pathUrl: map['pathUrl'],
      status: map['status'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PostCustomerModel.fromJson(String source) => PostCustomerModel.fromMap(json.decode(source));
}
