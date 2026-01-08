import '../../domain/entities/user_vip_entity.dart';

class UserVipModel extends UserVipEntity {
  UserVipModel({
    required DateTime timeStart,
    required DateTime timeEnd,
    required int priority,
    required int vipId,
    required String name,
    required List<String> rules,
  }) : super(
         timeStart: timeStart,
         timeEnd: timeEnd,
         priority: priority,
         vipId: vipId,
         name: name,
         rules: rules,
       );

  factory UserVipModel.fromJson(Map<String, dynamic> json) {
    return UserVipModel(
      timeStart: DateTime.parse(json['time_start']),
      timeEnd: DateTime.parse(json['time_end']),
      priority: json['priority'] ?? 0,
      vipId: json['vip_id'] ?? 0,
      name: json['name'] ?? '',
      rules: (json['rules'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}
