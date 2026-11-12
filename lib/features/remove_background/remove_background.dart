import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
 import 'package:imageconvertor/features/remove_background/remove_background_controller.dart';
 import 'package:sizer/sizer.dart';
import '../../utils/app_colors.dart';
import '../../widgets/app_button_widget.dart';
import '../../widgets/app_text.dart';

class RemoveBackground extends GetView<RemoveBackgroundController> {
  const RemoveBackground({super.key});

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
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 22),
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
                      "Remove Background",
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ],
                ),
                SizedBox(height: 12),
                AppText(
                  "Upload an image and remove its background instantly using AI.",
                  type: AppTextType.caption,
                  color: AppColors.textSecondary,
                ),

                SizedBox(height: 3.h),

                Expanded(child: _buildUploadArea()),

                SizedBox(height: 2.h),

                /// CTA
                Obx(
                  () => AppButtonWidget(
                    text: controller.isLoading.value
                        ? "Processing..."
                        : (controller.isBackgroundRemoved.value
                            ? "Download Image"
                            : "Remove Background"),
                    isGradient: true,
                    width: double.infinity,
                    height: 6.5.h,
                    radius: 30,
                    onPressed: (controller.isLoading.value ||
                            controller.selectedImage.value == null)
                        ? null
                        : (controller.isBackgroundRemoved.value
                            ? controller.downloadImage
                            : controller.removeBackground),
                    prefixIcon: controller.isLoading.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Icon(
                            controller.isBackgroundRemoved.value
                                ? Icons.download
                                : Icons.auto_awesome,
                            color: Colors.white,
                          ),
                  ),
                ),

                SizedBox(height: 2.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// =============================
  /// Upload Area
  /// =============================
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
        if (controller.isLoading.value)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: .5),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        if (!controller.isLoading.value)
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

        SizedBox(height: 4.h),

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

        SizedBox(height: 1.h),
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
}
