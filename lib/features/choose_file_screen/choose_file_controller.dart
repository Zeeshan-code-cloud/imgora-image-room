import 'dart:io';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imageconvertor/core/routes_config/app_routes.dart';
import 'package:imageconvertor/core/storage_sevices/storage_model.dart';
import 'package:imageconvertor/core/storage_sevices/storage_services.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:imageconvertor/features/recen_activities/recent_activities_controller.dart';
import 'package:imageconvertor/features/history_view/history_controller.dart';
import 'package:imageconvertor/core/admob_services/rewarded_services.dart';

class ChooseFileController extends GetxController {
  RxString selectedFormat = "Popular Conversion".obs;

  final ImagePicker _picker = ImagePicker();

  Rxn<File> selectedImage = Rxn<File>();
  Rxn<File> croppedImage = Rxn<File>();
  RxString originalFormat = "".obs;
  RxString imageName = "".obs;
  RxBool isConverting = false.obs;

  String JPGtoHeich = "JPG to HEIC";
  String JPGtoPNG = "JPG to PNG";
  String JPGtoPDF = "JPG to PDF";
  String PDFtoJPG = "PDF to JPG";
  String SVGtoPNG = "SVG TO PNG";
  String JPGtOWEBP = "JPG TO WEBP";

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null && Get.arguments["title"] != null) {
      selectedFormat.value = Get.arguments["title"];
    }
  }

  Future<bool> requestGalleryPermission() async {
    PermissionStatus status = await Permission.photos.request();

    if (status.isGranted || status.isLimited) {
      return true;
    }

    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }

    return false;
  }

  Future<bool> requestCameraPermission() async {
    PermissionStatus status = await Permission.camera.request();

    if (status.isGranted) {
      return true;
    }

    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }

    return false;
  }

  Future<void> pickFromGallery() async {
    final hasPermission = await requestGalleryPermission();

    if (!hasPermission) {
      Get.snackbar("Permission Denied", "Gallery permission is required");
      return;
    }

    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );

    if (pickedFile == null) return;
    imageName.value = pickedFile.path.split("/").last;
    await _handlePickedImage(File(pickedFile.path));
  }

  Future<void> pickFromCamera() async {
    final hasPermission = await requestCameraPermission();

    if (!hasPermission) {
      Get.snackbar("Permission Denied", "Camera permission is required");
      return;
    }

    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 100,
    );

    if (pickedFile == null) return;
    imageName.value = pickedFile.path.split("/").last;
    await _handlePickedImage(File(pickedFile.path));
  }

  Future<void> pickFromFiles() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'webp', 'heic', 'svg', 'pdf'],
    );

    if (result == null || result.files.single.path == null) return;

    final file = File(result.files.single.path!);

    originalFormat.value = path.extension(file.path).replaceAll('.', '');

    if (isImageFile(file.path)) {
      imageName.value = file.path.split("/").last;
      await _handlePickedImage(file);
    } else {
      selectedImage.value = file;
    }
  }

  Future<void> _handlePickedImage(File file) async {
    selectedImage.value = file;
    originalFormat.value = path.extension(file.path).replaceAll('.', '');

    final cropped = await ImageCropper().cropImage(
      sourcePath: file.path,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: const Color(0xff5944F5),
          toolbarWidgetColor: const Color(0xffffffff),
          activeControlsWidgetColor: const Color(0xff5944F5),
          lockAspectRatio: false,
        ),
        IOSUiSettings(title: 'Crop Image'),
      ],
    );

    if (cropped != null) {
      croppedImage.value = File(cropped.path);
      Get.toNamed(AppRoutes.cropPreviewView);
    } else {
      croppedImage.value = file;
    }
  }

  bool isImageFile(String filePath) {
    final ext = path.extension(filePath).toLowerCase();

    return ['.jpg', '.jpeg', '.png', '.webp', '.heic'].contains(ext);
  }

  Future<void> reCropImage() async {
    final file = selectedImage.value;

    if (file == null) {
      Get.snackbar("No Image", "Please select an image first");
      return;
    }

    final cropped = await ImageCropper().cropImage(
      sourcePath: file.path,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: const Color(0xff5944F5),
          toolbarWidgetColor: const Color(0xffffffff),
          activeControlsWidgetColor: const Color(0xff5944F5),
          lockAspectRatio: false,
        ),
        IOSUiSettings(title: 'Crop Image'),
      ],
    );

    if (cropped != null) {
      croppedImage.value = File(cropped.path);
      Get.toNamed(AppRoutes.cropPreviewView);
    }
  }

  Future<void> convertImage() async {
    final file = croppedImage.value ?? selectedImage.value;

    if (file == null) {
      Get.snackbar("No Image", "Please select an image first");
      return;
    }

    AdManager().editAd.showAd(
      onRewarded: () async {
        isConverting.value = true;

        try {
          final originalSizeBytes = await file.length();
          final originalSizeMB = (originalSizeBytes / (1024 * 1024))
              .toStringAsFixed(2);

          String newFormatStr = "JPG";
          if (selectedFormat.value.toLowerCase().contains(" to ")) {
            newFormatStr = selectedFormat.value
                .toLowerCase()
                .split(" to ")
                .last
                .toUpperCase()
                .trim();
          } else {
            newFormatStr = "JPG";
          }

          File newFile = file;
          int newSizeBytes = originalSizeBytes;

          final dir = path.dirname(file.path);
          final basename = path.basenameWithoutExtension(file.path);
          final newPath = path.join(
            dir,
            '${basename}_converted.${newFormatStr.toLowerCase()}',
          );

          if (['JPG', 'JPEG', 'PNG', 'WEBP', 'HEIC'].contains(newFormatStr)) {
            CompressFormat targetFormat = CompressFormat.jpeg;
            switch (newFormatStr) {
              case 'PNG':
                targetFormat = CompressFormat.png;
                break;
              case 'WEBP':
                targetFormat = CompressFormat.webp;
                break;
              case 'HEIC':
                targetFormat = CompressFormat.heic;
                break;
            }

            final compressedFile = await FlutterImageCompress.compressAndGetFile(
              file.absolute.path,
              newPath,
              format: targetFormat,
              quality: 100,
            );

            if (compressedFile != null) {
              newFile = File(compressedFile.path);
              newSizeBytes = await newFile.length();
            }
          } else if (newFormatStr == 'PDF') {
            final PdfDocument document = PdfDocument();
            final PdfPage page = document.pages.add();
            final PdfBitmap image = PdfBitmap(await file.readAsBytes());
            page.graphics.drawImage(
              image,
              Rect.fromLTWH(
                0,
                0,
                page.getClientSize().width,
                page.getClientSize().height,
              ),
            );
            final List<int> bytes = document.saveSync();
            newFile = File(newPath)..writeAsBytesSync(bytes);
            document.dispose();
            newSizeBytes = bytes.length;
          }

          final newSizeMB = (newSizeBytes / (1024 * 1024)).toStringAsFixed(2);

          final now = DateTime.now();
          final hour = now.hour;
          final minute = now.minute.toString().padLeft(2, '0');
          final period = hour >= 12 ? 'PM' : 'AM';
          final hour12 = hour % 12 == 0 ? 12 : hour % 12;
          final timeStr = "$hour12:$minute $period";

          await StorageServices().addToStorage(
            StorageModel(
              imageName: imageName.toString(),
              imageFormat: newFormatStr,
              imagePath: newFile.path,
              operationType: "Convert Image",
              date: DateTime.now().toIso8601String(),
            ),
          );
          
          try {
            Get.find<RecentActivitiesController>().loadActivities();
          } catch (e) {
            // In case the controller is not registered yet
          }
          try {
            Get.find<HistoryController>().loadActivities();
          } catch (e) {
          }

          Get.toNamed(
            AppRoutes.convertedFileView,
            arguments: {
              "image": newFile,
              "format": newFormatStr,
              "originalFormat": originalFormat.value.toUpperCase(),
              "originalSize": "$originalSizeMB MB",
              "convertedSize": "$newSizeMB MB",
              "dateTime": timeStr,
            },
          );

          Get.snackbar(
            "Convert Completed",
            "Your image has been converted to $newFormatStr",
          );
        } catch (e) {
          print(e);
          Get.snackbar("Conversion Error", "Failed to convert image: $e");
        } finally {
          isConverting.value = false;
        }
      },
    );
  }
}
