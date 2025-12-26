class BannerModel {
  final int id;
  final String code;
  final int objectId;
  final int objectType;
  final String image;
  final String link;
  final String? linkMobile; // JSON String
  final int state;
  final String? timeUpdate;

  BannerModel({
    required this.id,
    required this.code,
    required this.objectId,
    required this.objectType,
    required this.image,
    required this.link,
    this.linkMobile,
    this.state = 1,
    this.timeUpdate,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] ?? 0,
      code: json['code'] ?? '',
      objectId: json['object_id'] ?? 0,
      objectType: json['object_type'] ?? 0,
      image: json['image'] ?? '',
      link: json['link'] ?? '',
      linkMobile: json['link_mobile'],
      state: json['state'] ?? 1,
      timeUpdate: json['time_update'],
    );
  }
}
