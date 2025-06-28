class TaskList {
  final String id;
  final String name;
  final String? description;
  final DateTime createdAt;
  final List<String> sharedUsers;
  final List<Task> tasks;
  final String createdBy;

  TaskList({
    required this.id,
    required this.name,
    this.description,
    required this.createdAt,
    this.sharedUsers = const [],
    this.tasks = const [],
    required this.createdBy,
  });

  // Converte para Map (para salvar no SharedPreferences)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'sharedUsers': sharedUsers,
      'tasks': tasks.map((task) => task.toMap()).toList(),
      'createdBy': createdBy,
    };
  }

  // Cria a partir de um Map
  factory TaskList.fromMap(Map<String, dynamic> map) {
    try {
      return TaskList(
        id: map['id']?.toString() ?? '',
        name: map['name']?.toString() ?? '',
        description: map['description']?.toString(),
        createdAt: map['createdAt'] != null 
            ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int)
            : DateTime.now(),
        sharedUsers: (map['sharedUsers'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ?? [],
        tasks: (map['tasks'] as List<dynamic>?)
                ?.map((task) => Task.fromMap(task as Map<String, dynamic>))
                .toList() ?? [],
        createdBy: map['createdBy']?.toString() ?? 'current_user',
      );
    } catch (e) {
      // Retorna uma lista padrão em caso de erro
      return TaskList(
        id: map['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: map['name']?.toString() ?? 'Lista Corrompida',
        description: 'Esta lista foi corrompida e não pode ser carregada completamente',
        createdAt: DateTime.now(),
        sharedUsers: [],
        tasks: [],
        createdBy: 'system',
      );
    }
  }

  // Cria uma cópia com modificações
  TaskList copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? createdAt,
    List<String>? sharedUsers,
    List<Task>? tasks,
    String? createdBy,
  }) {
    return TaskList(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      sharedUsers: sharedUsers ?? this.sharedUsers,
      tasks: tasks ?? this.tasks,
      createdBy: createdBy ?? this.createdBy,
    );
  }

  // Getters úteis
  int get totalTasks => tasks.length;
  int get completedTasks => tasks.where((task) => task.isCompleted).length;
  int get pendingTasks => totalTasks - completedTasks;
  double get completionPercentage => totalTasks > 0 ? completedTasks / totalTasks : 0.0;
  bool get isCompleted => totalTasks > 0 && completedTasks == totalTasks;
}

class Task {
  final String id;
  final String title;
  final bool isCompleted;
  final DateTime? completedAt;

  Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.completedAt,
  });

  // Converte para Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
      'completedAt': completedAt?.millisecondsSinceEpoch,
    };
  }

  // Cria a partir de um Map
  factory Task.fromMap(Map<String, dynamic> map) {
    try {
      return Task(
        id: map['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: map['title']?.toString() ?? 'Tarefa sem título',
        isCompleted: map['isCompleted'] as bool? ?? false,
        completedAt: map['completedAt'] != null
            ? DateTime.fromMillisecondsSinceEpoch(map['completedAt'] as int)
            : null,
      );
    } catch (e) {
      // Retorna uma tarefa padrão em caso de erro
      return Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'Tarefa Corrompida',
        isCompleted: false,
        completedAt: null,
      );
    }
  }

  // Cria uma cópia com modificações
  Task copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    DateTime? completedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
    );
  }
} 