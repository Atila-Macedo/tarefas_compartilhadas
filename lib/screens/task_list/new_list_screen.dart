import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/task_list_provider.dart';
import '../../models/task_list.dart';

class NewListScreen extends StatefulWidget {
  const NewListScreen({super.key});

  @override
  State<NewListScreen> createState() => _NewListScreenState();
}

class _NewListScreenState extends State<NewListScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _taskController = TextEditingController();
  final _emailController = TextEditingController();
  final List<Task> _tasks = [];

  @override
  void dispose() {
    _nameController.dispose();
    _taskController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _addTask() {
    if (_taskController.text.trim().isNotEmpty) {
      setState(() {
        _tasks.add(Task(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: _taskController.text.trim(),
        ));
        _taskController.clear();
      });
    }
  }

  void _toggleTask(int index) {
    setState(() {
      final task = _tasks[index];
      _tasks[index] = task.copyWith(
        isCompleted: !task.isCompleted,
        completedAt: !task.isCompleted ? DateTime.now() : null,
      );
    });
  }

  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  void _showShareOptions() {
    _emailController.clear();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Compartilhar Lista'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email do usuário',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                onSubmitted: (value) => _shareList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: _shareList,
              child: const Text('Compartilhar'),
            ),
          ],
        );
      },
    );
  }

  void _shareList() {
    if (_emailController.text.trim().isNotEmpty) {
      // Validação básica de email
      if (!_emailController.text.contains('@') || !_emailController.text.contains('.')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor, insira um email válido'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // TODO: Implementar compartilhamento da lista
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lista compartilhada com ${_emailController.text}'),
          backgroundColor: Colors.green,
        ),
      );
      _emailController.clear();
      Navigator.of(context).pop(); // Fecha o dialog
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, insira um email'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _saveList() async {
    if (_formKey.currentState!.validate()) {
      if (_tasks.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Adicione pelo menos uma tarefa à lista'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      try {
        final taskListProvider = Provider.of<TaskListProvider>(context, listen: false);
        await taskListProvider.createTaskList(_nameController.text.trim(), _tasks);
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lista salva com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao salvar lista'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeTasks = _tasks.where((task) => !task.isCompleted).toList();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Lista'),
        actions: [
          TextButton(
            onPressed: _saveList,
            child: const Text('Salvar'),
          ),
        ],
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
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Campo do título da lista
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nome da Lista',
                        prefixIcon: Icon(Icons.list_alt_rounded),
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira um nome para a lista';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ),
              
              // Lista de tarefas ativas
              Expanded(
                child: activeTasks.isEmpty
                    ? const Center(
                        child: Text(
                          'Nenhuma tarefa adicionada ainda',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        itemCount: activeTasks.length,
                        itemBuilder: (context, index) {
                          final task = activeTasks[index];
                          final originalIndex = _tasks.indexOf(task);
                          
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: Checkbox(
                                value: task.isCompleted,
                                onChanged: (value) => _toggleTask(originalIndex),
                              ),
                              title: Text(
                                task.title,
                                style: TextStyle(
                                  decoration: task.isCompleted 
                                      ? TextDecoration.lineThrough 
                                      : null,
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outline_rounded),
                                color: Theme.of(context).colorScheme.error,
                                onPressed: () => _removeTask(originalIndex),
                              ),
                            ),
                          );
                        },
                      ),
              ),
              
              // Barra de digitação na parte inferior
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _taskController,
                        decoration: const InputDecoration(
                          hintText: 'Digite uma nova tarefa...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        onSubmitted: (value) => _addTask(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: _addTask,
                      icon: const Icon(Icons.add_circle_outline_rounded),
                      color: Theme.of(context).colorScheme.primary,
                      iconSize: 32,
                    ),
                    IconButton(
                      onPressed: _showShareOptions,
                      icon: const Icon(Icons.share_rounded),
                      color: Theme.of(context).colorScheme.primary,
                      iconSize: 32,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 