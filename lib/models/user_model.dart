class UserModel {
  String? email;
  String? password;

  UserModel({this.email, this.password});

  UserModel copyWith({String? email, String? password}) {
    return UserModel(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toJson() => {
        'Email': email,
        'Senha': password,
      };
}
