import 'package:get/get.dart';

enum TimeType {
  newest, // Cập nhật mới nhất
  oldest, // Cập nhật cũ nhất
  mostChapters, // Nhiều chương nhất
  leastChapters, // Ít chương nhất
}

class FillerTimeController extends GetxController {
  var currentSort = TimeType.newest.obs;
  void changeSortType(TimeType type) {
    currentSort.value = type;

    // Gọi API hoặc sort list dữ liệu ở đây
    // fetchData(type);

    Get.back();
  }

  String getTitle(TimeType type) {
    switch (type) {
      case TimeType.newest:
        return 'Cập nhật mới nhất';
      case TimeType.oldest:
        return 'Cập nhật cũ nhất';
      case TimeType.mostChapters:
        return 'Nhiều chương nhất';
      case TimeType.leastChapters:
        return 'Ít chương nhất';
    }
  }
}
