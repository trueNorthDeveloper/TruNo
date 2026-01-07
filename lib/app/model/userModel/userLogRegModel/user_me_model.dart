class UsermeModel {
  final String role;
  final String name;
  final String email;
  final int id;

  UsermeModel({
    required this.role,
    required this.name,
    required this.email,
    required this.id,
  });

  // Convert JSON to UserModel
  factory UsermeModel.fromJson(Map<String, dynamic> json) {
    return UsermeModel(
      role: json['role'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      id: json['id'] ?? 0,
    );
  }

  // Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'name': name,
      'email': email,
      'id': id,
    };
  }
}
