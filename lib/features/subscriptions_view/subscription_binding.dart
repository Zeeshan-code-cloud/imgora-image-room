import 'package:get/get.dart';
import 'package:imageconvertor/features/subscriptions_view/data/purchase_repo_imple.dart';
import 'package:imageconvertor/features/subscriptions_view/domain/purchase_repo.dart';
import 'package:imageconvertor/features/subscriptions_view/domain/purchase_use_cases.dart';
import 'package:imageconvertor/features/subscriptions_view/subscription_controller.dart';

class SubscriptionBinding  extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<PurchaseRepo>(() => PurchaseRepoImple());
    Get.lazyPut(() => FetchPurchaseUseCase(Get.find<PurchaseRepo>()));
    Get.lazyPut(() => BuySubscriptionUseCase(Get.find<PurchaseRepo>()));
    Get.lazyPut(() => RestorePurchaseUseCase(Get.find<PurchaseRepo>()));

    Get.put(SubscriptionController(
       buySubscriptionUseCase: Get.find<BuySubscriptionUseCase>(),
      fetchPurchaseUseCase: Get.find<FetchPurchaseUseCase>(),
      restorePurchaseUseCase: Get.find<RestorePurchaseUseCase>(),
    ));
  }

}