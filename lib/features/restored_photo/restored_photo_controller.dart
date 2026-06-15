import 'dart:io';

import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import '../../core/admob_services/rewarded_services.dart';
import '../../core/gemini_serivices/gemini_services.dart';
import '../../core/services/global_permission_sevices.dart';
import '../../core/storage_sevices/storage_model.dart';
import '../../core/storage_sevices/storage_services.dart';
import '../history_view/history_controller.dart';

class RestoredPhotoController  extends GetxController{
  final isLoading = false.obs;
  final isRestored = false.obs;
  Rx<File?> selectedImage = Rx<File?>(null);

  Future<void> downloadImage() async {
    final file = selectedImage.value;
    if (file == null) return;
    try {
      isLoading.value = true;
      bool? success = await GallerySaver.saveImage(file.path);
      if (success == true) {
        Get.snackbar(
          "Saved",
          "Image saved to gallery successfully",

        );
      } else {
        Get.snackbar(
          "Error",
          "Failed to save image to gallery",

        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to download image: $e",

      );
    } finally {
      isLoading.value = false;
    }
  }

  void clearSelectedImage() {
    selectedImage.value = null;
    isLoading.value = false;
  }

  Future<void> generatePhoto() async {
    if (selectedImage.value == null) {
      Get.snackbar('Error', 'No image selected', snackPosition: SnackPosition.BOTTOM);
      return;
    }


    AdManager().enhanceAd.showAd(
      onRewarded: () async {
        isLoading.value = true;
        try {
          final bytes = await selectedImage.value!.readAsBytes();
          final enhanced = await FalServices().restoredOldPhoto(bytes);
          if (enhanced != null) {
            final tempDir = await getTemporaryDirectory();
            final file = await File('${tempDir.path}/enhanced_${DateTime.now().millisecondsSinceEpoch}.jpg').create();
            await file.writeAsBytes(enhanced);
            selectedImage.value = file;
            // Save enhanced image to gallery
            isRestored.value = true;

            await StorageServices().addToStorage(
              StorageModel(
                imageName: path.basename(file.path),
                imageFormat: 'JPG',
                imagePath: file.path,
                operationType: "Restore Photo",
                date: DateTime.now().toIso8601String(),
              ),
            );
            try {
              Get.find<HistoryController>().loadActivities();
            } catch (e) {
              Get.snackbar("error occurred", e.toString());
            }
          } else {
            Get.snackbar('Error', 'restoration failed', snackPosition: SnackPosition.BOTTOM);
          }
        } catch (e) {
          isLoading.value = false;
          Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
        } finally {
          isRestored.value = false;
          isLoading.value =false;
        }
      },
    );
  }

  Future<void> pickImageFromGallery() async {
    final status = await PermissionService().requestGalleryPermission();
    if (status) {
      final file = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );
      if (file != null) {
        selectedImage.value = File(file.path);
      }
    }
  }

  Future<void> pickImageFromCamera() async {
    final status = await PermissionService().requestCameraPermission();
    if (status) {
      final file = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 100,
      );
      if (file != null) {
        selectedImage.value = File(file.path);
      }
    }
  }
}