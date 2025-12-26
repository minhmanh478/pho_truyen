// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pho_truyen/core/constants/app_color.dart';
import 'package:pho_truyen/features/users/presentation/controllers/account/user_controller.dart';
import 'package:pho_truyen/features/users/presentation/widgets/info_user/change_password_dialog.dart';
import 'package:pho_truyen/features/users/presentation/widgets/info_user/info_user_actions.dart';
import 'package:pho_truyen/features/users/presentation/widgets/info_user/info_user_avatar.dart';
import 'package:pho_truyen/features/users/presentation/widgets/info_user/info_user_form.dart';

class InfoUserPage extends StatefulWidget {
  const InfoUserPage({super.key});

  @override
  State<InfoUserPage> createState() => _InfoUserPageState();
}

class _InfoUserPageState extends State<InfoUserPage> {
  late UserController controller;
  final _fullNameController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  // 0: Nam, 1: Nữ, 2: Khác
  int _gender = 0;
  String? _avatarUrl;

  @override
  void initState() {
    super.initState();
    controller = Get.find<UserController>();
    _loadUserData();
  }

  void _loadUserData() {
    final profile = controller.userProfile.value;
    if (profile != null) {
      _fullNameController.text = profile.user.fullName;
      _birthdayController.text = profile.user.birthday ?? '';
      _phoneController.text = profile.user.phone ?? '';
      _emailController.text = profile.user.email;
      _gender = profile.user.gender;
      _avatarUrl = profile.user.avatar;
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _birthdayController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColor.primary,
              onPrimary: Colors.white,
              onSurface: AppColor.blackPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _birthdayController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  void _onSave() async {
    // Show loading dialog
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    final success = await controller.updateProfile(
      fullName: _fullNameController.text,
      birthday: _birthdayController.text,
      gender: _gender,
      avatar: _avatarUrl,
    );

    Get.back();

    if (success) {
      Get.back(result: true);
    }
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => const ChangePasswordDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = isDarkMode ? Colors.white : AppColor.slate900;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode
            ? Colors.transparent
            : Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Chỉnh sửa hồ sơ',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoUserAvatar(
              icon: Icons.camera_alt,
              avatarUrl: _avatarUrl,
              isDarkMode: isDarkMode,
              showEditIcon: true,
              onCameraTap: () {
                // TODO: Implement image picker
                Get.snackbar("Thông báo", "Chức năng đang phát triển");
              },
            ),
            const SizedBox(height: 24),
            InfoUserForm(
              fullNameController: _fullNameController,
              birthdayController: _birthdayController,
              phoneController: _phoneController,
              emailController: _emailController,
              gender: _gender,
              onGenderChanged: (value) => setState(() => _gender = value),
              onSelectDate: () => _selectDate(context),
              onChangePassword: _showChangePasswordDialog,
              isDarkMode: isDarkMode,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: InfoUserActions(
        onSave: _onSave,
        onCancel: () => Get.back(),
        isDarkMode: isDarkMode,
      ),
    );
  }
}
