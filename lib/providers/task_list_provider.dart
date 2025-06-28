import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/task_list.dart';

class TaskListProvider extends ChangeNotifier {
  static const String _taskListsKey = 'task_lists';
  List<TaskList> _taskLists = [];
  bool _isLoading = false;

  List<TaskList> get taskLists => _taskLists;
  int get totalLists => _taskLists.length;
  int get completedListsCount => completedLists.length;
  bool get isLoading => _isLoading;

  TaskListProvider() {
    // Carrega os dados de forma assíncrona após a construção
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTaskLists();
    });
  }

  Future<void> _loadTaskLists() async {
    if (_isLoading) return;
    
    try {
      _isLoading = true;
      notifyListeners();
      
      final prefs = await SharedPreferences.getInstance();
      final taskListsJson = prefs.getStringList(_taskListsKey) ?? [];
      
      final loadedLists = <TaskList>[];
      
      for (final json in taskListsJson) {
        try {
          final map = jsonDecode(json) as Map<String, dynamic>;
          final taskList = TaskList.fromMap(map);
          loadedLists.add(taskList);
        } catch (e) {
          debugPrint('Erro ao carregar lista: $e');
          // Continua carregando outras listas
        }
      }
      
      _taskLists = loadedLists;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Erro ao carregar listas: $e');
      _isLoading = false;
      _taskLists = [];
      notifyListeners();
    }
  }

  Future<void> _saveTaskLists() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final taskListsJson = _taskLists
          .map((list) => jsonEncode(list.toMap()))
          .toList();
      
      await prefs.setStringList(_taskListsKey, taskListsJson);
    } catch (e) {
      debugPrint('Erro ao salvar listas: $e');
    }
  }

  // Criar nova lista
  Future<void> createTaskList(String name, List<Task> tasks, {String? description}) async {
    try {
      final newList = TaskList(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        description: description,
        createdAt: DateTime.now(),
        tasks: tasks,
        createdBy: 'current_user',
      );

      _taskLists.add(newList);
      await _saveTaskLists();
      notifyListeners();
    } catch (e) {
      debugPrint('Erro ao criar lista: $e');
      rethrow;
    }
  }

  // Atualizar lista
  Future<void> updateTaskList(String id, TaskList updatedList) async {
    try {
      final index = _taskLists.indexWhere((list) => list.id == id);
      if (index != -1) {
        _taskLists[index] = updatedList;
        await _saveTaskLists();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Erro ao atualizar lista: $e');
      rethrow;
    }
  }

  // Deletar lista
  Future<void> deleteTaskList(String id) async {
    try {
      _taskLists.removeWhere((list) => list.id == id);
      await _saveTaskLists();
      notifyListeners();
    } catch (e) {
      debugPrint('Erro ao deletar lista: $e');
      rethrow;
    }
  }

  // Adicionar tarefa a uma lista
  Future<void> addTaskToList(String listId, Task task) async {
    try {
      final index = _taskLists.indexWhere((list) => list.id == listId);
      if (index != -1) {
        final updatedTasks = List<Task>.from(_taskLists[index].tasks)..add(task);
        final updatedList = _taskLists[index].copyWith(tasks: updatedTasks);
        _taskLists[index] = updatedList;
        await _saveTaskLists();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Erro ao adicionar tarefa: $e');
      rethrow;
    }
  }

  // Atualizar tarefa
  Future<void> updateTask(String listId, String taskId, Task updatedTask) async {
    try {
      final listIndex = _taskLists.indexWhere((list) => list.id == listId);
      if (listIndex != -1) {
        final taskIndex = _taskLists[listIndex].tasks.indexWhere((task) => task.id == taskId);
        if (taskIndex != -1) {
          final updatedTasks = List<Task>.from(_taskLists[listIndex].tasks);
          updatedTasks[taskIndex] = updatedTask;
          final updatedList = _taskLists[listIndex].copyWith(tasks: updatedTasks);
          _taskLists[listIndex] = updatedList;
          await _saveTaskLists();
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Erro ao atualizar tarefa: $e');
      rethrow;
    }
  }

  // Remover tarefa
  Future<void> removeTask(String listId, String taskId) async {
    try {
      final listIndex = _taskLists.indexWhere((list) => list.id == listId);
      if (listIndex != -1) {
        final updatedTasks = _taskLists[listIndex].tasks.where((task) => task.id != taskId).toList();
        final updatedList = _taskLists[listIndex].copyWith(tasks: updatedTasks);
        _taskLists[listIndex] = updatedList;
        await _saveTaskLists();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Erro ao remover tarefa: $e');
      rethrow;
    }
  }

  // Compartilhar lista
  Future<void> shareTaskList(String listId, String userEmail) async {
    try {
      final index = _taskLists.indexWhere((list) => list.id == listId);
      if (index != -1) {
        final updatedSharedUsers = List<String>.from(_taskLists[index].sharedUsers);
        if (!updatedSharedUsers.contains(userEmail)) {
          updatedSharedUsers.add(userEmail);
          final updatedList = _taskLists[index].copyWith(sharedUsers: updatedSharedUsers);
          _taskLists[index] = updatedList;
          await _saveTaskLists();
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Erro ao compartilhar lista: $e');
      rethrow;
    }
  }

  // Remover compartilhamento
  Future<void> unshareTaskList(String listId, String userEmail) async {
    try {
      final index = _taskLists.indexWhere((list) => list.id == listId);
      if (index != -1) {
        final updatedSharedUsers = _taskLists[index].sharedUsers.where((email) => email != userEmail).toList();
        final updatedList = _taskLists[index].copyWith(sharedUsers: updatedSharedUsers);
        _taskLists[index] = updatedList;
        await _saveTaskLists();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Erro ao remover compartilhamento: $e');
      rethrow;
    }
  }

  // Buscar lista por ID
  TaskList? getTaskListById(String id) {
    try {
      return _taskLists.firstWhere((list) => list.id == id);
    } catch (e) {
      return null;
    }
  }

  // Listas ordenadas por data de criação (mais recentes primeiro)
  List<TaskList> get sortedTaskLists {
    final sorted = List<TaskList>.from(_taskLists);
    sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted;
  }

  // Listas com tarefas pendentes
  List<TaskList> get listsWithPendingTasks {
    return _taskLists.where((list) => list.pendingTasks > 0).toList();
  }

  // Getter para a lista de listas completas
  List<TaskList> get completedLists {
    return _taskLists.where((list) => list.isCompleted).toList();
  }

  // Recarregar dados
  Future<void> refresh() async {
    await _loadTaskLists();
  }

  // Criar dados de exemplo (para teste)
  Future<void> createSampleData() async {
    try {
      final sampleTasks1 = [
        Task(id: '1', title: 'Comprar pão'),
        Task(id: '2', title: 'Fazer exercícios'),
        Task(id: '3', title: 'Ler um livro'),
      ];

      final sampleTasks2 = [
        Task(id: '4', title: 'Estudar Flutter'),
        Task(id: '5', title: 'Fazer projeto', isCompleted: true),
      ];

      await createTaskList('Lista de Compras', sampleTasks1, description: 'Tarefas do dia a dia');
      await createTaskList('Estudos', sampleTasks2, description: 'Tarefas de aprendizado');
      
      debugPrint('Dados de exemplo criados com sucesso!');
    } catch (e) {
      debugPrint('Erro ao criar dados de exemplo: $e');
    }
  }

  // Limpar todos os dados
  Future<void> clearAllData() async {
    try {
      _taskLists.clear();
      await _saveTaskLists();
      notifyListeners();
      debugPrint('Todos os dados foram limpos!');
    } catch (e) {
      debugPrint('Erro ao limpar dados: $e');
    }
  }
} 