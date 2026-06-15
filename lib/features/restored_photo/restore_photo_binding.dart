import 'package:get/get.dart';
import 'package:imageconvertor/features/restored_photo/restored_photo_controller.dart';

class RestorePhotoBinding  extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(RestoredPhotoController());
  }

}