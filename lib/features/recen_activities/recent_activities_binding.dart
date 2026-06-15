import 'package:get/get.dart';
import 'package:imageconvertor/features/recen_activities/recent_activities_controller.dart';

class RecentActivitiesBinding  extends Bindings{
  @override
  void dependencies() {
     Get.put(RecentActivitiesController(), permanent: true);
  }

}