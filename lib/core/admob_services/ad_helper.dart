import 'package:flutter/foundation.dart';

class AdHelper {
   static bool get _isTestMode => kDebugMode;

  static String get enhanceAdId {
    if (_isTestMode) return 'ca-app-pub-3940256099942544/5354046379';
    return 'ca-app-pub-6991124664385162/8469111012';
  }

  static String get generateAdId {
    if (_isTestMode) return 'ca-app-pub-3940256099942544/5354046379';
    return 'ca-app-pub-6991124664385162/4290192858';
  }

  static String get editAdId {
    if (_isTestMode) return 'ca-app-pub-3940256099942544/5354046379';
    return 'ca-app-pub-6991124664385162/9369083547';
  }

  static String get bgRemoveAdId {
    if (_isTestMode) return 'ca-app-pub-3940256099942544/5354046379';
    return 'ca-app-pub-6991124664385162/7712386945';
  }

}