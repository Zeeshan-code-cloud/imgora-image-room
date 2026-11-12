import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imageconvertor/core/gemini_serivices/gemini_services.dart';
import 'package:imageconvertor/core/services/global_permission_sevices.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:imageconvertor/core/services/trails_services.dart';
import 'package:path/path.dart' as path;
import 'package:imageconvertor/core/storage_sevices/storage_model.dart';
import 'package:imageconvertor/core/storage_sevices/storage_services.dart';
import 'package:imageconvertor/features/history_view/history_controller.dart';
import 'package:imageconvertor/core/admob_services/rewarded_services.dart';
import 'package:imageconvertor/core/services/rating_service.dart';

import '../../core/routes_config/app_routes.dart';

class TextToImageController extends GetxController {
  final isLoading = false.obs;
  RxBool isGenerationComplete = false.obs;
  RxBool disableButtons = false.obs;
  Rx<File?> selectedImage = Rx<File?>(null);

  RxString selectedRatio = "1:1".obs;
  final promptController = TextEditingController();
  final Rx<Uint8List?> generatedImage = Rx<Uint8List?>(null);
  final trailservices = Get.find<TrailsServices>();

  Future<void> pickImageFromGallery() async {
    final packedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );

      selectedImage.value = File(packedFile!.path);

  }

  void clearSelectedImage() {
    selectedImage.value = null;
    isLoading.value = false;
    disableButtons.value = false;
  }

  Future<void> generateImage() async {
    final prompt = promptController.text.trim();
    if (prompt.isEmpty) {
      Get.snackbar(
        backgroundColor: Colors.white,
        'Error',
        'Prompt is required',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    final isprem = Get.find<TrailsServices>().plan.value;
    if (isprem == "premium" && trailservices.remainingTrials.value > 0) {
      await processedGeneration(prompt);
    } else {
     Get.toNamed(AppRoutes.SubscriptionScreen);

    }
  }

  Future<void> processedGeneration(String prompt) async {
    isLoading.value = true;
    disableButtons.value = true;
    try {
      Uint8List? imageBytes;
      if (selectedImage.value != null) {
        imageBytes = await selectedImage.value!.readAsBytes();
      }

      final result = await FalServices().textToImage(
        prompt,
        imageBytes: imageBytes,
        ratio: selectedRatio.value,
      );
      if (result != null) {
        generatedImage.value = result;
        isGenerationComplete.value = true;
       await  trailservices.decrementTrial();
        RatingService.showRatingDialog();
      } else {
        Get.snackbar(
          'Error',
          'Image generation failed',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      disableButtons.value = false;
      isLoading.value = false;
    }
  }

  Future<void> saveToGallery() async {
    if (generatedImage.value == null) return;

    try {
      final tempDir = Directory.systemTemp;
      final file = File('${tempDir.path}/generated_image_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await file.writeAsBytes(generatedImage.value!);

      await StorageServices().addToStorage(
        StorageModel(
          imageName: path.basename(file.path),
          imageFormat: 'JPG',
          imagePath: file.path,
          operationType: "Text to Image",
          date: DateTime.now().toIso8601String(),
        ),
      );
      try {
        Get.find<HistoryController>().loadActivities();
      } catch (e) {
      }

      final success = await GallerySaver.saveImage(file.path);
      if (success == true) {
        Get.snackbar('Success', 'Image saved to gallery', snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar('Error', 'Failed to save image', snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'Error saving image: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }
}
