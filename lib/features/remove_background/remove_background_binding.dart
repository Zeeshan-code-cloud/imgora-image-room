import 'package:get/get.dart';
import 'package:imageconvertor/features/remove_background/remove_background_controller.dart';

class RemoveBackgroundBinding  extends Bindings{
  @override
  void dependencies() {
   Get.put(RemoveBackgroundController());
  }

}