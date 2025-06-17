import 'package:flutter/material.dart';
import 'package:seu_app_de_tarefas/theme/theme_config.dart';
import 'package:seu_app_de_tarefas/utils/app_routes.dart';

class TarefasApp extends StatelessWidget {

  const TarefasApp({ super.key });

   @override
   Widget build(BuildContext context) {
      return MaterialApp(
      title: 'Tarefas Compartilhadas',
      theme: ThemeConfig.theme,
      initialRoute: AppRoutes.home,
      routes: AppRoutes.routes,
    );
  }
}