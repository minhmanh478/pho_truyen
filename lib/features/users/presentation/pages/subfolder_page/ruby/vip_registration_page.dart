// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pho_truyen/core/constants/app_color.dart';

import 'package:intl/intl.dart';
import 'package:pho_truyen/core/constants/app_paths.dart';
import '../../../controllers/vip_registration_controller.dart';
import '../../../../data/models/vip_package_model.dart';

class VipRegistrationPage extends StatefulWidget {
  const VipRegistrationPage({super.key});

  @override
  State<VipRegistrationPage> createState() => _VipRegistrationPageState();
}

class _VipRegistrationPageState extends State<VipRegistrationPage> {
  final VipRegistrationController controller =
      Get.find<VipRegistrationController>();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = AppColor.isDarkMode(context);
    final Color textColor = AppColor.textColor(context);

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
          'VIP',
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

        if (controller.vipBundles.isEmpty) {
          return Center(
            child: Text(
              'Không có gói VIP nào',
              style: TextStyle(color: textColor),
            ),
          );
        }

        final bundle = controller.vipBundles.first;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColor.cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bundle.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: bundle.times
                        .map((time) => _buildVipPackageCard(time))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 16),
                _buildBenefitsList(bundle.rules),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildVipPackageCard(VipTimeModel time) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '');
    return Container(
      width: 108,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            time.name,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                currencyFormat.format(time.price).trim(),
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 4),
              Image.asset(AppPaths.icRuby, width: 15, height: 15),
            ],
          ),
          const SizedBox(height: 12),
          // đăng ký gói vip
          SizedBox(
            width: double.infinity,
            height: 32,
            child: ElevatedButton(
              onPressed: () {
                controller.onRegisterVip(time);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2C3E50),
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Đăng ký',
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitsList(List<VipRuleModel> rules) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rules
          .map(
            (rule) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                '- ${rule.name}',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          )
          .toList(),
    );
  }
}
