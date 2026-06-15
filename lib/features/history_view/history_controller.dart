import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/storage_sevices/storage_model.dart';
import '../../core/storage_sevices/storage_services.dart';

class HistoryController extends GetxController {
  final storage = StorageServices();

  RxList<StorageModel> activities = <StorageModel>[].obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadActivities();
  }

  Future<void> loadActivities() async {
    isLoading.value = true;
    try {
      final data = await storage.getFromStorage();
      activities.assignAll(data.reversed.toList());
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> deleteItem(String imagePath) async {
    await storage.deleteFiles(imagePath);
    await loadActivities();
  }
}