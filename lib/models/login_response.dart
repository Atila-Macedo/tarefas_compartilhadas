class LoginResponse {
  final int id;
  final String email;
  final String name;

  LoginResponse({
    required this.id,
    required this.email,
    required this.name,
  });

  LoginResponse copyWith({
    int? id,
    String? email,
    String? name,
  }) {
    return LoginResponse(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
    );
  }
  factory LoginResponse.fromJson(Map<String, dynamic> json){
    return LoginResponse(
      id: json['id'],
      name: json['nome'],
      email: json['email'],
    );
  }
} 