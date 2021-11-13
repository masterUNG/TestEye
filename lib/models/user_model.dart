import 'dart:convert';

class UserModelFirebase {
  final String email;
  final String uid;
  final String name;
  final String phoneNumber;
  final String jobType;
  final String jobScope;
  final String address;
  final bool accept;
  final String about;
  final String img;
  UserModelFirebase({
    required this.email,
    required this.uid,
    required this.name,
    required this.phoneNumber,
    required this.jobType,
    required this.jobScope,
    required this.address,
    required this.accept,
    required this.about,
    required this.img,
  });

  UserModelFirebase copyWith({
    String? email,
    String? uid,
    String? name,
    String? phoneNumber,
    String? jobType,
    String? jobScope,
    String? address,
    bool? accept,
    String? about,
    String? img,
  }) {
    return UserModelFirebase(
      email: email ?? this.email,
      uid: uid ?? this.uid,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      jobType: jobType ?? this.jobType,
      jobScope: jobScope ?? this.jobScope,
      address: address ?? this.address,
      accept: accept ?? this.accept,
      about: about ?? this.about,
      img: img ?? this.img,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'uid': uid,
      'name': name,
      'phoneNumber': phoneNumber,
      'jobType': jobType,
      'jobScope': jobScope,
      'address': address,
      'accept': accept,
      'about': about,
      'img': img,
    };
  }

  factory UserModelFirebase.fromMap(Map<String, dynamic> map) {
    return UserModelFirebase(
      email: map['email'],
      uid: map['uid'],
      name: map['name'],
      phoneNumber: map['phoneNumber'],
      jobType: map['jobType'],
      jobScope: map['jobScope'],
      address: map['address'],
      accept: map['accept'],
      about: map['about'],
      img: map['img'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModelFirebase.fromJson(String source) => UserModelFirebase.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModelFirebase(email: $email, uid: $uid, name: $name, phoneNumber: $phoneNumber, jobType: $jobType, jobScope: $jobScope, address: $address, accept: $accept, about: $about, img: $img)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is UserModelFirebase &&
      other.email == email &&
      other.uid == uid &&
      other.name == name &&
      other.phoneNumber == phoneNumber &&
      other.jobType == jobType &&
      other.jobScope == jobScope &&
      other.address == address &&
      other.accept == accept &&
      other.about == about &&
      other.img == img;
  }

  @override
  int get hashCode {
    return email.hashCode ^
      uid.hashCode ^
      name.hashCode ^
      phoneNumber.hashCode ^
      jobType.hashCode ^
      jobScope.hashCode ^
      address.hashCode ^
      accept.hashCode ^
      about.hashCode ^
      img.hashCode;
  }
}