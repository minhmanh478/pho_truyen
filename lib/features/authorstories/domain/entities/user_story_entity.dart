class UserStoryEntity {
  final int id;
  final String name;
  final String? image;
  final String? content;
  final String? description;
  final String? chapterReleaseSchedule;
  final String? slug;
  final int chapterCount;
  final int chapterAuthorCount;
  final int readCount;
  final int commentCount;
  final int nominations;
  final String stateName;
  final String stateColor;
  final DateTime? timeUpdate;

  UserStoryEntity({
    required this.id,
    required this.name,
    this.image,
    this.content,
    this.description,
    this.chapterReleaseSchedule,
    this.slug,
    this.chapterCount = 0,
    this.chapterAuthorCount = 0,
    this.readCount = 0,
    this.commentCount = 0,
    this.nominations = 0,
    this.stateName = 'Truyện nháp',
    this.stateColor = '4db6ac',
    this.timeUpdate,
  });
}
