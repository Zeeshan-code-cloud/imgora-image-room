import 'dart:io';

import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path/path.dart' as path;
class ConvertedFileController extends GetxController {
  Rxn<File> convertedImage = Rxn<File>();

  RxString originalFormat = "Jpg".obs;
  RxString imageFormat = "Jpg".obs;
  RxString originalSize = "0.28 MB".obs;
  RxString convertedSize = "0.75 MB".obs;
  RxString dateTime = "11:03:42 AM".obs;

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null) {
      convertedImage.value = Get.arguments["image"];
      originalFormat.value = Get.arguments["originalFormat"] ?? "Jpg";
      imageFormat.value = Get.arguments["format"] ?? "Jpg";
      originalSize.value = Get.arguments["originalSize"] ?? "0.28 MB";
      convertedSize.value = Get.arguments["convertedSize"] ?? "0.75 MB";
      dateTime.value = Get.arguments["dateTime"] ?? "11:03:42 AM";
    }
  }

  Future<void> saveToPhoto() async {
    final file = convertedImage.value;
    if (file == null) return;

    final format = imageFormat.value.toUpperCase();

    if (format == 'PDF' || format == 'SVG') {
      String? selectedDirectory = await FilePicker.getDirectoryPath();
      if (selectedDirectory != null) {
        final fileName = path.basename(file.path);
        final newPath = path.join(selectedDirectory, fileName);
        await file.copy(newPath);
        Get.snackbar(
          "Saved",
          "File saved to $newPath successfully",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else {
      bool? success = await GallerySaver.saveImage(file.path);
      if (success == true) {
        Get.snackbar(
          "Saved",
          "Image saved to gallery successfully",
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          "Error",
          "Failed to save image to gallery",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  Future<void> shareFile() async {
    final file = convertedImage.value;
    if (file != null) {
      await Share.shareXFiles([XFile(file.path)], text: 'Check out my converted file!');
    }
  }
}