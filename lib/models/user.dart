class User {
  final String? id;
  final String name;
  final int age;
  final String email;
  final String password;

  User({
    this.id, 
    required this.name,
    required this.age,
    required this.email,
    required this.password,
  });

factory User.fromJson(Map<String, dynamic> json) {
  return User(
    id: json['_id'] as String? ?? json['id'] as String?,
    name: json['name']  as String?   ?? '',
    age:  json['age']   as int?      ?? 0,
    email: json['email'] as String?  ?? '',
    password: json['password'] as String? ?? '',
  );
}

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'name': name,
      'age': age,
      'email': email,
      'password': password,
    };
  }
}
