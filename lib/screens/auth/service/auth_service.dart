import 'package:dio/dio.dart';
import 'package:seu_app_de_tarefas/models/user_model.dart';

class AuthService {
  final Dio _dio =
      Dio(BaseOptions(baseUrl: 'https://flutter-start-api.onrender.com'));

  Future<bool> login(UserModel user) async {
    try {
      final response = await _dio.post('/Auth/login', data: user.toJson());
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> register(UserModel user) async {
    try {
      final response = await _dio.post('/Auth/register', data: user.toJson());
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
