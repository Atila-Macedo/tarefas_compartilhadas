import 'package:dio/dio.dart';
import 'package:seu_app_de_tarefas/models/user_model.dart';

class AuthService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://flutter-start-api.onrender.com'));

  Future<Response> login(UserModel user) async {
    return await _dio.post('/Auth/login', data: user.toJson());
  }

  Future<Response> register(UserModel user) async {
    return await _dio.post('/Auth/register', data: user.toJson());
  }
}
