class UserVipEntity {
  final DateTime timeStart;
  final DateTime timeEnd;
  final int priority;
  final int vipId;
  final String name;
  final List<String> rules;

  UserVipEntity({
    required this.timeStart,
    required this.timeEnd,
    required this.priority,
    required this.vipId,
    required this.name,
    required this.rules,
  });
}
