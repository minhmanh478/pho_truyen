import 'package:get/get.dart';

// Enum định nghĩa các kiểu sắp xếp
enum TimeType {
  newest, // Cập nhật mới nhất
  oldest, // Cập nhật cũ nhất
  mostChapters, // Nhiều chương nhất
  leastChapters, // Ít chương nhất
}

class FillerTimeController extends GetxController {
  // Biến observable lưu trạng thái hiện tại, mặc định là mới nhất
  var currentSort = TimeType.newest.obs;

  // Hàm thay đổi kiểu sắp xếp
  void changeSortType(TimeType type) {
    currentSort.value = type;

    // Gọi API hoặc sort list dữ liệu ở đây
    // fetchData(type);

    // Đóng bottom sheet sau khi chọn (nếu muốn)
    Get.back();
  }

  // Hàm helper để lấy text hiển thị từ Enum (Tiện cho việc hiển thị UI)
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
