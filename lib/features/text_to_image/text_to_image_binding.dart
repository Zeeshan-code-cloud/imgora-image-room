import 'package:get/get.dart';
import 'package:imageconvertor/features/text_to_image/text_to_image_controller.dart';

class TextToImageBinding  extends Bindings{
  @override
  void dependencies() {
Get.put(TextToImageController());
  }

}