import 'package:get/get.dart';
 import 'package:imageconvertor/features/choose_file_screen/choose_file_controller.dart';

class ChooseFileBinding  extends Bindings{
  @override
  void dependencies() {
    Get.put(ChooseFileController());
  }

}