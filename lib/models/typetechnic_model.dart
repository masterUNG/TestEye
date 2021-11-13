import 'dart:convert';

class TypeTechnicModel {
  final String name;
  TypeTechnicModel({
    required this.name,
  });

  TypeTechnicModel copyWith({
    String? name,
  }) {
    return TypeTechnicModel(
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }

  factory TypeTechnicModel.fromMap(Map<String, dynamic> map) {
    return TypeTechnicModel(
      name: map['name'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TypeTechnicModel.fromJson(String source) => TypeTechnicModel.fromMap(json.decode(source));

  @override
  String toString() => 'TypeTechnicModel(name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is TypeTechnicModel &&
      other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}
