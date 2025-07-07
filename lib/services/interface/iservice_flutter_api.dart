import 'package:seu_app_de_tarefas/models/login_response.dart';

abstract class IServiceFlutterApi{
  Future<LoginResponse?> postLoginUser(String email, String senha);
  Future<bool> postRegisterUser(String nome, String email, String senha); 
}
