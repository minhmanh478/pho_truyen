// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:pho_truyen/core/network/api_client.dart';
import 'package:pho_truyen/features/auth/data/datasources/social_auth_remote_datasource.dart';
import 'package:pho_truyen/features/auth/data/repositories/social_auth_repository_impl.dart';
import '../../../../core/router/app_routes.dart';
import '../../domain/usecases/login_social_usecase.dart';
import '../../../dashboard/presentation/controllers/main_app_controller.dart';

class SocialAuthController extends GetxController {
  final LoginSocialUseCase loginSocialUseCase = LoginSocialUseCase(
    repository: SocialAuthRepositoryImpl(
      remoteDataSource: SocialAuthRemoteDataSourceImpl(dioClient: DioClient()),
    ),
  );
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  SocialAuthController();

  final RxBool isLoading = false.obs;

  Future<void> loginWithGoogle() async {
    try {
      isLoading.value = true;
      // 1. Trigger Google Sign In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        isLoading.value = false;
        return;
      }

      // 2. Get the authentication details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? accessToken = googleAuth.accessToken;

      if (accessToken == null) {
        Get.snackbar('Lỗi', 'Không thể lấy token từ Google');
        isLoading.value = false;
        return;
      }

      print('Google Access Token: $accessToken');

      // 3. Call API to login with social token
      final result = await loginSocialUseCase(
        provider: 'google',
        token: accessToken,
      );

      result.fold(
        (failure) {
          Get.snackbar('Lỗi đăng nhập', failure.message);
        },
        (authData) {
          Get.snackbar('Thành công', 'Đăng nhập thành công');
          if (Get.isRegistered<MainAppController>()) {
            Get.find<MainAppController>().checkLoginStatus();
          }
          Get.offAllNamed(AppRoutes.mainApp);
        },
      );
    } catch (e) {
      print('Google Sign In Error: $e');
      Get.snackbar('Lỗi', 'Đã xảy ra lỗi khi đăng nhập Google: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOutGoogle() async {
    await _googleSignIn.signOut();
  }

  Future<void> loginWithFacebook() async {
    try {
      isLoading.value = true;
      // 1. Trigger Facebook Sign In
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.cancelled) {
        isLoading.value = false;
        return;
      }

      if (result.status == LoginStatus.failed) {
        Get.snackbar('Lỗi', 'Đăng nhập Facebook thất bại: ${result.message}');
        isLoading.value = false;
        return;
      }

      // 2. Get the access token
      final AccessToken? accessToken = result.accessToken;

      if (accessToken == null) {
        Get.snackbar('Lỗi', 'Không thể lấy token từ Facebook');
        isLoading.value = false;
        return;
      }

      print('Facebook Access Token: ${accessToken.tokenString}');

      // 3. Call API to login with social token
      final authResult = await loginSocialUseCase(
        provider: 'facebook',
        token: accessToken.tokenString,
      );

      authResult.fold(
        (failure) {
          Get.snackbar('Lỗi đăng nhập', failure.message);
        },
        (authData) {
          Get.snackbar('Thành công', 'Đăng nhập thành công');
          if (Get.isRegistered<MainAppController>()) {
            Get.find<MainAppController>().checkLoginStatus();
          }
          Get.offAllNamed(AppRoutes.mainApp);
        },
      );
    } catch (e) {
      print('Facebook Sign In Error: $e');
      Get.snackbar('Lỗi', 'Đã xảy ra lỗi khi đăng nhập Facebook: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
