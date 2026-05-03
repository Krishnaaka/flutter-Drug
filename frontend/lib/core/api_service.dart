import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://localhost:8080',
    contentType: 'application/json',
  ));

  static Future<void> init() async {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('jwt_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));
  }

  static Future<Response> post(String path, dynamic data) async {
    return await _dio.post(path, data: data);
  }

  static Future<Response> get(String path) async {
    return await _dio.get(path);
  }

  static Future<Response> delete(String path) async {
    return await _dio.delete(path);
  }

  static Future<Response> put(String path, dynamic data) async {
    return await _dio.put(path, data: data);
  }
}
