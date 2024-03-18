import 'package:google_mobile_ads/google_mobile_ads.dart';

// Class to manage ads
class AdManager {
  // Replace the following test ad unit ID with your interstitial ad unit ID
  static const String interstitialAdUnitId =
      'ca-app-pub-3940256099942544~3347511713';

  // Interstitial ad instance
  InterstitialAd? myInterstitialAd;
  // Flag to keep track of whether interstitial ad is ready
  bool isInterstitialAdReady = false;

  // Initialize interstitial ad
  void initialize() {
    createInterstitialAd();
  }

  // Create an InterstitialAd
  void createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          // Keep a reference to the ad so you can show it later
          myInterstitialAd = ad;
          isInterstitialAdReady = true;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            // Reload the ad when it's dismissed
            onAdDismissedFullScreenContent: (InterstitialAd ad) {
              createInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  // Show the interstitial ad if it's ready
  void showInterstitialAd() {
    if (myInterstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    myInterstitialAd!.show();
    myInterstitialAd = null;
    isInterstitialAdReady = false;
  }

  // Dispose of resources
  void dispose() {
    myInterstitialAd?.dispose();
  }
}
