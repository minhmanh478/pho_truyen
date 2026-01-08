import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pho_truyen/core/constants/app_color.dart';

class AppDialogs {
  static void showConfirmDialog({
    required String title,
    required String message,
    required VoidCallback onConfirm,
    String confirmText = "Đồng ý",
    String cancelText = "Hủy",
    VoidCallback? onCancel,
  }) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: _buildDialogContent(
          title: title,
          message: message,
          confirmText: confirmText,
          cancelText: cancelText,
          onConfirm: onConfirm,
          onCancel: onCancel,
          isConfirm: true,
        ),
      ),
      barrierDismissible: false,
    );
  }

  static void showInfoDialog({
    required String title,
    required String message,
    String buttonText = "Đóng",
    VoidCallback? onPressed,
  }) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: _buildDialogContent(
          title: title,
          message: message,
          confirmText: buttonText,
          onConfirm: onPressed ?? () => Get.back(),
          isConfirm: false,
        ),
      ),
    );
  }

  static void showCustomDialog({
    required Widget content,
    bool barrierDismissible = true,
  }) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColor.cardColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: Offset(0.0, 10.0),
              ),
            ],
          ),
          child: content,
        ),
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  static Widget _buildDialogContent({
    required String title,
    required String message,
    required String confirmText,
    String? cancelText,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    required bool isConfirm,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColor.cardColor,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // To make the card compact
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16.0, color: Colors.white70),
          ),
          const SizedBox(height: 24.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (isConfirm && cancelText != null) ...[
                OutlinedButton(
                  onPressed: () {
                    if (onCancel != null) {
                      onCancel();
                    } else {
                      Get.back();
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                  ),
                  child: Text(
                    cancelText,
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ),
                const SizedBox(width: 24),
              ],
              ElevatedButton(
                onPressed: onConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  elevation: 2,
                ),
                child: Text(
                  confirmText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
