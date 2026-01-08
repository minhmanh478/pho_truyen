import 'package:equatable/equatable.dart';
import '../../domain/entities/author_story_detail_entity.dart';

class AuthorChapterDetailEntity extends Equatable {
  final int id;
  final int appId;
  final int userId;
  final int storyId;
  final int chapterNumber;
  final String? image;
  final String name;
  final String slug;
  final String? content;
  final String? description;
  final String? nameSearch;
  final String? note;
  final int adultContent;
  final int isLock;
  final int price;
  final int salePrice;
  final int order;
  final int readCount;
  final int isDraft;
  final int isSendApproved;
  final int isApproved;
  final String? rejectMessage;
  final int type;
  final int state;
  final String? timeUpdate;
  final String? timeCreate;
  final String? stateName;
  final String? stateColor;

  const AuthorChapterDetailEntity({
    required this.id,
    required this.appId,
    required this.userId,
    required this.storyId,
    required this.chapterNumber,
    this.image,
    required this.name,
    required this.slug,
    this.content,
    this.description,
    this.nameSearch,
    this.note,
    required this.adultContent,
    required this.isLock,
    required this.price,
    required this.salePrice,
    required this.order,
    required this.readCount,
    required this.isDraft,
    required this.isSendApproved,
    required this.isApproved,
    this.rejectMessage,
    required this.type,
    required this.state,
    this.timeUpdate,
    this.timeCreate,
    this.stateName,
    this.stateColor,
  });

  @override
  List<Object?> get props => [
    id,
    appId,
    userId,
    storyId,
    chapterNumber,
    image,
    name,
    slug,
    content,
    description,
    nameSearch,
    note,
    adultContent,
    isLock,
    price,
    salePrice,
    order,
    readCount,
    isDraft,
    isSendApproved,
    isApproved,
    rejectMessage,
    type,
    state,
    timeUpdate,
    timeCreate,
    stateName,
    stateColor,
  ];
}

class AuthorChapterDetailResultEntity extends Equatable {
  final AuthorChapterDetailEntity detail;
  final List<StoryButton>? buttons;

  const AuthorChapterDetailResultEntity({required this.detail, this.buttons});

  @override
  List<Object?> get props => [detail, buttons];
}
