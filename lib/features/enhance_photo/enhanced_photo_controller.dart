import 'dart:io';
import 'package:path_provider/path_provider.dart';

 import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/gemini_serivices/gemini_services.dart';
import '../../core/services/global_permission_sevices.dart';
import 'package:path/path.dart' as path;
import 'package:imageconvertor/core/storage_sevices/storage_model.dart';
import 'package:imageconvertor/core/storage_sevices/storage_services.dart';
import 'package:imageconvertor/features/history_view/history_controller.dart';
import 'package:imageconvertor/core/admob_services/rewarded_services.dart';

class EnhancedPhotoController  extends GetxController{
  final isLoading = false.obs;
  final isEnhanced = false.obs;
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
    isEnhanced.value = false;
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
          final enhanced = await FalServices().enhanceImage(bytes);
          if (enhanced != null) {
            final tempDir = await getTemporaryDirectory();
            final file = await File('${tempDir.path}/enhanced_${DateTime.now().millisecondsSinceEpoch}.jpg').create();
            await file.writeAsBytes(enhanced);
            selectedImage.value = file;
            // Save enhanced image to gallery
            isEnhanced.value = true;

            await StorageServices().addToStorage(
              StorageModel(
                imageName: path.basename(file.path),
                imageFormat: 'JPG',
                imagePath: file.path,
                operationType: "Enhance Photo",
                date: DateTime.now().toIso8601String(),
              ),
            );
            try {
              Get.find<HistoryController>().loadActivities();
            } catch (e) {
              Get.snackbar("error", e.toString());
            }
          } else {
            Get.snackbar('Error', 'Enhancement failed', snackPosition: SnackPosition.BOTTOM);
          }
        } catch (e) {
          isLoading.value = false;
          Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
        } finally {
          isEnhanced.value = true;
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