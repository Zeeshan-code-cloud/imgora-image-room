import 'package:get/get.dart';
import 'package:imageconvertor/features/recen_activities/recent_activities_controller.dart';
import 'package:imageconvertor/features/splash_view/splash_controller.dart';

class RecentActivitiesBinding  extends Bindings{
  @override
  void dependencies() {
    Get.put(SplashController(), permanent: true);
     Get.put(RecentActivitiesController(), permanent: true);
  }

}