import 'package:firebase_remote_config/firebase_remote_config.dart';

class FirebaseConfigs {
  static final FirebaseConfigs _instance = FirebaseConfigs._internal();
  factory FirebaseConfigs() => _instance;
  FirebaseConfigs._internal();

  final FirebaseRemoteConfig firebaseRemoteConfig =
      FirebaseRemoteConfig.instance;

  Future<void> initialize() async {
    await firebaseRemoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 4),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );
    await firebaseRemoteConfig.setDefaults({
      "falKey" : ""
    });
    await firebaseRemoteConfig.fetchAndActivate();
    
  }
  String get falKey => firebaseRemoteConfig.getString("falKey");
}
