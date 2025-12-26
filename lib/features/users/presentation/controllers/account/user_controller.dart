import 'package:get/get.dart';
import '../../../domain/entities/user_profile_entity.dart';
import '../../../domain/usecases/change_password_usecase.dart';
import '../../../domain/usecases/get_user_profile_usecase.dart';
import '../../../domain/usecases/update_profile_usecase.dart';

class UserController extends GetxController {
  final GetUserProfileUseCase getUserProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final ChangePasswordUseCase changePasswordUseCase;

  final Rx<UserProfileEntity?> userProfile = Rx<UserProfileEntity?>(null);

  UserController({
    required this.getUserProfileUseCase,
    required this.updateProfileUseCase,
    required this.changePasswordUseCase,
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
}
