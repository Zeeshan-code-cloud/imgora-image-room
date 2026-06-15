import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_helper.dart';

class RewardedAdService {
  RewardedInterstitialAd? _ad;
  bool _isAdLoaded = false;
  bool _isAdShowing = false;
  final String adUnitId;

  RewardedAdService({required this.adUnitId});

   bool get isAdLoaded => _isAdLoaded;


  void loadAd() {
    RewardedInterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (RewardedInterstitialAd ad) {
          _ad = ad;
          _isAdLoaded = true;
          print(' Ad loaded: $adUnitId');

          // Ad close hone par callbacks
          _ad!.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              _isAdShowing = true;
              print('Ad showing...');
            },
            onAdDismissedFullScreenContent: (ad) {
              _isAdShowing = false;
              _isAdLoaded = false;
              ad.dispose();
              print('Ad dismissed — next ke liye reload');
              loadAd(); // Agli baar ke liye pre-load
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              _isAdShowing = false;
              _isAdLoaded = false;
              ad.dispose();
              print('Ad show failed: $error');
              loadAd();
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          _isAdLoaded = false;
          print('Ad failed to load: $error');
        },
      ),
    );
  }

  // ============================================================
  // AD SHOW KARO — Feature unlock callback ke saath
  // ============================================================
  void showAd({
    required Function onRewarded,
    Function? onAdNotReady,
  }) {
    if (_ad != null && _isAdLoaded && !_isAdShowing) {
      _ad!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
           onRewarded(); // Feature unlock callback
        },
      );
    } else {

      bool isDialogShowing = true;
      Get.dialog(
        PopScope(
          canPop: false,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        barrierDismissible: false,
      ).then((_) {
        isDialogShowing = false;
      });

      RewardedInterstitialAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
          onAdLoaded: (RewardedInterstitialAd ad) {
            _ad = ad;
            _isAdLoaded = true;
            
            if (isDialogShowing) {
              Get.back();
            }
            
            ad.show(
              onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
                print('Reward earned! Unlocking feature...');
                onRewarded();
              },
            );

            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdShowedFullScreenContent: (ad) {
                _isAdShowing = true;
                print('Ad showing...');
              },
              onAdDismissedFullScreenContent: (ad) {
                _isAdShowing = false;
                _isAdLoaded = false;
                ad.dispose();
                print('Ad dismissed — next ke liye reload');
                loadAd();
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                _isAdShowing = false;
                _isAdLoaded = false;
                ad.dispose();
                print('Ad show failed: $error');
                loadAd();
                if (onAdNotReady != null) {
                  onAdNotReady();
                } else {
                  onRewarded();
                }
              },
            );
          },
          onAdFailedToLoad: (LoadAdError error) {
            _isAdLoaded = false;
            if (isDialogShowing) {
              Get.back();
            }
            print('Ad failed to load: $error');
            if (onAdNotReady != null) {
              onAdNotReady();
            } else {
              onRewarded();
            }
          },
        ),
      );
    }
  }

  // ============================================================
  // CLEANUP
  // ============================================================
  void dispose() {
    _ad?.dispose();
    _ad = null;
    _isAdLoaded = false;
  }
}

// ============================================================
// AD MANAGER — Charo features ke liye ek jagah se manage karo
// ============================================================
class AdManager {
  // Singleton — poori app mein ek hi object
  static final AdManager _instance = AdManager._internal();
  factory AdManager() => _instance;
  AdManager._internal();

  // Charo features ke liye alag alag service
  late final RewardedAdService enhanceAd;
  late final RewardedAdService generateAd;
  late final RewardedAdService editAd;
  late final RewardedAdService bgRemoveAd;

  bool _initialized = false;

  // ============================================================
  // APP START MEIN INITIALIZE KARO — main.dart mein call karo
  // ============================================================
  Future<void> initialize() async {
    if (_initialized) return;

    await MobileAds.instance.initialize();
    print('AdMob initialized!');

    // Charo ads pre-load karo
    enhanceAd = RewardedAdService(adUnitId: AdHelper.enhanceAdId);
    generateAd = RewardedAdService(adUnitId: AdHelper.generateAdId);
    editAd = RewardedAdService(adUnitId: AdHelper.editAdId);
    bgRemoveAd = RewardedAdService(adUnitId: AdHelper.bgRemoveAdId);

    enhanceAd.loadAd();
    generateAd.loadAd();
    editAd.loadAd();
    bgRemoveAd.loadAd();

    _initialized = true;
    print('All 4 ads pre-loading...');
  }

  // Cleanup
  void dispose() {
    enhanceAd.dispose();
    generateAd.dispose();
    editAd.dispose();
    bgRemoveAd.dispose();
  }
}