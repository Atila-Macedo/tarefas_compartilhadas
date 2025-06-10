import 'package:flutter/material.dart';
import '../../utils/app_routes.dart';
import '../../widgets/app_scaffold.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Configurações',
      currentIndex: 1,
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Perfil'),
            onTap: () {
              // TODO: Implementar navegação para perfil
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notificações'),
            onTap: () {
              // TODO: Implementar configurações de notificações
            },
          ),
          ListTile(
            leading: const Icon(Icons.color_lens),
            title: const Text('Tema'),
            onTap: () {
              // TODO: Implementar configurações de tema
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sair'),
            onTap: () {
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
          ),
        ],
      ),
    );
  }
}
