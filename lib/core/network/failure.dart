class Failure {
  final String? message;
  final int? statusCode;
  final dynamic data;
  Failure({this.message, this.data, this.statusCode});
}

class InPutDataFailure extends Failure {
  InPutDataFailure({super.message, super.statusCode});
}

class GetDataFailure extends Failure {
  GetDataFailure({super.message, super.statusCode});
}
