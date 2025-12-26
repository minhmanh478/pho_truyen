import 'package:get/get.dart';
import '../../data/models/ruby_package_model.dart';
import '../../data/models/payment_info_model.dart';
import '../pages/subfolder_page/ruby/payment_page.dart';

class LoadedRubyController extends GetxController {
  final rubyPackages = <RubyPackageModel>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRubyPackages();
  }

  void fetchRubyPackages() async {
    try {
      isLoading.value = true;
      await Future.delayed(const Duration(milliseconds: 500));

      // IDs 1 -> 6
      rubyPackages.value = [
        RubyPackageModel(id: 1, rubyAmount: 200, price: 10000),
        RubyPackageModel(id: 2, rubyAmount: 400, price: 20000),
        RubyPackageModel(id: 3, rubyAmount: 1000, price: 50000),
        RubyPackageModel(id: 4, rubyAmount: 2000, price: 100000),
        RubyPackageModel(id: 5, rubyAmount: 4000, price: 200000),
        RubyPackageModel(id: 6, rubyAmount: 10000, price: 500000),
      ];
    } catch (e) {
      print('Error fetching ruby packages: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void buyRuby(int packageId) {
    final package = rubyPackages.firstWhere(
      (p) => p.id == packageId,
      orElse: () => rubyPackages.first,
    );
    final amount = package.price;

    Get.to(
      () =>
          PaymentPage(paymentInfoFuture: _createPaymentInfo(packageId, amount)),
    );
  }

  Future<PaymentInfoModel> _createPaymentInfo(int packageId, int amount) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Mock Payment Info based on packageId
    // In real app, this comes from API response
    return PaymentInfoModel(
      qrCodeUrl:
          "https://img.vietqr.io/image/ACB-6692151-compact2.png?amount=$amount&addInfo=u103839t20251220t015711r5L2gk&accountName=NGUYEN%20MANH%20TUAN", // Example QR
      bankAccount: "6692151",
      bankName: "ACB",
      accountName: "NGUYEN MANH TUAN",
      amount: amount,
      content: "u103839t20251220t015711r5L2gk",
      note:
          "Lưu ý: Bắt buộc phải chuyển đúng nội dung và số tiền để hệ thống tự động cộng Ruby cho tài khoản của bạn. Thanh toán bằng quét mã QR thành công, chờ khoảng 10 giây. Sau đó tải lại trang để cập nhật Ruby",
    );
  }
}
