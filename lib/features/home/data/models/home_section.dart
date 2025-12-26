import 'package:pho_truyen/features/home/data/models/banner_model.dart';
import 'package:pho_truyen/features/home/data/models/story_model.dart';

enum HomeSectionType { banner, bannerImage, storyList, top, unknown }

class HomeSection {
  final String type;
  final String code;
  final String title;
  final int? limitMobile;

  // Các trường dữ liệu optional tùy thuộc vào `type`
  final List<BannerModel>? banners;
  final List<StoryModel>? stories;
  final List<HomeSection>? subSections;
  final String? imageUrl;

  HomeSection({
    required this.type,
    required this.code,
    required this.title,
    this.limitMobile,
    this.banners,
    this.stories,
    this.subSections,
    this.imageUrl,
  });

  factory HomeSection.fromJson(Map<String, dynamic> json) {
    final String typeStr = json['type'] ?? '';
    final dynamic rawData = json['data'];

    List<BannerModel>? banners;
    List<StoryModel>? stories;
    List<HomeSection>? subSections;
    String? imageUrl;

    // Logic phân loại dữ liệu
    if (rawData != null) {
      if (typeStr == 'BANNER') {
        banners = (rawData as List)
            .map((x) => BannerModel.fromJson(x))
            .toList();
      } else if (typeStr == 'BANNER_IMAGE') {
        imageUrl = rawData as String;
      } else if (typeStr == 'TOP') {
        // Đệ quy: TOP chứa danh sách các HomeSection con
        subSections = (rawData as List)
            .map((x) => HomeSection.fromJson(x))
            .toList();
      } else if (rawData is List) {
        // Các trường hợp còn lại (STORY_PROPOSAL, STORY_SHORT, STORY_NGUOC...)
        // được coi là danh sách truyện
        stories = rawData.map((x) => StoryModel.fromJson(x)).toList();
      }
    }

    return HomeSection(
      type: typeStr,
      code: json['code'] ?? '',
      title: json['title'] ?? '',
      limitMobile: json['limit_mobile'],
      banners: banners,
      stories: stories,
      subSections: subSections,
      imageUrl: imageUrl,
    );
  }

  // Helper để xác định loại section trên UI
  HomeSectionType get sectionType {
    if (type == 'BANNER') {
      return HomeSectionType.banner;
    }
    if (type == 'BANNER_IMAGE') {
      return HomeSectionType.bannerImage;
    }
    if (type == 'TOP') {
      return HomeSectionType.top;
    }
    if (stories != null && stories!.isNotEmpty) {
      return HomeSectionType.storyList;
    }
    // Các loại story list rỗng hoặc type lạ
    if (type.startsWith('STORY') || type == 'TEST123') {
      return HomeSectionType.storyList;
    }
    return HomeSectionType.unknown;
  }
}
