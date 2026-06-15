import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imageconvertor/features/result_view/result_controller.dart';

class ConvertedFileView extends GetView<ConvertedFileController> {
  const ConvertedFileView({super.key});

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
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(
                color: Colors.transparent,
                child: Column(
                  children: [
                    const SizedBox(height: 24),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "File Converted",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Your document is ready for download.",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.white54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Container(
                      height: 1,
                      color: const Color(0xffE9E9E9),
                    ),

                    const SizedBox(height: 26),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Obx(() {
                        final image = controller.convertedImage.value;

                        return ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            width: double.infinity,
                            height: 276,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.35),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.55),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.12),
                                  blurRadius: 18,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: image == null
                                ? const Icon(
                              Icons.image_rounded,
                              size: 70,
                              color: Color(0xff5944F5),
                            )
                                : (controller.imageFormat.value.toUpperCase() == 'PDF' ||
                                controller.imageFormat.value.toUpperCase() == 'SVG')
                                ? Icon(
                              controller.imageFormat.value.toUpperCase() == 'PDF'
                                  ? Icons.picture_as_pdf
                                  : Icons.draw,
                              size: 70,
                              color: const Color(0xff5944F5),
                            )
                                : Image.file(
                              image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 28),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Obx(
                            () => Column(
                          children: [
                            InfoRow(
                              title: "Original Format:",
                              value: controller.originalFormat.value,
                            ),
                            InfoRow(
                              title: "New Format:",
                              value: controller.imageFormat.value,
                            ),
                            InfoRow(
                              title: "Original Size:",
                              value: controller.originalSize.value,
                            ),
                            InfoRow(
                              title: "Converted Size:",
                              value: controller.convertedSize.value,
                            ),
                            InfoRow(
                              title: "Date / Time:",
                              value: controller.dateTime.value,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const Spacer(),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: controller.shareFile,
                            child: Container(
                              width: 69,
                              height: 60,
                              decoration: BoxDecoration(
                                color: const Color(0xffC9C1FF),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.share_outlined,
                                color: Color(0xff5944F5),
                                size: 30,
                              ),
                            ),
                          ),

                          const SizedBox(width: 14),

                          Expanded(
                            child: GestureDetector(
                              onTap: controller.saveToPhoto,
                              child: Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  color: const Color(0xff5944F5),
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xff5944F5)
                                          .withOpacity(0.28),
                                      blurRadius: 16,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child:  Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Obx(() => Text(
                                      (controller.imageFormat.value.toUpperCase() == 'PDF' ||
                                          controller.imageFormat.value.toUpperCase() == 'SVG')
                                          ? "Save to Files"
                                          : "Save to Photo",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    )),
                                    const SizedBox(width: 8),
                                    Icon(
                                      Icons.file_download_outlined,
                                      color: Colors.white,
                                      size: 26,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String title;
  final String value;

  const InfoRow({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 17),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xff747286),
            ),
          ),
        ],
      ),
    );
  }
}