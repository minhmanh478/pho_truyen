import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pho_truyen/core/constants/app_color.dart';
import '../../../controllers/account/info_author_controller.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/custom_label.dart';

class InfoAuthorPage extends StatefulWidget {
  const InfoAuthorPage({super.key});

  @override
  State<InfoAuthorPage> createState() => _InfoAuthorPageState();
}

class _InfoAuthorPageState extends State<InfoAuthorPage> {
  final InfoAuthorController controller = Get.put(
    InfoAuthorController(userRepository: Get.find()),
  );

  final _bankNameController = TextEditingController();
  final _bankNumberController = TextEditingController();
  final _bankAccountHolderNameController = TextEditingController();
  final _identifyNumberController = TextEditingController();
  final _introduceController = TextEditingController();
  final _notiController = TextEditingController();

  @override
  void dispose() {
    _bankNameController.dispose();
    _bankNumberController.dispose();
    _bankAccountHolderNameController.dispose();
    _identifyNumberController.dispose();
    _introduceController.dispose();
    _notiController.dispose();
    super.dispose();
  }

  void _onSave() async {
    final success = await controller.updateInfoExtend(
      bankName: _bankNameController.text,
      bankNumber: _bankNumberController.text,
      bankAccountHolderName: _bankAccountHolderNameController.text,
      identifyNumber: _identifyNumberController.text,
      introduce: _introduceController.text,
      noti: _notiController.text,
    );

    if (success) {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = AppColor.isDarkMode(context);
    final Color textColor = AppColor.textColor(context);
    final Color inputFillColor = AppColor.inputFillColor(context);
    final Color? borderColor = isDarkMode ? Colors.white24 : null;
    final Color effectiveFillColor = isDarkMode
        ? Colors.transparent
        : inputFillColor;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode
            ? Colors.transparent
            : Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColor.textColor(context)),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Hồ sơ tác giả',
          style: TextStyle(
            color: AppColor.textColor(context),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final info = controller.userExtendInfo.value;
        if (info != null) {
          _bankNameController.text = info.bankName ?? '';
          _bankNumberController.text = info.bankNumber ?? '';
          _bankAccountHolderNameController.text =
              info.bankAccountHolderName ?? '';
          _identifyNumberController.text = info.identifyNumber ?? '';
          _introduceController.text = info.introduce ?? '';
          _notiController.text = info.noti ?? '';
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ngân hàng
              CustomLabel(text: "Tên ngân hàng", textColor: textColor),
              const SizedBox(height: 8),
              CustomTextField(
                controller: _bankNameController,
                hintText: "Nhập tên ngân hàng (VD: MB Bank)",
                fillColor: effectiveFillColor,
                textColor: textColor,
                borderColor: borderColor,
              ),
              const SizedBox(height: 16),

              // Số tài khoản
              CustomLabel(text: "Số tài khoản", textColor: textColor),
              const SizedBox(height: 8),
              CustomTextField(
                controller: _bankNumberController,
                hintText: "Nhập số tài khoản",
                fillColor: effectiveFillColor,
                textColor: textColor,
                borderColor: borderColor,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              // Tên chủ tài khoản
              CustomLabel(text: "Tên chủ tài khoản", textColor: textColor),
              const SizedBox(height: 8),
              CustomTextField(
                controller: _bankAccountHolderNameController,
                hintText: "Nhập tên chủ tài khoản",
                fillColor: effectiveFillColor,
                textColor: textColor,
                borderColor: borderColor,
                inputFormatters: [UpperCaseTextFormatter()],
              ),
              const SizedBox(height: 16),

              // CCCD/CMND
              // CustomLabel(text: "CCCD/CMND", textColor: textColor),
              // const SizedBox(height: 8),
              // CustomTextField(
              //   controller: _identifyNumberController,
              //   hintText: "Nhập số CCCD/CMND",
              //   fillColor: inputFillColor,
              //   textColor: textColor,
              //   keyboardType: TextInputType.number,
              // ),
              // const SizedBox(height: 16),

              // Giới thiệu bản thân
              CustomLabel(text: "Giới thiệu bản thân", textColor: textColor),
              const SizedBox(height: 8),
              CustomTextField(
                controller: _introduceController,
                hintText: "Nhập giới thiệu bản thân",
                fillColor: effectiveFillColor,
                textColor: textColor,
                borderColor: borderColor,
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // Thông báo
              // CustomLabel(text: "Thông báo", textColor: textColor),
              // const SizedBox(height: 8),
              // CustomTextField(
              //   controller: _notiController,
              //   hintText: "Nhập thông báo",
              //   fillColor: inputFillColor,
              //   textColor: textColor,
              //   maxLines: 2,
              // ),
              // const SizedBox(height: 32),

              // Buttons moved to bottomNavigationBar
            ],
          ),
        );
      }),
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 30),
        decoration: BoxDecoration(
          color: isDarkMode
              ? Theme.of(context).scaffoldBackgroundColor
              : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Get.back(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: AppColor.textColor(context)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "Hủy",
                  style: TextStyle(
                    color: AppColor.textColor(context),
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDarkMode
                      ? AppColor.cardColor
                      : AppColor.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Lưu",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text;
    String unaccented = _removeDiacritics(text);
    return newValue.copyWith(
      text: unaccented.toUpperCase(),
      selection: newValue.selection,
    );
  }

  String _removeDiacritics(String str) {
    var withDia =
        'áàảãạăắằẳẵặâấầẩẫậéèẻẽẹêếềểễệíìỉĩịóòỏõọôốồổỗộơớờởỡợúùủũụưứừửữựýỳỷỹỵđÁÀẢÃẠĂẮẰẲẴẶÂẤẦẨẪẬÉÈẺẼẸÊẾỀỂỄỆÍÌỈĨỊÓÒỎÕỌÔỐỒỔỖỘƠỚỜỞỠỢÚÙỦŨỤƯỨỪỬỮỰÝỲỶỸỴĐ';
    var withoutDia =
        'aaaaaaaaaaaaaaaaaeeeeeeeeeeeiiiiiooooooooooooooooouuuuuuuuuuuyyyyydAAAAAAAAAAAAAAAAAEEEEEEEEEEEIIIIIOOOOOOOOOOOOOOOOOUUUUUUUUUUUYYYYYD';

    for (int i = 0; i < withDia.length; i++) {
      str = str.replaceAll(withDia[i], withoutDia[i]);
    }
    return str;
  }
}
