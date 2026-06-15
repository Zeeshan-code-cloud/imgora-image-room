import 'package:get/get.dart';
import 'package:imageconvertor/features/choose_file_screen/choose_file_controller.dart';

class CropViewBinding  extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(ChooseFileController());
  }

}