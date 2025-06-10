import 'package:flutter/material.dart';
import '../../utils/app_routes.dart';
import '../../widgets/app_scaffold.dart';
import '../task_list/task_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Minhas Listas',
      currentIndex: 0,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implementar criação de nova lista
        },
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: 0, // TODO: Implementar lista de tarefas
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: const Text('Lista de Tarefas'),
              subtitle: const Text('0 tarefas'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TaskListScreen(),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
