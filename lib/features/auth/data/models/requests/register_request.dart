class RegisterRequest {
  final String fullName;
  final String userName;
  final String email;
  final String password;

  RegisterRequest({
    required this.fullName,
    required this.userName,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    "full_name": fullName,
    "user_name": userName,
    "email": email,
    "password": password,
  };
}
