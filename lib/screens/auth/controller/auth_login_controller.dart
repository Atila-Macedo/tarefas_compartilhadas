import 'package:seu_app_de_tarefas/models/login_response.dart';
import 'package:seu_app_de_tarefas/services/interface/iservice_flutter_api.dart';

class AuthController {
  final IServiceFlutterApi _service;

  AuthController(this._service);

  Future<LoginResponse?> loginUser(String email, String senha) async {
    try{
      var authResponse = await _service.postLoginUser(email, senha);
      if(authResponse == null) {
        throw Exception("Erro ao efetuar login");
      }
      return authResponse;
    }catch(ex){
      return null;
    }
  }
  Future<bool> registerUser(String nome, String email, String senha) async {
    try{
      var authResponse = await _service.postRegisterUser(nome, email, senha);
      if(!authResponse) {
        throw Exception("Erro ao criar usuário");
      }
      return true;
    }catch(ex){
      return false;
    }
  }
}