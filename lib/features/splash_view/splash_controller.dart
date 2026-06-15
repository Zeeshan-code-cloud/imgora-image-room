import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:imageconvertor/core/routes_config/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  @override
  void onReady() {
    super.onReady();
    handleUserSession();
  }

  Future<bool> _hasInternet() async {
    final result = await Connectivity().checkConnectivity();
    return result.isNotEmpty && !result.contains(ConnectivityResult.none);
  }

  Future<void> handleUserSession() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final bool isRegistered = prefs.getBool("isRegistered") ?? false;

      if (!isRegistered) {
        final hasinternet = await _hasInternet();
        if (!hasinternet) {
          Get.defaultDialog(
            barrierDismissible: false,
            title: 'No Internet',
            middleText: 'Internet connection is required to continue.',
            textConfirm: 'Retry',
            onConfirm: () {
              Get.back();
              handleUserSession(); // Retry
            },
          );
          return;
        }
        await _registerNewUser(prefs);
      }
      _navigateToHome();
    } catch (e) {
      print('Error in handleUserSession: $e');
      _navigateToHome(); // Fallback to home on error
    }
  }

  Future<void> _registerNewUser(SharedPreferences prefs) async {
    try {
      final deviceData = await _getDeviceData();
      final String deviceId = deviceData['deviceId'] ?? 'unknown';

      // Perform Firestore set asynchronously without awaiting it,
      // preventing startup hangs. Firestore SDK will handle local caching and background syncing.
      _firestore.collection('users').doc(deviceId).set({
        'deviceId': deviceId,
        'deviceModel': deviceData['deviceModel'],
        'plan': 'free',
        'createdAt': FieldValue.serverTimestamp(),
      }).then((_) {
       }).catchError((error) {
       });

      await prefs.setBool('isRegistered', true);
    } catch (e, stackTrace) {
      Get.snackbar("internl error", "something went wrong with system");
    }
  }

  Future<Map<String, String>> _getDeviceData() async {
    String deviceId = 'unknown';
    String deviceModel = 'unknown';

    try {
      if (Platform.isAndroid) {
        final info = await _deviceInfo.androidInfo;
        deviceId = info.id;
        deviceModel = info.model;
      } else if (Platform.isIOS) {
        final info = await _deviceInfo.iosInfo;
        deviceId = info.identifierForVendor ?? 'unknown';
        deviceModel = info.utsname.machine;
      }
    } catch (e) {
     }

    return {
      'deviceId': deviceId,
      'deviceModel': deviceModel,
    };
  }

  void _navigateToHome() {
    Get.offAllNamed(AppRoutes.BottomNavBar);
  }
}
