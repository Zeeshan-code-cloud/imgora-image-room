import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  RemoteConfigService._();
  static final RemoteConfigService instance = RemoteConfigService._();

  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  static const String _geminiKeyParam = 'gemini_api_key';


  static const String _fallbackValue = '';


  Future<void> initialize() async {

    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 15),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );

     await _remoteConfig.setDefaults({
      _geminiKeyParam: _fallbackValue,
    });

     await _remoteConfig.fetchAndActivate();
  }


  String get geminiApiKey {
    return _remoteConfig.getString(_geminiKeyParam);
  }

  Future<void> refresh() async {
    await _remoteConfig.fetchAndActivate();
  }
}