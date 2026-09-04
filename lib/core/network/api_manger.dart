abstract class ApiManager {
  Future get(String url,
      {Map<String, dynamic>? queryParams, Map<String, dynamic>? headers});
  Future getUri(Uri url, {Map<String, dynamic>? headers});
  Future post(String url, {Map<String, dynamic>? headers, body, encoding});
  Future delete(String url, {Map<String, dynamic>? queryParams});
}
