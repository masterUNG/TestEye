import 'dart:convert';

class SubDistrictModel {
  final String name_th;
  SubDistrictModel({
    required this.name_th,
  });

  SubDistrictModel copyWith({
    String? name_th,
  }) {
    return SubDistrictModel(
      name_th: name_th ?? this.name_th,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name_th': name_th,
    };
  }

  factory SubDistrictModel.fromMap(Map<String, dynamic> map) {
    return SubDistrictModel(
      name_th: map['name_th'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SubDistrictModel.fromJson(String source) => SubDistrictModel.fromMap(json.decode(source));

  @override
  String toString() => 'SubDistrictModel(name_th: $name_th)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is SubDistrictModel &&
      other.name_th == name_th;
  }

  @override
  int get hashCode => name_th.hashCode;
}
