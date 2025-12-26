class VipBundleModel {
  final int id;
  final String name;
  final List<VipTimeModel> times;
  final List<VipRuleModel> rules;

  VipBundleModel({
    required this.id,
    required this.name,
    required this.times,
    required this.rules,
  });

  factory VipBundleModel.fromJson(Map<String, dynamic> json) {
    return VipBundleModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      times:
          (json['times'] as List?)
              ?.map((e) => VipTimeModel.fromJson(e))
              .toList() ??
          [],
      rules:
          (json['rules'] as List?)
              ?.map((e) => VipRuleModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class VipTimeModel {
  final int id;
  final String name;
  final int price;
  final int priceOld;

  VipTimeModel({
    required this.id,
    required this.name,
    required this.price,
    required this.priceOld,
  });

  factory VipTimeModel.fromJson(Map<String, dynamic> json) {
    return VipTimeModel(
      id: json['time_id'] ?? 0,
      name: json['name'] ?? '',
      price: json['price'] ?? 0,
      priceOld: json['price_old'] ?? 0,
    );
  }
}

class VipRuleModel {
  final int id;
  final String name;
  final String code;

  VipRuleModel({required this.id, required this.name, required this.code});

  factory VipRuleModel.fromJson(Map<String, dynamic> json) {
    return VipRuleModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
    );
  }
}
