import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pho_truyen/core/constants/app_color.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pho_truyen/core/utils/app_dialogs.dart';
import 'package:get/get.dart';

class AppActions {
  // link nộp phạt
  static Future<void> openPhatNguoiLink() async {
    final Uri url = Uri.parse('https://dichvucong.gov.vn/');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Không thể mở đường link: $url');
    }
  }

  // bảo mật
  static Future<void> openbaomat() async {
    final Uri url = Uri.parse(
      'https://docs.google.com/document/d/1yDN9-m4mKYonmhFHvqSqo4O4dOXNZCfV0RgnFwDMQDU/edit?usp=sharing',
    );
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Không thể mở đường link: $url');
    }
  }

  // chính sách quy định
  static Future<void> openchinhsachquydinh() async {
    final Uri url = Uri.parse(
      'https://docs.google.com/document/d/1yDN9-m4mKYonmhFHvqSqo4O4dOXNZCfV0RgnFwDMQDU/edit?usp=sharing',
    );
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Không thể mở đường link: $url');
    }
  }

  // toast chưa có
  static Future<void> opentoast(BuildContext context) async {
    ShadToaster.of(context).show(
      const ShadToast(
        description: Text('Tính năng đang được phát triển'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  // static Future<void> openUngHo(BuildContext context) async {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (_) => const QrDonateScreen()),
  //   );
  // }

  static Future<void> openContact(BuildContext context) async {
    AppDialogs.showCustomDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Row(
            children: [
              Icon(Icons.support_agent_rounded, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Liên hệ hỗ trợ',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Vui lòng gửi email đến:\n\nlemanh134@gmail.com',
            style: TextStyle(fontSize: 15, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  Clipboard.setData(
                    const ClipboardData(text: 'lemanh134@gmail.com'),
                  );
                  Get.back();
                  ShadToaster.of(context).show(
                    const ShadToast(
                      description: Text('Đã sao chép email!'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                child: const Text(
                  'Sao chép',
                  style: TextStyle(color: Colors.white54),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final Uri emailLaunchUri = Uri(
                    scheme: 'mailto',
                    path: 'lemanh134@gmail.com',
                    query: 'subject=Hỗ trợ ứng dụng&body=Chào bạn,',
                  );
                  final ok = await launchUrl(emailLaunchUri);
                  Get.back();
                  if (!ok) {
                    // ignore: use_build_context_synchronously
                    ShadToaster.of(context).show(
                      const ShadToast(
                        description: Text('Không thể mở ứng dụng email'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Gửi mail',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //   ShadButton.outline(
  //   child: const Text('Show Toast'),
  //   onPressed: () {
  //     ShadToaster.of(context).show(
  //       const ShadToast(
  //         description: Text('Your message has been sent.'),
  //       ),
  //     );
  //   },
  // ),
}

// https://docs.google.com/document/d/1ftuP9DxLwlBQNY0qfc2xC8JhKbp5kbyxunQ0BTQZgPk/edit?usp=sharing
