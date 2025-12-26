import 'dart:convert';
import 'package:pho_truyen/features/home/data/models/home_data.dart';

class GetHomeResponse {
  final String code;
  final String message;
  final HomeData? data;

  GetHomeResponse({required this.code, required this.message, this.data});

  factory GetHomeResponse.fromJson(Map<String, dynamic> json) {
    return GetHomeResponse(
      code: json['code'] ?? '',
      message: json['message'] ?? '',
      data: json['data'] != null ? HomeData.fromJson(json['data']) : null,
    );
  }

  static GetHomeResponse fromRawJson(String str) =>
      GetHomeResponse.fromJson(json.decode(str));
}
