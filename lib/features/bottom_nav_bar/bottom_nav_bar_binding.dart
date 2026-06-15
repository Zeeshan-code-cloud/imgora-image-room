import 'package:get/get.dart';
import 'package:imageconvertor/features/bottom_nav_bar/bottom_nav_controller.dart';
import 'package:imageconvertor/features/history_view/history_controller.dart';
import 'package:imageconvertor/features/home_view/home_controller.dart';
import 'package:imageconvertor/features/setting_view/setting_controller.dart';

class BottomNavBarBinding  extends Bindings {
  @override
  void dependencies() {

    Get.put(BottomNavController());
    Get.put(HomeController());
    Get.put(HistoryController());
    Get.put(SettingController());
  }

}