import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// Class to manage ads
class AdManager {
  // Replace the following test ad unit ID with your banner ad unit ID
  static const String bannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';

  // Banner ad instance
  BannerAd? myBanner;

  // Initialize banner ad
  void initialize() {
    myBanner = createBannerAd();
  }

  // Create a BannerAd
  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        // Event handlers for the ad lifecycle
        onAdLoaded: (Ad ad) => debugPrint('Ad loaded.'),
        onAdFailedToLoad: (Ad ad, LoadAdError error) =>
            debugPrint('Ad failed to load: $error'),
        onAdOpened: (Ad ad) => debugPrint('Ad opened.'),
        onAdClosed: (Ad ad) => debugPrint('Ad closed.'),
        onAdImpression: (Ad ad) => debugPrint('Ad impression.'),
      ),
    );
  }
}
