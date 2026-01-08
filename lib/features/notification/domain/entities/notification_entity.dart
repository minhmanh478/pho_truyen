class NotificationEntity {
  final int id;
  final String title;
  final String content;
  final String image;
  final bool isRead;
  final int type;
  final String payload;
  final DateTime? timeCreate;
  final String linkMobile;

  NotificationEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.image,
    required this.isRead,
    required this.type,
    required this.payload,
    this.timeCreate,
    required this.linkMobile,
  });
}
