import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:imageconvertor/core/services/global_permission_sevices.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:imageconvertor/core/gemini_serivices/gemini_services.dart';
import 'package:imageconvertor/core/admob_services/rewarded_services.dart';
import 'package:imageconvertor/core/storage_sevices/storage_model.dart';
import 'package:imageconvertor/core/storage_sevices/storage_services.dart';
import 'package:imageconvertor/features/history_view/history_controller.dart';


class RemoveBackgroundController extends GetxController {
  final isLoading = false.obs;
  final isBackgroundRemoved = false.obs;
  Rx<File?> selectedImage = Rx<File?>(null);




  Future<void> removeBackground() async {
    if (selectedImage.value == null) {
      Get.snackbar("No image selected", "please select first");
      return;
    }

    AdManager().bgRemoveAd.showAd(
      onRewarded: () async {
        isLoading.value = true;
        try {
          final bytes = await selectedImage.value!.readAsBytes();
          final processedBytes = await FalServices().removeBackground(bytes);
          if (processedBytes != null) {
            final tempDir = await getTemporaryDirectory();
            final file = await File('${tempDir.path}/bg_removed_${DateTime.now().millisecondsSinceEpoch}.png').create();
            await file.writeAsBytes(processedBytes);
            selectedImage.value = file;
            isBackgroundRemoved.value = true;

            await StorageServices().addToStorage(
              StorageModel(
                imageName: path.basename(file.path),
                imageFormat: 'PNG',
                imagePath: file.path,
                operationType: "Remove Background",
                date: DateTime.now().toIso8601String(),
              ),
            );
            try {
              Get.find<HistoryController>().loadActivities();
            } catch (e) {
              Get.snackbar("error", e.toString());
            }
          } else {
            Get.snackbar('Error', 'Background removal failed', snackPosition: SnackPosition.BOTTOM);
          }
        } catch (e) {
          isLoading.value = false;
          Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
        } finally {
          isLoading.value = false;
        }
      },
    );

  }

  void clearSelectedImage() {
    selectedImage.value = null;
    isBackgroundRemoved.value = false;
  }




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
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
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
        isBackgroundRemoved.value = false;
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
        isBackgroundRemoved.value = false;
      }
    }
  }
}
