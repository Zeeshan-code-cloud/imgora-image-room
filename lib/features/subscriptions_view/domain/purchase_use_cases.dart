import 'package:imageconvertor/features/subscriptions_view/domain/purchase_repo.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class FetchPurchaseUseCase {
  final PurchaseRepo purchaseRepo;
  FetchPurchaseUseCase(this.purchaseRepo);

  Future<List<ProductDetails>> call(List<String> productId) {
    return purchaseRepo.fetchProducts(productId);
  }
}

class BuySubscriptionUseCase {
  final PurchaseRepo purchaseRepo;
  BuySubscriptionUseCase(this.purchaseRepo);

  Future<void> call(ProductDetails product) {
    return purchaseRepo.buySubscription(product);
  }
}

class RestorePurchaseUseCase {
  final PurchaseRepo purchaseRepo;
  RestorePurchaseUseCase(this.purchaseRepo);
  Future<void> call() {
    return purchaseRepo.restorePurchases();
  }
}


