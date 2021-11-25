import 'dart:convert';

class TokenModel {
  final String token;

  TokenModel(this.token);

  Map<String, dynamic> toMap() {
    return {
      'token': token,
    };
  }

  factory TokenModel.fromMap(Map<String, dynamic> map) {
    return TokenModel(
      map['token'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TokenModel.fromJson(String source) => TokenModel.fromMap(json.decode(source));
}
