import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../features/bottom_nav_bar/bottom_nav_controller.dart';
import '../utils/app_colors.dart';

class DashboardNavItem extends StatelessWidget {
  const DashboardNavItem({
    super.key,
    required this.icon,
    required this.title,
    required this.index,
  });

  final String icon, title;
  final int index;

  @override
  Widget build(BuildContext context) {
    final dashboardC = Get.find<BottomNavController>();

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => dashboardC.currentIndex = index,
      child: Obx(() {
        final isSelected = dashboardC.currentIndex == index;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          padding: EdgeInsets.symmetric(vertical: 1.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedScale(
                duration: const Duration(milliseconds: 220),
                scale: isSelected ? 1.06 : 1,
                child: SvgPicture.asset(
                  icon,
                  height: 2.5.h,
                  colorFilter: ColorFilter.mode(
                    isSelected ? Color(0xff44A7D8) : AppColors.textSecondary,
                    BlendMode.srcIn,
                  ),
                ),
              ),

              SizedBox(height: 0.4.h),
              isSelected ?
              Text(
                title,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight:
                  isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected
                      ? Color(0xff44A7D8)
                      : AppColors.textSecondary,
                ),
              ) :SizedBox.shrink() ,

              SizedBox(height: 0.4.h),

              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 2.5,
                width: isSelected ? 18 : 0,
                decoration: BoxDecoration(
                  color: Color(0xff44A7D8),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}