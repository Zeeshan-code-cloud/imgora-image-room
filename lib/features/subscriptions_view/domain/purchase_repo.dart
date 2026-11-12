import 'package:imageconvertor/features/subscriptions_view/data/purchase_result_model.dart';
 import 'package:in_app_purchase/in_app_purchase.dart';
abstract class PurchaseRepo {
  Future<List<ProductDetails>> fetchProducts(List<String> productIds);
  Future<void> buySubscription(ProductDetails product);
  Stream<PurchaseResultModel> get purchaseUpdates;
  Future<void> restorePurchases();

 }