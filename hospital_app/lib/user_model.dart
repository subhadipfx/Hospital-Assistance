class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final String lastUpdated;

  User({this.id, this.email, this.name, this.lastUpdated, this.role});

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      lastUpdated: json['updated_at'],
      role: json['role']
    );
  }
}