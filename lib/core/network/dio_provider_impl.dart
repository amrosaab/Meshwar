import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/network/network.dart';
import '../../common/common.dart';

class DioProviderImpl implements ApiManager {
  static final String baseUrl = AppConstants.baseUrl;

  static Dio dioClient = _addInterceptors(_createDio());

  static Dio _createDio() {
    BaseOptions opts = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(milliseconds: 30000),
      receiveTimeout: const Duration(milliseconds: 30000),
      headers: <String, dynamic>{
        'Accept': 'application/json',
      },
    );
    return Dio(opts);
  }

  static Dio _addInterceptors(Dio dio) {
    dio.interceptors.add(InterceptorsWrapper(onRequest: (
      RequestOptions options,
      RequestInterceptorHandler handler,
    ) {
      options.headers.putIfAbsent('Accept', () => 'application/json');
      return handler.next(options); //continue
    }, onResponse: (response, ResponseInterceptorHandler handler) {
      return handler.next(response); // continue
    }, onError: (DioException error, ErrorInterceptorHandler handler) async {
      String? e = DioErrorHandler.dioErrorToString(error);
      debugPrint(e);
      return handler.next(error);
    }));

    return dio;
  }

  @override
  Future<Response> get(String url,
      {Map<String, dynamic>? queryParams,
      Map<String, dynamic>? headers}) async {
    try {
      final response = await dioClient.get(url,
          queryParameters: queryParams, options: Options(headers: headers));

      return response;
    } on DioException catch (e) {
      debugPrint('dio get error $e');
      if (e.response != null && e.response!.data != null) {
        return e.response!;
      } else {
        throw ServerException();
      }
    }
  }

  @override
  Future<Response> getUri(Uri url, {Map<String, dynamic>? headers}) async {
    try {
      final response =
          await dioClient.getUri(url, options: Options(headers: headers));

      return response;
    } on DioException catch (e) {
      debugPrint('dio get error $e');
      if (e.response != null && e.response!.data != null) {
        return e.response!;
      } else {
        throw ServerException();
      }
    }
  }

  @override
  Future<Response> post(String url,
      {Map<String, dynamic>? headers, body, encoding}) async {
    try {
      final response = await dioClient.post(url,
          data: body, options: Options(headers: headers));
      return response;
    } on DioException catch (e) {
      debugPrint('dio post error $e');
      if (e.response != null && e.response!.data != null) {
        return e.response!;
      } else {
        throw ServerException();
      }
    }
  }

  @override
  Future<Response> delete(String url,
      {Map<String, dynamic>? queryParams}) async {
    try {
      final Response response =
          await dioClient.delete(url, queryParameters: queryParams);
      return response;
    } on DioException catch (e) {
      debugPrint('dio error $e');
      if (e.response != null && e.response!.data != null) {
        return e.response!;
      } else {
        throw ServerException();
      }
    }
  }
}
