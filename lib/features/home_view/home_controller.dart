import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:imageconvertor/features/recen_activities/recent_activities_controller.dart';
import 'package:imageconvertor/utils/app_asset.dart';

class HomeController extends GetxController {

  RxInt currentIndex = 0.obs;
  final recentActivityC = Get.find<RecentActivitiesController>();
  final PageController pageController = PageController();
  Timer? _autoScrollTimer;


  final conversions = [
    ConversionItem('JPG to HEIC', 'HEIC', Color(0xff64C59A)),
    ConversionItem('JPG to PNG', 'PNG', Color(0xffB56CFF)),
    ConversionItem('JPG to PDF', 'IMG', Color(0xff7A83FF)),
    ConversionItem('PDF to JPG', 'PDF', Color(0xffFF5B5B)),
    ConversionItem('SVG TO PNG', 'SVG', Color(0xffFF6FA2)),
    ConversionItem('JPG TO WEBP', 'WEBP', Color(0xff74D2FF)),
  ];

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _startAutoScroll();

  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(
      const Duration(seconds: 4),
          (timer) {
        if (pageController.hasClients) {

          final nextPage = currentIndex.value + 1;

           if (nextPage >= featureImage.length) {
            pageController.animateToPage(
              0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          } else {
            pageController.animateToPage(
              nextPage,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }
        }
      },
    );
  }

  void onUserPageChanged(int index) {
    currentIndex.value = index;
    _resetAutoScroll();
  }

  void _resetAutoScroll() {
    _autoScrollTimer?.cancel();
    _startAutoScroll();
  }


  void onClose() {
     _autoScrollTimer?.cancel();
    pageController.dispose();
    super.onClose();
  }
final featureImage = [
  AppAsset.image6,
  AppAsset.image5,
  AppAsset.image7,
  AppAsset.image4,
 ];

final featureTitle = [
  "Remove Background",
  "Enhanced Photo",
  "Restore Image",
  "Text To Image",
 ];
}

class ConversionItem {
  final String title;
  final String type;
  final Color color;

  ConversionItem(this.title, this.type, this.color);
}