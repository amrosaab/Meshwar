class AppException implements Exception {
  final String message;

  AppException({required this.message});
}

class NetworkException implements AppException {
  @override
  String message = 'Connectivity problem';
}

class ServerException implements AppException {
  @override
  String message = 'Something went wrong';
}

class CacheException implements AppException {
  @override
  String message = "Unable to save data";
}
