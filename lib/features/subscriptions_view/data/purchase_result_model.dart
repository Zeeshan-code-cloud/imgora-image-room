class PurchaseResultModel {
  final bool isSuccess;
  final String? productId;
  final String? errorMessage;
  final AppPurchaseStatus purchaseStatus;

  PurchaseResultModel({
    required this.isSuccess,
     this.productId,
     this.errorMessage,
    required this.purchaseStatus,
  });
}

enum AppPurchaseStatus {pending, purchased, error , restored,canceled}
