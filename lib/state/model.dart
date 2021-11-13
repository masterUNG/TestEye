import 'dart:convert';

class UserModel {
  final String img;
  final String name;
  final String about;
  UserModel({
    required this.img,
    required this.name,
    required this.about,
  });

  UserModel copyWith({
    String? img,
    String? name,
    String? about,
  }) {
    return UserModel(
      img: img ?? this.img,
      name: name ?? this.name,
      about: about ?? this.about,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'img': img,
      'name': name,
      'about': about,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      img: map['img'],
      name: map['name'],
      about: map['about'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));

  @override
  String toString() => 'UserModel(img: $img, name: $name, about: $about)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is UserModel &&
      other.img == img &&
      other.name == name &&
      other.about == about;
  }

  @override
  int get hashCode => img.hashCode ^ name.hashCode ^ about.hashCode;
}
