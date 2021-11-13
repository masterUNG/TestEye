import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ReferenceModel {
  final Timestamp datejob;
  final String descrip;
  final String image;
  ReferenceModel({
    required this.datejob,
    required this.descrip,
    required this.image,
  });

  ReferenceModel copyWith({
    Timestamp? datejob,
    String? descrip,
    String? image,
  }) {
    return ReferenceModel(
      datejob: datejob ?? this.datejob,
      descrip: descrip ?? this.descrip,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'datejob': datejob,
      'descrip': descrip,
      'image': image,
    };
  }

  factory ReferenceModel.fromMap(Map<String, dynamic> map) {
    return ReferenceModel(
      datejob: map['datejob'],
      descrip: map['descrip'],
      image: map['image'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ReferenceModel.fromJson(String source) => ReferenceModel.fromMap(json.decode(source));

  @override
  String toString() => 'ReferenceModel(datejob: $datejob, descrip: $descrip, image: $image)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ReferenceModel &&
      other.datejob == datejob &&
      other.descrip == descrip &&
      other.image == image;
  }

  @override
  int get hashCode => datejob.hashCode ^ descrip.hashCode ^ image.hashCode;
}
