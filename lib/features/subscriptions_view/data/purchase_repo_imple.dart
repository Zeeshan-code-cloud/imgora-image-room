import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:imageconvertor/features/subscriptions_view/data/purchase_result_model.dart';
import 'package:imageconvertor/features/subscriptions_view/domain/purchase_repo.dart';
import 'package:imageconvertor/features/subscriptions_view/domain/subscription_exceptions.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../core/const/subscription_productId.dart';

class PurchaseRepoImple implements PurchaseRepo {
  final InAppPurchase inAppPurchase = InAppPurchase.instance;
  late StreamController<PurchaseResultModel> _purchaseUpdatesController;
  final firestore = FirebaseFirestore.instance;
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

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
 rethrow;
     }

    return {'deviceId': deviceId, 'deviceModel': deviceModel};
  }

  PurchaseRepoImple() {
    _purchaseUpdatesController =
        StreamController<PurchaseResultModel>.broadcast();
    _listenPurchaseUpdates();
  }

  @override
  Stream<PurchaseResultModel> get purchaseUpdates =>
      _purchaseUpdatesController.stream;

  void _listenPurchaseUpdates() {
    inAppPurchase.purchaseStream.listen(
      (purchaseDetailsList) {
        for (var purchase in purchaseDetailsList) {
          _handelPurchase(purchase);
        }
      },
      onError: (error) {
        _purchaseUpdatesController.add(
          PurchaseResultModel(
            isSuccess: false,
            errorMessage: error.toString(),
            purchaseStatus: AppPurchaseStatus.error,
          ),
        );
      },
    );
  }

  Future<void> _handelPurchase(PurchaseDetails purchase) async {
    if (purchase.status == PurchaseStatus.pending) {
      _purchaseUpdatesController.add(
        PurchaseResultModel(
          isSuccess: false,
          errorMessage: purchase.error?.message ?? purchase.error.toString(),
          purchaseStatus: AppPurchaseStatus.pending,
        ),
      );
      return;
    }

    if (purchase.status == PurchaseStatus.error) {
      _purchaseUpdatesController.add(
        PurchaseResultModel(
          isSuccess: false,
          errorMessage: purchase.error?.message ?? purchase.error.toString(),
          purchaseStatus: AppPurchaseStatus.error,
        ),
      );
      if (purchase.pendingCompletePurchase) {
        await inAppPurchase.completePurchase(purchase);
      }
      return;
    } else if (purchase.status == PurchaseStatus.purchased ||
        purchase.status == PurchaseStatus.restored) {
      final verified = await verifiedPurchase(purchase);
      if (verified) {
        try {
          await handelPurchase(
            purchase.productID,
            _calculateExpiryDate(purchase.productID),
            true,
            purchase.purchaseID ?? "",
          );
          _purchaseUpdatesController.add(
            PurchaseResultModel(
              isSuccess: true,
              purchaseStatus: purchase.status == PurchaseStatus.restored
                  ? AppPurchaseStatus.restored
                  : AppPurchaseStatus.purchased,
              productId: purchase.purchaseID,
            ),
          );
        } catch (e) {
          _purchaseUpdatesController.add(
            PurchaseResultModel(
              isSuccess: false,
              purchaseStatus: AppPurchaseStatus.error,
              errorMessage: "Failed to update the purchase ${e.toString()}",
            ),
          );
        }
      }
    } else {
      _purchaseUpdatesController.add(
        PurchaseResultModel(
          isSuccess: false,
          errorMessage: purchase.error?.message ?? purchase.error.toString(),
          purchaseStatus: AppPurchaseStatus.error,
        ),
      );
    }
    if (purchase.pendingCompletePurchase) {
      await inAppPurchase.completePurchase(purchase);
    }
  }

  DateTime _calculateExpiryDate(String productId) {
    final now = DateTime.now();
    if (productId.contains('yearly')) {
      return now.add(const Duration(days: 365));
    }
    if (productId.contains("weekly")) {
      return now.add(const Duration(days: 7));
    }
    return now.add(const Duration(days: 30)); // monthly default
  }

  Future<bool> verifiedPurchase(PurchaseDetails purchaseDetails) async {
    // TODO: server-side verification abhi missing hai
    // Production mein ye Cloud Function ko call karna chahiye jo
    // Google Play Developer API se purchase.verificationData.serverVerificationData
    // verify kare. Abhi fake/spoofed purchases bhi accept ho jaayenge.

    if (purchaseDetails.verificationData.serverVerificationData.isEmpty) {
      return false; // kam se kam empty data reject karo
    }

    return true;
  }

  @override
  Future<List<ProductDetails>> fetchProducts(List<String> productIds) async {
    final bool storeAvailable = await inAppPurchase.isAvailable();
    if (!storeAvailable) {
      throw SubscriptionExceptions("store  not available");
    }
    final res = await inAppPurchase.queryProductDetails(productIds.toSet());
    if (res.notFoundIDs.isNotEmpty) {
      throw SubscriptionExceptions("Product not found : ${res.notFoundIDs}");
    }
    return res.productDetails;
  }

  @override
  Future<void> restorePurchases() async {
    await inAppPurchase.restorePurchases();
  }

  @override
  Future<void> buySubscription(ProductDetails product) async {
    final purchaseParam = PurchaseParam(productDetails: product);
    await inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  }


  Future<void> handelPurchase(
    String productId,
    DateTime expiryDate,
    bool isPro,
    String purchaseId,
  ) async {
    try {
      final deviceData = await _getDeviceData();
      final String deviceId = deviceData['deviceId'] ?? 'unknown';
      final int totaltrails = SubscriptionProductid.getTrailsForProduct(productId);
      await firestore.collection('users').doc(deviceId).update({
        "plan": isPro ? "premium" : "free",
        "expiryDate": expiryDate,
        "productId": productId,
        "purchaseId": purchaseId,
        "totalTrails": totaltrails,
        "remainingTrails": totaltrails,
      },);
    } catch (e) {
      rethrow;
    }
  }
}
