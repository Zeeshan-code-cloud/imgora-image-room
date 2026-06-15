import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:imageconvertor/features/bottom_nav_bar/bottom_nav_controller.dart';

import '../../widgets/custom_platform_widget.dart';
import '../../widgets/dashboard_nav_bar.dart';

class BottomNavBar extends GetView<BottomNavController> {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) {
            return;
          }

          if (controller.currentIndex != 0) {
            controller.currentIndex = 0;
            return;
          }

          CustomPlatformWidget.showDefaultDialog(
            context: context,
            title: "Exit App?",
            message: "Do you want to exit the app?",
            confirmText: 'Exit',
            cancelText: 'Cancel',
            confirmColor: Colors.redAccent,
            cancelColor: Colors.grey,
            onConfirm: () {
              SystemNavigator.pop();
            },
          );
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: controller.bottomNavScreens[controller.currentIndex],
          bottomNavigationBar: DashboardNavbar(),
          floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,
        ),
      );
    });
  }
}
