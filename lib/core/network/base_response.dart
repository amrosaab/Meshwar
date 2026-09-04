import 'dart:convert';

enum Status { loading, completed, error }

class BaseResponse {
  bool? success;
  String? message;
  int? statusCode;
  dynamic data;

  BaseResponse({
    this.success,
    this.message,
    this.statusCode,
    this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'success': success,
      'message': message,
      'statusCode': statusCode,
      'data': data,
    };
  }

  factory BaseResponse.fromMap(Map<String, dynamic> map) {
    return BaseResponse(
      success: map['success'] ?? false,
      message: map['message'],
      statusCode: map['statusCode']?.toInt(),
      data: map['data'],
    );
  }

  String toJson() => json.encode(toMap());

  factory BaseResponse.fromJson(source) => BaseResponse.fromMap(source);
}
