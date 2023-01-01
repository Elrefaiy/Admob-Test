import 'package:admob_test/ads.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  BannerAd banner;
  InterstitialAd interstitialAd;
  RewardedAd rewardedAd;
  int rewardedScore = 0;

  @override
  void initState() {
    super.initState();
    createBannerAd();
    createInterstitialAd();
    createRewardedAd();
  }

  void createBannerAd() {
    banner = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: AdsManager.bannerAdUnitId,
      listener: AdsManager.bannerAdListener,
      request: const AdRequest(),
    )..load();
  }

  void createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdsManager.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => interstitialAd = ad,
        onAdFailedToLoad: (error) => interstitialAd = null,
      ),
    );
  }

  void showInterstitialAd() {
    if (interstitialAd != null) {
      interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          createInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          createInterstitialAd();
        },
      );
      interstitialAd.show();
      interstitialAd = null;
    }
  }

  void createRewardedAd() {
    RewardedAd.load(
      adUnitId: AdsManager.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) => setState(() => rewardedAd = ad),
        onAdFailedToLoad: (ad) => setState(() => rewardedAd = null),
      ),
    );
  }

  void showRewardedAd() {
    if (rewardedAd != null) {
      rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          createRewardedAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          createRewardedAd();
        },
      );
      rewardedAd.show(
        onUserEarnedReward: (ad, reward) => setState(
          () => rewardedScore++,
        ),
      );
      rewardedAd = null;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
        ),
        title: const Text(
          'Admob Test',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              'Rewarded Score is : $rewardedScore',
              textScaleFactor: 2,
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                showRewardedAd();
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Rewarded Ad',
                  textScaleFactor: 2,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                showInterstitialAd();
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Interstitial Ad',
                  textScaleFactor: 2,
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
      bottomNavigationBar: banner == null
          ? Container()
          : Container(
              margin: const EdgeInsets.only(bottom: 12),
              height: 52,
              child: AdWidget(
                ad: banner,
              ),
            ),
    );
  }
}
