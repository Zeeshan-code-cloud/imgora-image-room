import 'package:get/get.dart';
import 'package:imageconvertor/core/routes_config/app_routes.dart';
import 'package:imageconvertor/features/bottom_nav_bar/bottom_nav_bar_binding.dart';
import 'package:imageconvertor/features/choose_file_screen/choose_file_binding.dart';
import 'package:imageconvertor/features/choose_file_screen/choose_file_view.dart';
import 'package:imageconvertor/features/crop_view/crop_view_binding.dart';
import 'package:imageconvertor/features/enhance_photo/enhanced_photo_binding.dart';
import 'package:imageconvertor/features/history_view/history_binding.dart';
import 'package:imageconvertor/features/history_view/history_view.dart';
import 'package:imageconvertor/features/home_view/home_binding.dart';
import 'package:imageconvertor/features/home_view/home_view.dart';
import 'package:imageconvertor/features/recen_activities/recent_activities_binding.dart';
import 'package:imageconvertor/features/remove_background/remove_background_binding.dart';
import 'package:imageconvertor/features/restored_photo/restore_old_photo.dart';
import 'package:imageconvertor/features/restored_photo/restore_photo_binding.dart';
import 'package:imageconvertor/features/result_view/result_binding.dart';
import 'package:imageconvertor/features/setting_view/setting_binding.dart';
import 'package:imageconvertor/features/setting_view/setting_view.dart';
import 'package:imageconvertor/features/splash_view/splash_binding.dart';
import 'package:imageconvertor/features/splash_view/splash_view.dart';
import 'package:imageconvertor/features/text_to_image/text_to_image_binding.dart';

import '../../features/bottom_nav_bar/bottom_nav_bar.dart';
import '../../features/crop_view/crop_view.dart';
import '../../features/enhance_photo/enhanced_photo.dart';
import '../../features/recen_activities/recent_activities.dart';
import '../../features/remove_background/remove_background.dart';
import '../../features/result_view/result_view.dart';
import '../../features/text_to_image/text_to_image.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.splashView,
      page: () => SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.homeView,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.chooseFileView,
      page: () => ChooseFileView(),
      binding: ChooseFileBinding(),
    ),
    GetPage(
      name: AppRoutes.cropPreviewView,
      page: () => CropPreviewView(),
      binding: CropViewBinding(),
    ),
    GetPage(
      name: AppRoutes.convertedFileView,
      page: () => ConvertedFileView(),
      binding: ResultBinding(),
    ),
    GetPage(
      name: AppRoutes.recentActivitiesView,
      page: () => RecentActivitiesView(),
      binding: RecentActivitiesBinding(),
    ),
    GetPage(
      name: AppRoutes.settingView,
      page: () => SettingView(),
      binding: SettingBinding(),
    ),
    GetPage(
      name: AppRoutes.BottomNavBar,
      page: () => BottomNavBar(),
      bindings: [
        BottomNavBarBinding(),
      ],
    ),
    GetPage(
      name: AppRoutes.HistoryView,
      page: () => HistoryView(),
      binding : HistoryBinding()
    ),
    GetPage(
      name: AppRoutes.RemoveBackground,
      page: () => RemoveBackground(),
      binding : RemoveBackgroundBinding()
    ),
    GetPage(
      name: AppRoutes.EnhancedPhoto,
      page: () => EnhancedPhoto(),
      binding : EnhancedPhotoBinding()
    ),
    GetPage(
      name: AppRoutes.TextToImage,
      page: () => TextToImage(),
      binding : TextToImageBinding()
    ),  GetPage(
      name: AppRoutes.RestoreOldPhoto,
      page: () => RestoreOldPhoto(),
      binding : RestorePhotoBinding()
    ),
  ];
}
