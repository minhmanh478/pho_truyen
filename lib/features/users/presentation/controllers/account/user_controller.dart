import 'package:get/get.dart';
import '../../../domain/entities/user_profile_entity.dart';
import '../../../domain/usecases/change_password_usecase.dart';
import '../../../domain/usecases/get_user_profile_usecase.dart';
import '../../../domain/usecases/update_profile_usecase.dart';
import '../../../../common/domain/usecases/upload_image_usecase.dart';
import 'dart:io';

class UserController extends GetxController {
  final GetUserProfileUseCase getUserProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final ChangePasswordUseCase changePasswordUseCase;
  final UploadImageUseCase uploadImageUseCase;

  final Rx<UserProfileEntity?> userProfile = Rx<UserProfileEntity?>(null);
  bool hasShownAffiliateAd = false;

  UserController({
    required this.getUserProfileUseCase,
    required this.updateProfileUseCase,
    required this.changePasswordUseCase,
    required this.uploadImageUseCase,
  });

  Future<UserProfileEntity?> fetchUserProfile() async {
    final result = await getUserProfileUseCase();
    return result.fold(
      (failure) {
        Get.snackbar("Lỗi", failure.message);
        return null;
      },
      (profile) {
        userProfile.value = profile;
        return profile;
      },
    );
  }

  Future<bool> updateProfile({
    required String fullName,
    String? avatar,
    String? birthday,
    required int gender,
  }) async {
    final result = await updateProfileUseCase(
      fullName: fullName,
      avatar: avatar,
      birthday: birthday,
      gender: gender,
    );

    return result.fold(
      (failure) {
        Get.snackbar("Lỗi", failure.message);
        return false;
      },
      (success) {
        fetchUserProfile();
        return true;
      },
    );
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final result = await changePasswordUseCase(
      oldPassword: oldPassword,
      newPassword: newPassword,
    );

    result.fold(
      (failure) {
        Get.snackbar("Lỗi", failure.message);
      },
      (success) {
        Get.snackbar("Thành công", "Đổi mật khẩu thành công");
      },
    );
  }

  Future<String?> uploadAvatar(File file) async {
    final result = await uploadImageUseCase(file);
    return result.fold(
      (failure) {
        Get.snackbar("Lỗi", failure.message);
        return null;
      },
      (uploadedFile) {
        return uploadedFile.url;
      },
    );
  }
}
