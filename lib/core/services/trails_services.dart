import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class TrailsServices  extends GetxService{
  final RxInt remainingTrials = 0.obs;
  final RxString plan = "".obs;
  final RxBool isLoading = true.obs;
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  late String deviceId;
  StreamSubscription<DocumentSnapshot>? _subscription;


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
      Get.snackbar("error", e.toString());
    }

    return {
      'deviceId': deviceId,
      'deviceModel': deviceModel,
    };
  }


  Future<TrailsServices> init() async {
    final deviceData = await _getDeviceData();
    deviceId = deviceData["deviceId"] ?? "Unknown";
    await _listenToTrials();
    return this;
  }

  Future<void> _listenToTrials() async {
    final docRef = FirebaseFirestore.instance.collection("users").doc(deviceId);

     final snapshot = await docRef.get();
    if (!snapshot.exists) {
       await docRef.set({"remainingTrials": 3}, SetOptions(merge: true));
    }

     _subscription = docRef.snapshots().listen(
          (docSnapshot) {
        if (docSnapshot.exists && docSnapshot.data() != null) {
          final data = docSnapshot.data()!;
          remainingTrials.value = data["remainingTrials"] ?? 3;
          plan.value = data["plan"] ?? "";
        }
        isLoading.value = false;
      },
      onError: (error) {
        debugPrint('Trial listener error: $error');
        isLoading.value = false;
      },
    );

     await remainingTrials.stream.first.timeout(
      const Duration(seconds: 3),
      onTimeout: () => 0,
    ).catchError((_) => 0);
  }

  Future<void> decrementTrial() async {
    if (remainingTrials.value <= 0) return;

    final newValue = remainingTrials.value - 1;
    remainingTrials.value = newValue; // optimistic update, UI turant reflect ho

    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(deviceId)
          .update({"remainingTrials": newValue});
    } catch (e) {
      remainingTrials.value++; // rollback agar Firestore write fail ho jaye
      debugPrint('Failed to sync trial count: $e');
    }
  }

  @override
  void onClose() {
    _subscription?.cancel(); // MEMORY LEAK se bachne ke liye zaroori
    super.onClose();
  }
}