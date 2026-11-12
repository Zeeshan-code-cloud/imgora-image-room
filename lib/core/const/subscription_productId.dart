class SubscriptionProductid {
  SubscriptionProductid._();

   static const weekly =  "imgora_weekly_subscription";
   static const monthly =  "imgora_monthly_susbcription";
   static const yearly  =  "imgora_yearly_susbcription";

   static List<String> allProductId = [weekly, monthly, yearly];

   static Map<String,int> getTrailsForProductId = {
     "imgora_weekly_subscription": 25,
     "imgora_monthly_susbcription" : 200,
     "imgora_yearly_susbcription" : 1500
   };

   static int getTrailsForProduct(String productId) {
     return getTrailsForProductId[productId] ?? 0;
   }
}