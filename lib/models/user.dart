class User {
  final String id;
  final String username;
  final String email;
  final String token;
  final DateTime createdAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.token,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    // Handle the API response structure: { "token": "...", "user": { ... } }
    final userJson = json['user'] ?? json; // Support both nested and flat structure
    return User(
      id: userJson['id'] ?? '',
      username: userJson['username'] ?? '',
      email: userJson['email'] ?? '',
      token: json['token'] ?? userJson['token'] ?? '', // Token can be at root or in user object
      createdAt: DateTime.tryParse(userJson['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'token': token,
      'created_at': createdAt.toIso8601String(),
    };
  }
} 