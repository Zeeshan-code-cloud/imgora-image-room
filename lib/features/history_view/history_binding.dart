import 'package:get/get.dart';
import 'package:imageconvertor/features/history_view/history_controller.dart';

class HistoryBinding  extends Bindings{
  @override
  void dependencies() {
    Get.put(HistoryController());
  }

}