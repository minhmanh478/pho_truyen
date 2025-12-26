// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pho_truyen/core/constants/app_color.dart';
import 'package:pho_truyen/core/constants/app_paths.dart';
import '../../../controllers/loaded_ruby_controller.dart';

class LoadedRubyPage extends StatefulWidget {
  const LoadedRubyPage({super.key});

  @override
  State<LoadedRubyPage> createState() => _LoadedRubyPageState();
}

class _LoadedRubyPageState extends State<LoadedRubyPage> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = AppColor.isDarkMode(context);
    final Color textColor = AppColor.textColor(context);
    final controller = Get.put(LoadedRubyController());

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
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.separated(
          itemCount: controller.rubyPackages.length,
          separatorBuilder: (context, index) => Divider(
            height: 1,
            color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
          ),
          itemBuilder: (context, index) {
            final package = controller.rubyPackages[index];
            final currencyFormat = NumberFormat.currency(
              locale: 'vi_VN',
              symbol: 'đ',
            );

            return InkWell(
              onTap: () {
                controller.buyRuby(package.id);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Nạp ${package.rubyAmount}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Image.asset(AppPaths.icRuby, width: 15, height: 15),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      currencyFormat.format(package.price),
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode
                            ? Colors.grey.shade400
                            : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
