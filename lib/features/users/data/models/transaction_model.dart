class TransactionModel {
  final int id;
  final String name;
  final int availableBalance;
  final int oldAvailableBalance;
  final String note;
  final int type;
  final int state;
  final String timeCreate;
  final String stateName;
  final String currencyType;

  TransactionModel({
    required this.id,
    required this.name,
    required this.availableBalance,
    required this.oldAvailableBalance,
    required this.note,
    required this.type,
    required this.state,
    required this.timeCreate,
    required this.stateName,
    required this.currencyType,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      availableBalance: json['available_balance'] ?? 0,
      oldAvailableBalance: json['old_available_balance'] ?? 0,
      note: json['note'] ?? '',
      type: json['type'] ?? 0,
      state: json['state'] ?? 0,
      timeCreate: json['time_create'] ?? '',
      stateName: json['state_name'] ?? '',
      currencyType: json['currency_type'] ?? '',
    );
  }
}
