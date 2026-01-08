class NotificationModel {
  final int id;
  final String title;
  final String content;
  final String image;
  final int isRead;
  final int type;
  final String payload;
  final String timeCreate;
  final String? link;
  final String linkMobile;

  NotificationModel({
    required this.id,
    required this.title,
    required this.content,
    required this.image,
    required this.isRead,
    required this.type,
    required this.payload,
    required this.timeCreate,
    this.link,
    required this.linkMobile,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      image: json['image'] ?? '',
      isRead: json['is_read'] ?? 0,
      type: json['type'] ?? 0,
      payload: json['payload'] ?? '',
      timeCreate: json['time_create'] ?? '',
      link: json['link'],
      linkMobile: json['link_mobile'] ?? '',
    );
  }
}
