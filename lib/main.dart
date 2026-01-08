import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:pho_truyen/core/constants/app_paths.dart';
import 'package:pho_truyen/core/router/app_page.dart';
import 'package:pho_truyen/core/constants/app_color.dart';
import 'package:pho_truyen/features/dashboard/presentation/controllers/main_app_controller.dart';
import 'package:pho_truyen/features/dashboard/presentation/bindings/main_app_binding.dart';
import 'package:pho_truyen/features/dashboard/presentation/pages/main_app_page.dart';
import 'package:pho_truyen/firebase_options.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'package:pho_truyen/core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } catch (e) {
    if (e.toString().contains('duplicate-app')) {
      debugPrint('Firebase already initialized: $e');
    } else {
      rethrow;
    }
  }
  NotificationService().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Phố Truyện',
      initialBinding: MainAppBinding(),
      getPages: AppPages.routes,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.transparent,
        ),
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColor.backgroundDark1,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          selectedItemColor: AppColor.primaryColor,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          showSelectedLabels: true,
          showUnselectedLabels: true,
        ),
        colorScheme: ColorScheme.fromSwatch(brightness: Brightness.dark)
            .copyWith(
              primary: AppColor.primaryColor,
              secondary: AppColor.primaryColor,
              surface: AppColor.backgroundDark1,
            ),
        useMaterial3: true,
      ),
      builder: (context, child) {
        final shadcnWithTheme = ShadTheme(
          data: ShadThemeData(
            brightness: Brightness.dark,
            colorScheme: const ShadZincColorScheme.dark(),
          ),
          child: ShadToaster(child: child!),
        );

        return FTheme(data: FThemes.zinc.dark, child: shadcnWithTheme);
      },
      home: Obx(() {
        final controller = Get.find<MainAppController>();
        if (controller.isInitialized.value) {
          return const MainAppPage();
        }
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(AppPaths.imgLogo, width: 90, height: 90),
                const SizedBox(height: 20),
                const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
