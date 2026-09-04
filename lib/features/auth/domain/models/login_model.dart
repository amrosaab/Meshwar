import 'dart:convert';

LoginResponseModel loginResponseModelFromJson(String str) =>
    LoginResponseModel.fromJson(json.decode(str));

class LoginResponseModel {
  String tokenType;
  int expiresIn;
  String accessToken;

  LoginResponseModel({
    required this.tokenType,
    required this.expiresIn,
    required this.accessToken,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
        tokenType: json["token_type"] ?? 'Bearer',
        expiresIn: json["expires_in"] ?? 0,
        accessToken: json["access_token"] ?? '',
      );
}
