class AppException implements Exception {
  final String message;
  final String prefix;

  AppException({required this.message, required this.prefix});

  @override
  String toString() {
    return message;
  }
}

class FetchDataException extends AppException {
  FetchDataException([message])
      : super(message: message, prefix: "Fetch Data Error");
}

class BadRequestException extends AppException {
  BadRequestException([message])
      : super(message: message, prefix: "Invalid Request. ");
}
