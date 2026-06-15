import 'package:get/get.dart';
import 'package:imageconvertor/features/enhance_photo/enhanced_photo_controller.dart';

class EnhancedPhotoBinding  extends Bindings{
  @override
  void dependencies() {
   Get.put(EnhancedPhotoController());
  }

}