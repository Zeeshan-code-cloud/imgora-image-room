import 'dart:io';

import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService extends GetxService {
  final cameraStatus = PermissionStatus.denied.obs;
  final galleryStatus = PermissionStatus.denied.obs;
  final storageStatus = PermissionStatus.denied.obs;
  final microphoneStatus = PermissionStatus.denied.obs;
  final bluetoothStatus = PermissionStatus.denied.obs;
  final locationStatus = PermissionStatus.denied.obs;

  Future<PermissionService> init() async {
    await checkAllPermissions();
    return this;
  }

  Future<void> checkAllPermissions() async {
    cameraStatus.value = await Permission.camera.status;

    microphoneStatus.value = await Permission.microphone.status;

    locationStatus.value = await Permission.location.status;

    if (Platform.isAndroid) {
      storageStatus.value = await Permission.storage.status;

      bluetoothStatus.value = await Permission.bluetooth.status;

      galleryStatus.value = await Permission.photos.status;
    }
  }

  Future<bool> requestCameraPermission() async {
    return await _handlePermissionRequest(
      permission: Permission.camera,
      statusRx: cameraStatus,
    );
  }

  Future<bool> requestGalleryPermission() async {
    return await _handlePermissionRequest(
      permission: Permission.photos,
      statusRx: galleryStatus,
      allowLimited: true,
    );
  }

  Future<bool> requestStoragePermission() async {
    return await _handlePermissionRequest(
      permission: Permission.storage,
      statusRx: storageStatus,
    );
  }

  Future<bool> requestMicrophonePermission() async {
    return await _handlePermissionRequest(
      permission: Permission.microphone,
      statusRx: microphoneStatus,
    );
  }

  Future<bool> requestBluetoothPermission() async {
    return await _handlePermissionRequest(
      permission: Permission.bluetooth,
      statusRx: bluetoothStatus,
    );
  }

  Future<bool> requestLocationPermission() async {
    return await _handlePermissionRequest(
      permission: Permission.location,
      statusRx: locationStatus,
    );
  }

  Future<void> openSettings() async {
    await openAppSettings();
  }

  bool isPermanentlyDenied(PermissionStatus status) {
    return status.isPermanentlyDenied;
  }

  Future<bool> _handlePermissionRequest({
    required Permission permission,
    required Rx<PermissionStatus> statusRx,
    bool allowLimited = false,
  }) async {
    final status = await permission.request();

    statusRx.value = status;

    if (status.isGranted) {
      return true;
    }

    if (allowLimited && status.isLimited) {
      return true;
    }

    if (status.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }

    return false;
  }
}
