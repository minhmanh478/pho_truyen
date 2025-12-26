import 'package:pho_truyen/features/home/data/models/home_section.dart';

class HomeData {
  final List<HomeSection> listHome;

  HomeData({required this.listHome});

  factory HomeData.fromJson(Map<String, dynamic> json) {
    return HomeData(
      listHome:
          (json['list_home'] as List?)
              ?.map((x) => HomeSection.fromJson(x))
              .toList() ??
          [],
    );
  }
}
