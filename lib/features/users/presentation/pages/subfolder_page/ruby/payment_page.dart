import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pho_truyen/core/constants/app_color.dart';
import '../../../../data/models/payment_info_model.dart';

class PaymentPage extends StatelessWidget {
  final Future<PaymentInfoModel> paymentInfoFuture;

  const PaymentPage({super.key, required this.paymentInfoFuture});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = AppColor.isDarkMode(context);
    final Color textColor = AppColor.textColor(context);
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

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
          'Nạp Ruby',
          style: TextStyle(
            color: AppColor.textColor(context),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<PaymentInfoModel>(
        future: paymentInfoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final paymentInfo = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // QR Code Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        paymentInfo.qrCodeUrl.isNotEmpty
                            ? Image.network(
                                paymentInfo.qrCodeUrl,
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        width: 250,
                                        height: 250,
                                        color: Colors.grey.shade200,
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    },
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 250,
                                    height: 250,
                                    color: Colors.grey.shade200,
                                    child: const Center(
                                      child: Text("Chưa có QR Code"),
                                    ),
                                  );
                                },
                              )
                            : Container(
                                width: 250,
                                height: 250,
                                color: Colors.grey.shade200,
                                child: const Center(
                                  child: Text("Chưa có QR Code"),
                                ),
                              ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Bank Details
                  _buildDetailRow(
                    label: "Số tài khoản:",
                    value: paymentInfo.bankAccount,
                    textColor: textColor,
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    label: "Tên người nhận:",
                    value: paymentInfo.accountName.toUpperCase(),
                    textColor: textColor,
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    label: "Số tiền:",
                    value: currencyFormat.format(paymentInfo.amount),
                    textColor: textColor,
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    label: "Nội dung chuyển khoản:",
                    value: paymentInfo.content,
                    textColor: textColor,
                    isCopyable: true,
                  ),

                  const SizedBox(height: 8),
                  Text(
                    paymentInfo.note,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _buildDetailRow({
    required String label,
    required String value,
    required Color textColor,
    bool isCopyable = false,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 14),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (isCopyable) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  //TODO: Get.snackbar("Đã sao chép", "Nội dung đã được sao chép vào bộ nhớ tạm");
                },
                child: const Icon(Icons.copy, size: 16, color: Colors.grey),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
