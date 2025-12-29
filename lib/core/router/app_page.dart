import 'package:get/get.dart';
import 'package:pho_truyen/features/dashboard/presentation/bindings/main_app_binding.dart';
import 'package:pho_truyen/features/dashboard/presentation/pages/main_app_page.dart';
import 'package:pho_truyen/features/users/presentation/controllers/account/user_binding.dart';
import 'package:pho_truyen/features/users/presentation/pages/subfolder_page/ruby/transaction_history.dart';
import 'package:pho_truyen/features/users/presentation/pages/subfolder_page/ruby/vip_registration_page.dart';
import 'package:pho_truyen/features/users/presentation/pages/user_profile_page.dart';
import 'package:pho_truyen/features/author/presentation/controllers/author_detail_binding.dart';
import 'package:pho_truyen/features/author/presentation/pages/author_detail_page.dart';
import 'package:pho_truyen/features/chapter/presentation/controllers/chapter_binding.dart';
import 'package:pho_truyen/features/chapter/presentation/pages/chapter_page.dart';
import '../../features/search/presentation/bindings/search_binding.dart';
import '../../features/search/presentation/pages/search_page.dart';
import '../../features/story/presentation/pages/comic/comic_detail_page.dart';
import 'package:pho_truyen/features/auth/presentation/controllers/auth_binding.dart';
import 'package:pho_truyen/features/auth/presentation/pages/account/login_page.dart';
import 'package:pho_truyen/features/auth/presentation/pages/account/register/register_page.dart';
import 'package:pho_truyen/features/auth/presentation/pages/account/forgot_password/forgot_password_page.dart';
import 'package:pho_truyen/features/users/presentation/pages/subfolder_page/account/info_user_page.dart';
import 'package:pho_truyen/features/users/presentation/pages/subfolder_page/account/info_author_page.dart';
import 'package:pho_truyen/features/users/presentation/pages/subfolder_page/ruby/loaded_ruby_page.dart';
import 'package:pho_truyen/features/home/presentation/pages/notification_page.dart';
import 'package:pho_truyen/features/story/presentation/pages/library/fillter_hastags_page.dart';
import 'package:pho_truyen/features/comment/presentation/pages/comment_list_page.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = <GetPage>[
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.mainApp,
      page: () => const MainAppPage(),
      binding: MainAppBinding(),
    ),
    GetPage(
      name: AppRoutes.search,
      page: () => const SearchPage(),
      binding: SearchBinding(),
    ),
    GetPage(
      name: AppRoutes.user,
      page: () => const UserProfilePage(),
      binding: UserBinding(),
    ),
    GetPage(name: AppRoutes.comicDetail, page: () => const ComicDetailPage()),
    GetPage(
      name: AppRoutes.authorDetail,
      page: () => const AuthorDetailPage(),
      binding: AuthorDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.chapter,
      page: () => const ChapterPage(),
      binding: ChapterBinding(),
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordPage(),
      binding: AuthBinding(),
    ),
    GetPage(name: AppRoutes.infoUser, page: () => const InfoUserPage()),
    GetPage(name: AppRoutes.infoAuthor, page: () => const InfoAuthorPage()),
    GetPage(
      name: AppRoutes.vipRegistration,
      page: () => const VipRegistrationPage(),
    ),
    GetPage(name: AppRoutes.loadedRuby, page: () => const LoadedRubyPage()),
    GetPage(
      name: AppRoutes.transactionHistory,
      page: () => const TransactionHistoryPage(),
    ),
    GetPage(name: AppRoutes.notification, page: () => const NotificationPage()),
    GetPage(name: AppRoutes.filterHashtags, page: () => FillterHastagsPage()),
    GetPage(name: AppRoutes.commentList, page: () => const CommentListPage()),
  ];
}
