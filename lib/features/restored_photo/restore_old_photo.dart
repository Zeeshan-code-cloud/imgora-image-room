import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imageconvertor/features/restored_photo/restored_photo_controller.dart';
import 'package:sizer/sizer.dart';
import '../../utils/app_colors.dart';
import '../../widgets/app_text.dart';


class RestoreOldPhoto extends GetView<RestoredPhotoController> {
  const RestoreOldPhoto({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff4B3FAF), Color(0xff0B0F1A), Color(0xff0B0F1A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 12),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      SizedBox(width: 12.w),
                      AppText(
                        "Restore Old Images",
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  AppText(
                    "Upload and Restored any image in seconds",
                    color: Colors.white70,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                  SizedBox(height: 2.h),
                  Expanded(child: _buildUploadArea()),
                  SizedBox(height: 2.h),
                  _buildEnhanceButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// ================= CONTENT =================
  Widget _buildUploadArea() {
    return Obx(
          () => Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xff0B141D),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: .2),
            width: 1.5,
          ),
        ),
        child: controller.selectedImage.value == null
            ? _buildEmptyState()
            : _buildSelectedImage(controller.selectedImage.value!),
      ),
    );
  }

  Widget _buildSelectedImage(File file) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Image.file(
            file,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.contain,
          ),
        ),
        Positioned(
          top: 12,
          right: 12,
          child: GestureDetector(
            onTap: () {
              controller.clearSelectedImage();
            },
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .1),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: const Icon(Icons.close, size: 18, color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.image_outlined,
          size: 60,
          color: AppColors.primary.withValues(alpha: .6),
        ),

        SizedBox(height: 2.h),

        AppText(
          "Select an Image",
          type: AppTextType.heading2,
          color: AppColors.white,
        ),

        SizedBox(height: 0.5.h),

        AppText(
          "Choose from gallery or take a new photo.",
          type: AppTextType.caption,
          color: AppColors.white,
        ),

        SizedBox(height: 3.h),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _actionButton(
              icon: Icons.image,
              label: "Gallery",
              onTap: controller.pickImageFromGallery,
              isSvg: false,
            ),
            SizedBox(width: 6.w),
            _actionButton(
              icon: Icons.camera_alt_rounded,
              label: "Camera",
              onTap: controller.pickImageFromCamera,
              isSvg: false,
            ),
          ],
        ),

        SizedBox(height: 8.h),

        /// Tip
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Row(
            children: [
              Icon(Icons.lightbulb, color: AppColors.primary, size: 18),
              SizedBox(width: 2.w),
              Expanded(
                child: AppText(
                  "Use clear lighting and good contrast for best results.",
                  type: AppTextType.caption,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isSvg,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              gradient: AppColors().gradient,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 4.h, color: Colors.white),
          ),
          SizedBox(height: 1.h),
          AppText(label, type: AppTextType.caption, color: AppColors.white),
        ],
      ),
    );
  }

  Widget _buildEnhanceButton() {
    return Obx(
          () => GestureDetector(
        onTap: controller.isLoading.value ? null : controller.isRestored.value ? controller.downloadImage :  controller.generatePhoto,
        child: Container(
          height: 6.h,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primary.withOpacity(0.7)],
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: controller.isLoading.value
                ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Processing",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
              ],
            )
                : controller.isRestored.value ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.download, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  "save Image",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ):  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.auto_awesome, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  "Restore Image",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

  }
}
