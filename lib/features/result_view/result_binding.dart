import 'package:get/get.dart';
import 'package:imageconvertor/features/result_view/result_controller.dart';

class ResultBinding  extends Bindings{
  @override
  void dependencies() {
     Get.put(ConvertedFileController());
  }
}