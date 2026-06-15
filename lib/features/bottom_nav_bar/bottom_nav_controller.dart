import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:imageconvertor/features/history_view/history_view.dart';

import '../home_view/home_view.dart';
import '../setting_view/setting_view.dart';

class BottomNavController extends GetxController {

  final _currentIndex = 0.obs;
  int get currentIndex => _currentIndex.value;
  set currentIndex(int value) => _currentIndex.value = value;

  List<Widget> bottomNavScreens = [
    const HomeView(),
    const HistoryView(),
    const SettingView(),

  ];
}