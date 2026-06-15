import 'package:flutter/material.dart';
import 'package:imageconvertor/utils/app_icons.dart';
import 'package:sizer/sizer.dart';
import 'app_shodow.dart';
import 'dashboard_items.dart';

class DashboardNavbar extends StatelessWidget {
  const DashboardNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: Container(
        height: 8.h,
        margin: EdgeInsets.symmetric(horizontal: 4.w,),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          // border: Border.all(color: AppColors.borderColor),
          boxShadow: AppShadows.medium,
        ),
        child: Row(
          children:  [
            Expanded(child: DashboardNavItem(icon: AppIcons.home, title: 'Home', index: 0)),
            Expanded(child: DashboardNavItem(icon: AppIcons.history, title: 'Collection', index: 1)),
            Expanded(child: DashboardNavItem(icon: AppIcons.setting, title: 'Settings', index: 2)),
          ],
        ),
      ),
    );
  }
}