import 'package:flutter/material.dart';
import '../../widgets/app_scaffold.dart';
import '../../models/task.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Lista de Tarefas',
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implementar adição de nova tarefa
        },
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: 0, // TODO: Implementar lista de tarefas
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: Checkbox(
                value: false,
                onChanged: (value) {
                  // TODO: Implementar toggle de tarefa
                },
              ),
              title: const Text('Tarefa'),
              subtitle: const Text('Descrição da tarefa'),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  // TODO: Implementar exclusão de tarefa
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
