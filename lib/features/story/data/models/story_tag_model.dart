class StoryTagModel {
  final int id;
  final String name;
  final String slug;

  StoryTagModel({required this.id, required this.name, required this.slug});

  factory StoryTagModel.fromJson(Map<String, dynamic> json) {
    return StoryTagModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'slug': slug};
  }
}
