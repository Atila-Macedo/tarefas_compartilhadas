import 'package:seu_app_de_tarefas/models/user_model.dart';
import 'package:seu_app_de_tarefas/screens/auth/service/auth_service.dart';

class AuthController {
  final AuthService _service = AuthService();

  Future<bool> login(String email, String password) async {
    final user = UserModel(email: email, password: password);
    return await _service.login(user);
  }

  Future<bool> register(String email, String password) async {
    final user = UserModel(email: email, password: password);
    return await _service.register(user);
  }
}
