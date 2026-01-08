import 'package:equatable/equatable.dart';

class AuthorStoryDetailEntity extends Equatable {
  final UserStoryDetail? detail;
  final UserStoryDetail? storyEdit;
  final List<StoryButton>? buttons;

  const AuthorStoryDetailEntity({this.detail, this.storyEdit, this.buttons});

  @override
  List<Object?> get props => [detail, storyEdit, buttons];
}

class UserStoryDetail extends Equatable {
  final int id;
  final int userId;
  final String? image;
  final String? name;
  final String? content;
  final String? description;
  final String? nameSearch;
  final String? slug;
  final String? tags;
  final String? categoryIds;
  final String? tagIds;
  final int price;
  final int salePrice;
  final int chapterCount;
  final int readCount;
  final int nominations;
  final int limitAge;
  final int isBuyFull;
  final int isFull;
  final int isVip;
  final int isDraft;
  final int isSendApproved;
  final int isApproved;
  final String? rejectMessage;
  final String? chapterReleaseSchedule;
  final int state;
  final String? stateName;
  final String? stateColor;

  const UserStoryDetail({
    required this.id,
    required this.userId,
    this.image,
    this.name,
    this.content,
    this.description,
    this.nameSearch,
    this.slug,
    this.tags,
    this.categoryIds,
    this.tagIds,
    this.price = 0,
    this.salePrice = 0,
    this.chapterCount = 0,
    this.readCount = 0,
    this.nominations = 0,
    this.limitAge = 0,
    this.isBuyFull = 0,
    this.isFull = 0,
    this.isVip = 0,
    this.isDraft = 0,
    this.isSendApproved = 0,
    this.isApproved = 0,
    this.rejectMessage,
    this.chapterReleaseSchedule,
    this.state = 0,
    this.stateName,
    this.stateColor,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    image,
    name,
    content,
    description,
    nameSearch,
    slug,
    tags,
    categoryIds,
    tagIds,
    price,
    salePrice,
    chapterCount,
    readCount,
    nominations,
    limitAge,
    isBuyFull,
    isFull,
    isVip,
    isDraft,
    isSendApproved,
    isApproved,
    rejectMessage,
    chapterReleaseSchedule,
    state,
    stateName,
    stateColor,
  ];
}

class StoryButton extends Equatable {
  final String title;
  final String code;

  const StoryButton({required this.title, required this.code});

  @override
  List<Object?> get props => [title, code];
}
