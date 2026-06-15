import 'package:get/get.dart';
import 'package:imageconvertor/features/home_view/home_controller.dart';
import 'package:imageconvertor/features/recen_activities/recent_activities_controller.dart';

class HomeBinding  extends Bindings{
  @override
  void dependencies() {
 Get.put(HomeController());
   }

}