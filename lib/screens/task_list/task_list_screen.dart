import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/app_scaffold.dart';
import '../../providers/task_list_provider.dart';
import '../../models/task_list.dart';
import 'package:intl/intl.dart';

class TaskListScreen extends StatefulWidget {
  final String taskListId;
  
  const TaskListScreen({super.key, required this.taskListId});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final _taskController = TextEditingController();

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  void _addTask() {
    if (_taskController.text.trim().isNotEmpty) {
      final taskListProvider = Provider.of<TaskListProvider>(context, listen: false);
      final newTask = Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _taskController.text.trim(),
      );
      taskListProvider.addTaskToList(widget.taskListId, newTask);
      _taskController.clear();
    }
  }

  void _toggleTask(String taskId, bool currentValue) {
    final taskListProvider = Provider.of<TaskListProvider>(context, listen: false);
    final taskList = taskListProvider.getTaskListById(widget.taskListId);
    
    if (taskList != null) {
      final task = taskList.tasks.firstWhere((t) => t.id == taskId);
      final updatedTask = task.copyWith(
        isCompleted: !currentValue,
        completedAt: !currentValue ? DateTime.now() : null,
      );
      taskListProvider.updateTask(widget.taskListId, taskId, updatedTask);
    }
  }

  void _removeTask(String taskId) {
    final taskListProvider = Provider.of<TaskListProvider>(context, listen: false);
    taskListProvider.removeTask(widget.taskListId, taskId);
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Excluir Lista'),
          content: const Text('Tem certeza que deseja excluir esta lista? Esta ação não pode ser desfeita.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final taskListProvider = Provider.of<TaskListProvider>(context, listen: false);
                taskListProvider.deleteTaskList(widget.taskListId);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskListProvider>(
      builder: (context, taskListProvider, child) {
        final taskList = taskListProvider.getTaskListById(widget.taskListId);
        
        if (taskList == null) {
          return AppScaffold(
            title: 'Lista não encontrada',
            body: const Center(
              child: Text('Lista não encontrada'),
            ),
          );
        }

        final activeTasks = taskList.tasks.where((task) => !task.isCompleted).toList();
        final completedTasks = taskList.tasks.where((task) => task.isCompleted).toList();

        return AppScaffold(
          title: taskList.name,
          currentIndex: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _showDeleteConfirmation,
            ),
          ],
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => _buildAddTaskBottomSheet(),
              );
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
            child: Column(
              children: [
                // Header com informações da lista
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.list_alt_rounded,
                                color: Theme.of(context).colorScheme.primary,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${taskList.completedTasks}/${taskList.totalTasks} tarefas concluídas',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${(taskList.completionPercentage * 100).toInt()}% concluído',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          if (taskList.totalTasks > 0) ...[
                            const SizedBox(height: 12),
                            LinearProgressIndicator(
                              value: taskList.completionPercentage,
                              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                taskList.isCompleted ? Colors.green : Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                
                // Lista de tarefas
                Expanded(
                  child: (activeTasks.isEmpty && completedTasks.isEmpty)
                      ? const Center(
                          child: Text(
                            'Nenhuma tarefa adicionada ainda',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          children: [
                            // Tarefas pendentes
                            if (activeTasks.isNotEmpty) ...[
                              _buildSectionHeader('Tarefas Pendentes', activeTasks.length),
                              ...activeTasks.map((task) => _buildTaskCard(task)),
                              const SizedBox(height: 16),
                            ],
                            // Tarefas concluídas
                            if (completedTasks.isNotEmpty) ...[
                              Divider(height: 32, thickness: 1, color: Colors.grey[300]),
                              _buildSectionHeader('Tarefas Concluídas', completedTasks.length),
                              ...completedTasks.map((task) => _buildTaskCard(task)),
                            ],
                          ],
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              count.toString(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(Task task) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Transform.scale(
          scale: 1.2,
          child: Checkbox(
            value: task.isCompleted,
            onChanged: (value) => _toggleTask(task.id, task.isCompleted),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            color: task.isCompleted 
                ? Theme.of(context).colorScheme.onSurface.withOpacity(0.6)
                : null,
          ),
        ),
        subtitle: task.completedAt != null
            ? Text(
                'Concluída em ${dateFormat.format(task.completedAt!)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.green,
                    ),
              )
            : null,
        trailing: IconButton(
          icon: Icon(
            Icons.delete_outline_rounded,
            color: Theme.of(context).colorScheme.error,
          ),
          onPressed: () => _removeTask(task.id),
        ),
      ),
    );
  }

  Widget _buildAddTaskBottomSheet() {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Nova Tarefa',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _taskController,
            decoration: const InputDecoration(
              labelText: 'Nome da tarefa',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              _addTask();
              Navigator.of(context).pop();
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _addTask();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Adicionar'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
