import 'dart:convert';

class AmphurModel {
  final String id;
  final String name_th;
  AmphurModel({
    required this.id,
    required this.name_th,
  });

  AmphurModel copyWith({
    String? id,
    String? name_th,
  }) {
    return AmphurModel(
      id: id ?? this.id,
      name_th: name_th ?? this.name_th,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name_th': name_th,
    };
  }

  factory AmphurModel.fromMap(Map<String, dynamic> map) {
    return AmphurModel(
      id: map['id'],
      name_th: map['name_th'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AmphurModel.fromJson(String source) => AmphurModel.fromMap(json.decode(source));

  @override
  String toString() => 'AmphurModel(id: $id, name_th: $name_th)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is AmphurModel &&
      other.id == id &&
      other.name_th == name_th;
  }

  @override
  int get hashCode => id.hashCode ^ name_th.hashCode;
}
