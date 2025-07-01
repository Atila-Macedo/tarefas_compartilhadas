import 'package:seu_app_de_tarefas/models/user_model.dart';
import 'package:seu_app_de_tarefas/screens/auth/service/auth_service.dart';

class AuthRepository {
  final AuthService _service = AuthService();

  Future<bool> login(UserModel user) async {
    try {
      final response = await _service.login(user);
      return response.statusCode == 200;
    } catch (e) {
      print('Erro no login: $e');
      return false;
    }
  }

  Future<bool> register(UserModel user) async {
    try {
      final response = await _service.register(user);
      return response.statusCode == 200;
    } catch (e) {
      print('Erro no registro: $e');
      return false;
    }
  }
}
