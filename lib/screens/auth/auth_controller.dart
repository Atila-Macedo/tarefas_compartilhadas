import 'package:seu_app_de_tarefas/models/user_model.dart';
import 'package:seu_app_de_tarefas/screens/auth/auth_repository.dart';
import 'package:flutter/material.dart';

class AuthController {
  final AuthRepository _repository = AuthRepository();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<bool> login() async {
    final user = UserModel(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
    return await _repository.login(user);
  }

  Future<bool> register() async {
    final user = UserModel(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
    return await _repository.register(user);
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}
