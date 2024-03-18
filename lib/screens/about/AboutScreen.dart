/*Prasish*/

import 'package:about/about.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:timetracker/l10n.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timetracker/ad.dart';

class AboutScreen extends StatelessWidget {
  //ad
  final BannerAd myBanner = BannerAd(
    adUnitId: AdManager.bannerAdUnitId,
    size: AdSize.banner,
    request: const AdRequest(),
    listener: const BannerAdListener(),
  )..load();
  AboutScreen({Key? key, myBanner}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: PackageInfo.fromPlatform(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          final packageInfo = snapshot.data as PackageInfo;
          String version = packageInfo.version;
          String buildNumber = packageInfo.buildNumber;
          return AboutPage(
            key: const Key("aboutPage"),
            title: Text(L10N.of(context).tr.about),
            applicationVersion: "v$version+$buildNumber",
            applicationDescription: Text(
              L10N.of(context).tr.appDescription,
              textAlign: TextAlign.justify,
            ),
            applicationIcon: SvgPicture.asset(
              'assets/logo.svg',
              width: 100,
              height: 100,
            ),
            applicationLegalese: L10N.of(context).tr.appLegalese,
            children: <Widget>[
              MarkdownPageListTile(
                filename: 'README.md',
                title: Text(L10N.of(context).tr.readme),
                icon: const Icon(FontAwesomeIcons.readme),
              ),
              //About Privacy Policy
              ListTile(
                leading: const Icon(FontAwesomeIcons.userShield),
                title: Text(L10N.of(context).tr.aboutDeveloper),
                onTap: () =>
                    launchUrl(Uri.parse("https://prasishsharma.com.np")),
              ),
              //Rate Us
              ListTile(
                leading: const Icon(FontAwesomeIcons.star),
                title: Text(L10N.of(context).tr.rateUs),
                onTap: () => launchUrl(Uri.parse(//add valid link here
                    "https://play.google.com/store/apps/details?id=com.yourcompanyname.yourappname")),
              ),
              //Share Us
              ListTile(
                  leading: const Icon(FontAwesomeIcons.share),
                  title: Text(L10N.of(context).tr.share),
                  onTap: () {
                    //   //share app link
                    Share.share(//add valid link here
                        "https://play.google.com/store/apps/details?id=com.yourcompanyname.yourappname&pcampaignid=web_share");
                  }),

              //AdWidget for banner ad
              SizedBox(
                height: 75,
                child: AdWidget(ad: myBanner),
              ),
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
