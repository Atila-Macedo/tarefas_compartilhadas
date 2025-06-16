import 'package:flutter/material.dart';
import '../../widgets/app_scaffold.dart';
import '../../models/task.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Lista de Tarefas',
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Implementar adição de nova tarefa
        },
        icon: const Icon(Icons.add),
        label: const Text('Nova Tarefa'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
            ],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: 0, // TODO: Implementar lista de tarefas
          itemBuilder: (context, index) {
            return Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  // TODO: Implementar edição de tarefa
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Transform.scale(
                        scale: 1.2,
                        child: Checkbox(
                          value: false,
                          onChanged: (value) {
                            // TODO: Implementar toggle de tarefa
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tarefa',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Descrição da tarefa',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete_outline_rounded,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        onPressed: () {
                          // TODO: Implementar exclusão de tarefa
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
