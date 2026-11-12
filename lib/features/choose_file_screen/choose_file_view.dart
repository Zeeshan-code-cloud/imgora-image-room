import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imageconvertor/features/choose_file_screen/choose_file_controller.dart';
import 'package:sizer/sizer.dart';

import '../../core/admob_services/ad_helper.dart';
import '../../widgets/banner_widget.dart';

class ChooseFileView extends GetView<ChooseFileController> {
  const ChooseFileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Color(0xff4B3FAF),
          Color(0xff0B0F1A),
          Color(0xff0B0F1A),
        ] ,begin: Alignment.topLeft,
        end: Alignment.bottomRight,)
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),

                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 24,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "Choose File",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                Obx(
                  ()=>   Text(
                    controller.selectedFormat.value,
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "Choose where to import your file to start the\nconversion process.",
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 26),

                Wrap(
                  spacing: 32,
                  runSpacing: 22,
                  children:  [
                    FileSourceCard(
                      icon: Icons.image_rounded,
                      title: "Gallery",
                      subtitle: "Select from Gallery",
                      onTap: controller.pickFromGallery,
                    ),
                    FileSourceCard(
                      icon: Icons.camera_alt_rounded,
                      title: "Camera",
                      subtitle: "Captured by camera",
                      onTap: controller.pickFromCamera,
                    ),

                  ],
                ),
                 SizedBox(height: 12.h),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FileSourceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const FileSourceCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(11),
      child: Container(
        width: 136,
        height: 102,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(
            color: const Color(0xffD8D4EA),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 34,
              color: const Color(0xff5944F5),
            ),

            const SizedBox(height: 8),

            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: Color(0xff171827),
              ),
            ),

            const SizedBox(height: 6),

            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Color(0xff7A7D8C),
              ),
            ),
          ],
        ),
      ),
    );
  }
}