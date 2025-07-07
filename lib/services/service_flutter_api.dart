

import 'package:dio/dio.dart';
import 'package:seu_app_de_tarefas/models/login_response.dart';
import 'package:seu_app_de_tarefas/services/interface/iservice_flutter_api.dart';

class ServiceFlutterApi extends IServiceFlutterApi{
  static const String host = 'https://flutter-start-api.onrender.com';
  final Dio _dio = Dio(BaseOptions(baseUrl: host));

  @override
  Future<LoginResponse?> postLoginUser(String email, String senha) async{
    try{
      var response = await _dio.post('/Auth/login', data: {'Email': email, 'Senha': senha});
      if(response.statusCode != 200){
        throw Exception(response.statusMessage);
      }
      return LoginResponse.fromJson(response.data);
    }catch(e){
      return null;
    }
  }

  @override
  Future<bool> postRegisterUser(String nome, String email, String senha) async{
    try{
      var response = await _dio.post('/Auth/register', data: {'Nome': nome, 'Email': email, 'Senha': senha});
      if(response.statusCode != 201){
        throw Exception(response.statusMessage);
      }
      return true;
    }catch(e){
      return false;
    }
  }
}