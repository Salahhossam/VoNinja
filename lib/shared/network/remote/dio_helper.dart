import 'package:dio/dio.dart';

class DioHelperPayment {
  static late Dio dio;

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'http://localhost:8088/api/',
        headers: {
          'Content-Type': 'application/json',
        },
        receiveDataWhenStatusError: true,
      ),
    );
  }

  // to get data from url
  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    return await dio.get(url,
        queryParameters: query, options: Options(headers: headers));
  }

  // post data
  static Future<Response> postData({
    required String url,
    required Map<String, dynamic>? data,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
  }) async {
    return await dio.post(url,
        data: data, queryParameters: query, options: Options(headers: headers));
  }

  static Future<Response> putData({
    required String url,
    required Map<String, dynamic>? data,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    return await dio.put(url,
        data: data, queryParameters: query, options: Options(headers: headers));
  }
}
