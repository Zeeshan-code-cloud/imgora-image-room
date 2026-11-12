class SubscriptionExceptions  implements Exception {
  final String message;
  SubscriptionExceptions(this.message);

  @override
  String toString() => message;

}