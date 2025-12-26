// ignore_for_file: use_super_parameters

import '../../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required int id,
    required String fullName,
    String? avatar,
    String? birthday,
    required int gender,
    required String userName,
    required String email,
    String? phone,
    required int isVerifyEmail,
    String? userCode,
    String? role,
    String? permission,
    int? auth,
    int? type,
    int? isVietqr,
    String? typeName,
  }) : super(
         id: id,
         fullName: fullName,
         avatar: avatar,
         birthday: birthday,
         gender: gender,
         username: userName,
         email: email,
         phone: phone,
         isVerifyEmail: isVerifyEmail,
         userCode: userCode,
         role: role,
         permission: permission,
         auth: auth,
         type: type,
         isVietqr: isVietqr,
         typeName: typeName,
       );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      fullName: json['full_name'] ?? '',
      avatar: json['avatar'],
      birthday: json['birthday'],
      gender: json['gender'] ?? 0,
      userName: json['user_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone_number'],
      isVerifyEmail: json['is_verify_email'] ?? 0,
      userCode: json['user_code'],
      role: json['role'],
      permission: json['permission'],
      auth: json['auth'],
      type: json['type'],
      isVietqr: json['is_vietqr'],
      typeName: json['type_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'avatar': avatar,
      'birthday': birthday,
      'gender': gender,
      'user_name': username,
      'email': email,
      'phone_number': phone,
      'is_verify_email': isVerifyEmail,
      'user_code': userCode,
      'role': role,
      'permission': permission,
      'auth': auth,
      'type': type,
      'is_vietqr': isVietqr,
      'type_name': typeName,
    };
  }
}
