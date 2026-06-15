import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imageconvertor/core/routes_config/app_routes.dart';
  import 'package:sizer/sizer.dart';

import '../../utils/app_colors.dart';
import '../../widgets/app_shodow.dart';
import '../../widgets/app_text.dart';
import 'package:imageconvertor/widgets/animated_gradient_background.dart';
import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {

    return AnimatedGradientBackground(
      child: Scaffold(
        extendBody: false,
        backgroundColor: Colors.transparent,
        appBar: _appBar(),
        body: SafeArea(
          bottom: true,
          child: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    SizedBox(height: 2.h),

                     SizedBox(
                       height: 30.h,
                       child: PageView.builder(
                         controller: controller.pageController,
                         itemCount: controller.featureImage.length ,
                           onPageChanged: (value){
                             controller.onUserPageChanged(value);
                           },
                           itemBuilder: (context, index){
                         return _buildFeatureWidget(controller.featureImage[index], controller.featureTitle[index]);
                       }),
                     ),
                    
                     SizedBox(height: 2.h),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: List.generate(controller.featureImage.length, (value){
                         return Obx(
                             (){
                               return AnimatedContainer(
                                 curve: Curves.easeInCirc,
                                 margin: EdgeInsets.all(2),
                                 width: controller.currentIndex.value == value ? 30 :  15,
                                 height: 12,
                                 decoration: BoxDecoration(
                                   color: controller.currentIndex.value == value ? Colors.blue : Colors.white,
                                   borderRadius: BorderRadius.circular(10),
                                 ), duration: Duration(milliseconds: 180),
                               );
                             }
                         );
                       }),
                     ),
                     SizedBox(height: 2.h),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                     AppText("Popular Conversions", type: AppTextType.heading3,color: Colors.white,),
                    ],),
                    SizedBox(height: 4.h),
          
                    GridView.builder(
                      itemCount: controller.conversions.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 2.42,
                      ),
                      itemBuilder: (_, index) {
                        return GestureDetector(
                          onTap: (){
                            Get.toNamed(AppRoutes.chooseFileView, arguments: {
                              "title" : controller.conversions[index].title,
                            });
                           },
                          child: ConversionTile(
                            item: controller.conversions[index],
                          ),
                        );
                      },
                    ),
          
                     SizedBox(height: 2.h),
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
Widget  _buildFeatureWidget(String image, String title) {
  return GestureDetector(
    onTap: () {
      switch (title) {
        case "Remove Background":
          Get.toNamed(AppRoutes.RemoveBackground);
          break;
        case "Enhanced Photo":
          Get.toNamed(AppRoutes.EnhancedPhoto);
          break;
        case "Text To Image":
          Get.toNamed(AppRoutes.TextToImage);
          break;
        case "Restore Image":
          Get.toNamed(AppRoutes.RestoreOldPhoto);
          break;
        default:
          Get.snackbar(
            "Coming Soon",
            "$title feature is coming soon!",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xff5944F5),
            colorText: Colors.white,
          );
          break;
      }
    },
    child: Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 2.w),
          width: double.infinity,
          height: 30.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            image: DecorationImage(
              image: AssetImage(image),
              fit: BoxFit.fitHeight,
            ),
          ),
        ),

        /// 🔼 Arrow Icon
        Positioned(
          top: 18,
          right: 6.w,
          child: Container(
            width: 8.w,
            height: 8.w,
            decoration: const BoxDecoration(
              color: Color(0xff6F3FE3),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Transform.rotate(
                angle: 0.5,
                child: Icon(
                  Icons.arrow_upward_rounded,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ),

        ///  BOTTOM CONTAINER (FIXED)
        Positioned(
          bottom: 0, //  always stick to bottom
          left: 0,
          right: 0,
          child: Container(
            height: 6.h,
            margin: EdgeInsets.symmetric(horizontal: 2.w),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: AppText(
              title,
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        ),
      ],
    ),
  );
}
_appBar() {
  return AppBar(
    elevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    titleSpacing: 0,
    title: Row(
      children: [
        SizedBox(width: 3.w),
        AppText(
          'Ai Photo Studio',
          type: AppTextType.heading2,
          color: AppColors.white,
        ),
      ],
    ),
  );
}

 class ConversionTile extends StatelessWidget {
  final ConversionItem item;

  const ConversionTile({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: const Color(0xffE2E2E2)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 15,
            backgroundColor: item.color.withOpacity(0.20),
            child: Text(
              item.type,
              style: TextStyle(
                color: item.color,
                fontSize: 9,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              item.title,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Icon(Icons.arrow_forward, size: 26),
        ],
      ),
    );
  }
}
class ChooseFileCard extends StatelessWidget {
  const ChooseFileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 302,
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xffE0E0E0)),
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xffEEEAFE),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.file_copy_rounded,
              color: Color(0xff5944F5),
              size: 38,
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Convert Any File Easily',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w900,
              color: Color(0xff161827),
            ),
          ),

          const SizedBox(height: 14),

          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: () {
                Get.toNamed(AppRoutes.chooseFileView);
              },
                style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff5944F5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 4,
              ),
              child: const Text(
                'Choose File',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'Browse from Gallery, Files or Camera',
            style: TextStyle(
              color: Color(0xff8E8E9A),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}