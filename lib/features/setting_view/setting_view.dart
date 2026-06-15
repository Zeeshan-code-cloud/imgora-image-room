import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imageconvertor/core/routes_config/app_routes.dart';
import 'package:imageconvertor/features/history_view/history_view.dart';
import 'package:imageconvertor/widgets/animated_gradient_background.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingView extends StatelessWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text(
                  "Setting",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Manage your preferences",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 12,),
                settingTiles(Icons.local_activity, "Collections", Colors.white54, (){
                  Get.to(HistoryView());
                }),

                settingTiles(Icons.privacy_tip_rounded, "Privacy Policy", Colors.white54, (){
                  luanchToWeb("https://zeeshan-code-cloud.github.io/image-convertor-privacy/");
                }),
                settingTiles(Icons.terminal_sharp, "Term and Condition", Colors.white54, (){
                  luanchToWeb("https://zeeshan-code-cloud.github.io/terms-image-convertor-/");

                }),
                settingTiles(Icons.star, "Rate the app", Colors.white54, (){
      launchPlayStore("com.zeetech.image.convertor.app.imageconvertor");
                }),
                settingTiles(Icons.star, "About the app", Colors.white54, (){
      luanchToWeb("https://zeeshan-code-cloud.github.io/about-image-convertors/");
                }),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget settingTiles(IconData icon, String title, Color iconColor, VoidCallback Ontap) {
    return GestureDetector(
      onTap: Ontap,
      child: Container(
        padding: EdgeInsets.all(4.w),
        margin: EdgeInsets.all(1.h),
        width: double.infinity,
        height: 7.h,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: BoxBorder.all(color: Colors.grey.shade200,width: 0.3),

        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  height: 15.h,
                  width: 15.w,
                  decoration: BoxDecoration(
                    color: iconColor,
                    shape: BoxShape.circle
                  ),
                   child: Center(child: Icon(icon)),
                ),
                SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white54,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            Icon(Icons.arrow_right_outlined, size: 30,color: Colors.white,),
          ],
        ),
      ),
    );
  }

  Future<void> luanchToWeb(String url) async {
    Uri uri = Uri.parse(url);
    if(!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication
    )){
      Get.snackbar("launch error", "url are invalid");
    }
  }

  static Future<void> launchPlayStore(String packageName) async {
    final Uri uri = Uri.parse(
      "https://play.google.com/store/apps/details?id=$packageName",
    );

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      Get.snackbar(
        "Error",
        "Could not open Play Store",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
