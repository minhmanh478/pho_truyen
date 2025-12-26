class UserEntity {
  final int id;
  final String username;
  final String email;
  final String fullName;
  final String? avatar;
  final String? birthday;
  final int gender;
  final String? phone;
  final int isVerifyEmail;
  final String? userCode;
  final String? role;
  final String? permission;
  final int? auth;
  final int? type;
  final int? isVietqr;
  final String? typeName;

  UserEntity({
    required this.id,
    required this.username,
    required this.email,
    required this.fullName,
    this.avatar,
    this.birthday,
    required this.gender,
    this.phone,
    required this.isVerifyEmail,
    this.userCode,
    this.role,
    this.permission,
    this.auth,
    this.type,
    this.isVietqr,
    this.typeName,
  });
}
