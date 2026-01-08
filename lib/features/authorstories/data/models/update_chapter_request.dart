class UpdateChapterRequest {
  final int id;
  final int storyId;
  final String name;
  final String content;
  final String? note;
  final int price;

  UpdateChapterRequest({
    required this.id,
    required this.storyId,
    required this.name,
    required this.content,
    this.note,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'story_id': storyId,
      'name': name,
      'content': content,
      'note': note ?? '',
      'price': price,
    };
  }
}
