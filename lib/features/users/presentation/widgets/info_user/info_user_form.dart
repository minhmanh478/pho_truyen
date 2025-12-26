import 'package:flutter/material.dart';
import 'package:pho_truyen/core/constants/app_color.dart';
import 'package:pho_truyen/features/users/presentation/widgets/custom_label.dart';
import 'package:pho_truyen/features/users/presentation/widgets/custom_text_field.dart';

class InfoUserForm extends StatelessWidget {
  final TextEditingController fullNameController;
  final TextEditingController birthdayController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final int gender;
  final Function(int) onGenderChanged;
  final VoidCallback onSelectDate;
  final VoidCallback onChangePassword;
  final bool isDarkMode;

  const InfoUserForm({
    super.key,
    required this.fullNameController,
    required this.birthdayController,
    required this.phoneController,
    required this.emailController,
    required this.gender,
    required this.onGenderChanged,
    required this.onSelectDate,
    required this.onChangePassword,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDarkMode ? Colors.white : AppColor.slate900;
    final secondaryTextColor = isDarkMode
        ? Colors.grey.shade400
        : AppColor.slate600;
    final inputFillColor = isDarkMode ? Colors.grey.shade800 : AppColor.gray100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Full Name
        CustomLabel(text: "Họ và tên", textColor: textColor),
        const SizedBox(height: 8),
        CustomTextField(
          controller: fullNameController,
          hintText: "Nhập họ và tên",
          fillColor: inputFillColor,
          textColor: textColor,
        ),
        const SizedBox(height: 16),

        // Birthday
        CustomLabel(text: "Ngày sinh", textColor: textColor),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onSelectDate,
          child: AbsorbPointer(
            child: CustomTextField(
              controller: birthdayController,
              hintText: "Chọn ngày sinh",
              suffixIcon: Icons.calendar_today,
              fillColor: inputFillColor,
              textColor: textColor,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Gender
        CustomLabel(text: "Giới tính", textColor: textColor),
        Row(
          children: [
            _buildRadio(0, "Nam", textColor),
            const SizedBox(width: 16),
            _buildRadio(1, "Nữ", textColor),
            const SizedBox(width: 16),
            _buildRadio(2, "Khác", textColor),
          ],
        ),
        const SizedBox(height: 16),

        // Password (Fake field for UI matching)
        CustomLabel(text: "Mật khẩu", textColor: textColor),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: inputFillColor,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "*******",
                  style: TextStyle(
                    fontSize: 16,
                    letterSpacing: 2,
                    color: textColor,
                  ),
                ),
              ),
              TextButton(
                onPressed: onChangePassword,
                child: Text(
                  "Đổi mật khẩu",
                  style: TextStyle(
                    color: secondaryTextColor,
                    decoration: TextDecoration.underline,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Phone
        CustomLabel(text: "Số điện thoại", textColor: textColor),
        const SizedBox(height: 8),
        CustomTextField(
          controller: phoneController,
          enabled: false,
          fillColor: isDarkMode ? Colors.grey.shade900 : Colors.grey.shade300,
          textColor: textColor,
        ),
        const SizedBox(height: 16),

        // Email
        CustomLabel(text: "Email", textColor: textColor),
        const SizedBox(height: 8),
        CustomTextField(
          controller: emailController,
          enabled: false,
          fillColor: isDarkMode ? Colors.grey.shade900 : Colors.grey.shade300,
          textColor: textColor,
        ),
      ],
    );
  }

  Widget _buildRadio(int value, String label, Color textColor) {
    return Row(
      children: [
        Radio<int>(
          value: value,
          groupValue: gender,
          activeColor: AppColor.primary,
          onChanged: (int? newValue) {
            if (newValue != null) {
              onGenderChanged(newValue);
            }
          },
        ),
        Text(label, style: TextStyle(fontSize: 16, color: textColor)),
      ],
    );
  }
}
