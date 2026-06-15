import 'package:get/get.dart';
import 'package:imageconvertor/features/setting_view/setting_controller.dart';

class SettingBinding  extends Bindings{
  @override
  void dependencies() {
     Get.put(SettingController());
  }

}