import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:imageconvertor/features/text_to_image/text_to_image_controller.dart';
import 'package:sizer/sizer.dart';
 import '../../utils/app_icons.dart';
import '../../widgets/app_button_widget.dart';
import '../../widgets/app_form_field.dart';
import '../../widgets/app_text.dart';
import '../../widgets/shimmer_widget.dart';

class  TextToImage extends GetView<TextToImageController> {
  const  TextToImage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [ Color(0xff4B3FAF),
            Color(0xff0B0F1A),
            Color(0xff0B0F1A)],begin: Alignment.topLeft,
            end: Alignment.bottomRight,)
        ),
        child: Scaffold(
        backgroundColor: Colors.transparent,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 18.0, left: 16, right: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        InkWell(
                            onTap: (){
                              Get.back();
                            },
                            child: Icon(Icons.arrow_back, color: Colors.white)),
                        SizedBox(width: 12.w),
                        AppText(
                          "Ai Generator",
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                    SizedBox(height: 14),
                    Obx(() => controller.isGenerationComplete.value ? const SizedBox.shrink() : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          "Enter Prompt",
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        SizedBox(height: 14),
                        Container(
                          width: 100.w,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: const Color(0xff0B1726), // dark bg
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: const Color(0x14FFFFFF)),
                          ),
                          child: Obx(
                                () => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                controller.selectedImage.value != null
                                    ? Padding(
                                  padding: const EdgeInsets.only(top: 12, left: 20),
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      // IMAGE
                                      Container(
                                        height: 8.h,
                                        width: 30.w,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.blueGrey),
                                          borderRadius: BorderRadius.circular(20),
                                          image: DecorationImage(
                                            image: FileImage(
                                              controller.selectedImage.value!,
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      // CANCEL BUTTON
                                      Positioned(
                                        top: -8,
                                        right: -8,
                                        child: GestureDetector(
                                          onTap: () {
                                            controller.clearSelectedImage();
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: const BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                    : const SizedBox.shrink(),

                                AppFormField(
                                   filledColor: Colors.transparent,
                                  textColor: Colors.white,
                                  isMultiline: true,
                                  title: "Describe what you want to see... e.g A Fut rustic cyberpunk city with neon lights and flying cars in the rain.",
                                  textEditingController: controller.promptController,
                                ),
                              ],
                            ),
                          )
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Obx(
                                    ()   =>  AppUploadButton(
                                icon: SvgPicture.asset(AppIcons.upload, height: 2.4.h,),
                                title:"Upload Image",
                                onTap: controller.disableButtons.value == true ? () {} :  controller.pickImageFromGallery,
                                              ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        AppText(
                          "Image Ratio",
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            imageRatioWidget("1:1"),
                            imageRatioWidget("3:2"),
                            imageRatioWidget("16:9"),
                            imageRatioWidget("9:16"),
                          ],
                        ),
                        SizedBox(height: 16),
                      ],
                    )),

                    Obx(() {
                      final img = controller.generatedImage.value;
                      if (img != null) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.memory(
                            img,
                            height: 60.h,
                            width: double.infinity,
                            fit: BoxFit.contain,
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }),

                    SizedBox(height: 14),
                    Obx(() => AppButtonWidget(
                      onPressed: controller.isLoading.value
                          ? null
                          : (controller.isGenerationComplete.value ? controller.saveToGallery : controller.generateImage),
                      prefixIcon: controller.isGenerationComplete.value
                          ? const Icon(Icons.save, color: Colors.white)
                          : SvgPicture.asset(AppIcons.aiIcon, color: Colors.white),
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      text: controller.isLoading.value
                          ? "Processing..."
                          : (controller.isGenerationComplete.value ? "Save to Gallery" : "Generate Image"),
                      width: 95.w,
                      height: 14.w,
                      textColor: Colors.white,
                      buttonColor: const Color(0xff6F3FE3),
                      loader: controller.isLoading.value,
                      radius: 20,
                    )),
                    SizedBox(height: 14),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildShimmerGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 8, // placeholder items
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 16,
        crossAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        return Column(
          children: [
            /// 🔹 CIRCLE IMAGE SHIMMER
            ShimmerWidget(
              child: Container(
                width: 18.w,
                height: 18.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),

            SizedBox(height: 6),

            /// 🔹 TEXT SHIMMER
            ShimmerWidget(
              child: Container(
                width: 12.w,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget imageRatioWidget(String text) {
    return Obx(() {
      final isSelected = controller.selectedRatio.value == text;
      return Material(
        color: Colors.transparent,
        child: Ink(
          height: 12.w,
          width: 20.w,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xff6F3FE3) : const Color(0xff191929),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: isSelected ? const Color(0xff6F3FE3) : Colors.grey.shade700,
            ),
          ),
          child: InkWell(
            onTap: controller.disableButtons.value == true ? () {} : () {
              controller.selectedRatio.value = text;
            },
            borderRadius: BorderRadius.circular(30),
            child: Center(
              child: AppText(
                text,
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    });
  }

 }

class AppUploadButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final Widget? icon;

  const AppUploadButton({
    super.key,
    required this.title,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 45.w,
        padding: EdgeInsets.symmetric(vertical: 2.w),
        decoration: BoxDecoration(
          color: const Color(0xff191929), // dark background
          borderRadius: BorderRadius.circular(50), // pill shape
          border: Border.all(color: const Color(0x14FFFFFF)),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withAlpha(38),
              blurRadius: 20,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// ICON
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: icon,
            ),

            SizedBox(width: 1.w),

            /// TEXT
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
