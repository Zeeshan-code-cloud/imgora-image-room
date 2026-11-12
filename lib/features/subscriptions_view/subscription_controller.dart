import 'dart:async';
import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:imageconvertor/features/subscriptions_view/domain/purchase_use_cases.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:imageconvertor/features/subscriptions_view/domain/purchase_repo.dart';
import 'package:imageconvertor/features/subscriptions_view/data/purchase_result_model.dart';
import '../../core/const/subscription_productId.dart';

class SubscriptionController extends GetxController
    with GetTickerProviderStateMixin   {

  FetchPurchaseUseCase fetchPurchaseUseCase;
  RestorePurchaseUseCase restorePurchaseUseCase;
  BuySubscriptionUseCase buySubscriptionUseCase;
   SubscriptionController({
     required this.fetchPurchaseUseCase,
    required this.restorePurchaseUseCase,
    required this.buySubscriptionUseCase,
  });
  final RxInt selectedPlan = 1.obs; // default: Yearly (best value)
   RxBool isLoading  = false.obs;
   RxBool isRestoring  = false.obs;
   RxBool isPurchasing = false.obs;
  late final AnimationController crownController;
  late final Animation<double> crownAnim;
  static List<ProductDetails>? _cachedProducts;
  final RxList<ProductDetails> availableProducts = <ProductDetails>[].obs;

  StreamSubscription<PurchaseResultModel>? _purchaseUpdatesSubscription;


final planDisplayName = [
  "Weekly Plan",
  "Weekly Monthly",
  "Weekly Yearly",
];
  final List<FeatureData> features = const [
    FeatureData(Icons.auto_awesome_rounded, 'Unlimited AI Enhancements',
        'No daily limits, ever'),
    FeatureData(Icons.layers_clear_rounded, 'Instant Background Removal',
        'One-tap, studio quality'),

    FeatureData(Icons.block_flipped, 'Zero Ads', 'Uninterrupted creative flow'),
    FeatureData(Icons.bolt_rounded, 'Priority Processing',
        'Skip the queue, always'),
  ];



  void selectPlan(int index) => selectedPlan.value = index;



  @override
  void onInit() {
    super.onInit();
    crownController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    crownAnim = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: crownController, curve: Curves.easeInOut),
    );
    loadsProducts();

    // Listen to purchase stream updates
    final purchaseRepo = Get.find<PurchaseRepo>();
    _purchaseUpdatesSubscription = purchaseRepo.purchaseUpdates.listen((result) {
      _handlePurchaseResult(result);
    });
  }

  Future<void> loadsProducts() async {
     if(_cachedProducts != null){
       availableProducts.assignAll(_cachedProducts!);
       return;
       }
     try {
       isLoading.value = true;
       final products = await fetchPurchaseUseCase(SubscriptionProductid.allProductId);
       _cachedProducts = products;
       availableProducts.assignAll(products);
     } catch (e) {
       isLoading.value = false;
       debugPrint(e.toString());
     }
     finally{
       isLoading.value = false;
     }
  }


  Future<void> purchase() async {
    if (availableProducts.isEmpty) {
      Get.snackbar('Error', 'Plans not loaded yet. Try again.');
      return;
    }

    isPurchasing.value = true;
    try {
      final product = availableProducts[selectedPlan.value];
      await buySubscriptionUseCase(product);
    } catch (e) {
      isPurchasing.value = false;
      debugPrint(e.toString());
      Get.snackbar('Error', 'Could not start purchase. Try again.');
    }
    finally {
      isPurchasing.value = false;
    }
  }

  Future<void> restorePurchases() async {
    isRestoring.value = true;
    try {
      await restorePurchaseUseCase();
      Get.snackbar(
        'Restore Purchases',
        'Checking for previous purchases...',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    } catch (e) {
      debugPrint(e.toString());
      Get.snackbar(
        'Restore Failed',
        'Failed to restore purchases: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    } finally {
      isRestoring.value = false;
    }
  }

  Future<void> _handlePurchaseResult(PurchaseResultModel result) async {
    if (result.isSuccess) {
      isPurchasing.value = false;
      isLoading.value = false;
      await _updateUserPlanToPro();

      final isRestore = result.purchaseStatus == AppPurchaseStatus.restored;
      Get.snackbar(
        isRestore ? 'Purchases Restored' : 'Purchase Successful',
        isRestore
            ? 'Your previous premium features have been successfully restored!'
            : 'Welcome to Imgora Pro! All premium features are now unlocked.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withValues(alpha: 0.9),
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } else {
      isPurchasing.value = false;
      isLoading.value = false;

      if (result.purchaseStatus == AppPurchaseStatus.error) {
        Get.snackbar(
          'Purchase Failed',
          result.errorMessage ?? 'An error occurred during transaction.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.9),
          colorText: Colors.white,
        );
      } else if (result.purchaseStatus == AppPurchaseStatus.pending) {
        Get.snackbar(
          'Purchase Pending',
          'Your transaction is pending. We will notify you once completed.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange.withValues(alpha: 0.9),
          colorText: Colors.white,
        );
      }
    }
  }

  Future<void> _updateUserPlanToPro() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_pro', true);
      await prefs.setString('plan', 'pro');

      // Update in Firestore
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      String deviceId = 'unknown';
      if (Platform.isAndroid) {
        final info = await deviceInfo.androidInfo;
        deviceId = info.id;
      } else if (Platform.isIOS) {
        final info = await deviceInfo.iosInfo;
        deviceId = info.identifierForVendor ?? 'unknown';
      }

      if (deviceId != 'unknown') {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(deviceId)
            .update({'plan': 'pro'});
      }
    } catch (e) {
      debugPrint("Error updating plan to pro: $e");
    }
  }

  void debugLog(String msg) {
    // swap for your logger
    // ignore: avoid_print
    print('[SubscriptionController] $msg');
  }

  @override
  void onClose() {
    _purchaseUpdatesSubscription?.cancel();
    // Same discipline as StatefulWidget.dispose() — skip this and you leak
    // an AnimationController every time this screen is opened/closed.
    crownController.dispose();
    super.onClose();
  }
}

class PlanData {
  final String title;
  final String price;
  final String subtitle;
  final String? badge;
  final String? savings;

  const PlanData({
    required this.title,
    required this.price,
    required this.subtitle,
    this.badge,
    this.savings,
  });
}

class FeatureData {
  final IconData icon;
  final String title;
  final String subtitle;

  const FeatureData(this.icon, this.title, this.subtitle);
}