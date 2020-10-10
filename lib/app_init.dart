import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common/config.dart';
import 'common/constants.dart';
import 'models/app.dart';
import 'models/category.dart';
import 'screens/home/onboard_screen.dart';
import 'screens/login.dart';
import 'services/wordpress.dart';
import 'widgets/common/animated_splash.dart';
import 'widgets/common/custom_splash.dart';
import 'widgets/common/static_splashscreen.dart';
import 'widgets/onesignal/onesignal.dart';

class AppInit extends StatefulWidget {
  final Function onNext;

  AppInit({this.onNext});

  @override
  _AppInitState createState() => _AppInitState();
}

class _AppInitState extends State<AppInit> with AfterLayoutMixin<AppInit> {
  bool isFirstSeen = true;
  bool isLoggedIn = true;
  Map appConfig = {};

  /// check if the screen is already seen At the first time
  Future checkFirstSeen() async {
    final LocalStorage storage = LocalStorage('fstore');
    final bool ready = await storage.ready;
    bool _seen;
    if (ready) {
      _seen = storage.getItem(kLocalKey["isFirstSeen"]);
      if (_seen == null) {
        setState(() {
          _seen = true;
        });
      }
    }
    return _seen;
  }

  /// Check if the App is Login
  Future checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('loggedIn') ?? false;
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    await loadInitData();
  }

  Future<void> loadInitData() async {
    try {
      debugPrint("[AppState] Inital Data");

      isFirstSeen = await checkFirstSeen();
      isLoggedIn = await checkLogin();

      WordPress().setAppConfig(serverConfig);
      appConfig =
          await Provider.of<AppModel>(context, listen: false).loadAppConfig();
      Future.delayed(Duration.zero, () {
        if (mounted) {
          Provider.of<CategoryModel>(context, listen: false).getCategories(
            lang: Provider.of<AppModel>(context, listen: false).locale,
          );
        }
      });

      /// Load App model config
      MyOneSignal().oneSignalInit(context);

      debugPrint("[AppState] Init Data Finish");
    } catch (e, trace) {
      print(e.toString());
      print(trace.toString());
    }
  }

  Widget onNextScreen() {
    if (isFirstSeen && !kIsWeb && appConfig != null) {
      if (onBoardingData.isNotEmpty) return OnBoardScreen(appConfig);
    }

    if (kLoginSetting['IsRequiredLogin'] && !isLoggedIn) {
      return LoginScreen();
    }
    return widget.onNext(appConfig);
  }

  @override
  Widget build(BuildContext context) {
//     There are totally 3 types: "flare" uses .flr file, "animated" uses .png|.jpeg|.jpg file
//     or image url and "zoomIn" uses logo or image url
//     In config.json, edit data according to "SplashScreen" key properly to meet those needs.

    /*
    Animated sample config:
    "SplashScreen": {
    "type": "animated",
    "data": "https://images.unsplash.com/photo-1503818454-2a008dc38d43?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80"
 or "data": "assets/images/splashscreen.png"
     },
     */

    /*
    fadeIn splash screen sample config:
     "SplashScreen": {
        "type": "fadeIn",
        "data": "https://docs.inspireui.com/images/logos/fluxnews.png"
    or  "data" : "assets/images/logo.png"
      },
     */

    var appConfig = Provider.of<AppModel>(context, listen: false).appConfig;
    String splashScreenType = appConfig['SplashScreen'] != null
        ? appConfig['SplashScreen']['type']
        : kSplashScreenType;
    dynamic splashScreenData = appConfig['SplashScreen'] != null
        ? appConfig['SplashScreen']['data']
        : kSplashScreen;

    if (splashScreenType == 'flare') {
      debugPrint('[FLARESCREEN] Flare');
      return SplashScreen.navigate(
        name: splashScreenData,
        startAnimation: 'fluxstore',
        backgroundColor: Colors.white,
        next: (object) => onNextScreen(),
        until: () => Future.delayed(const Duration(seconds: 2)),
      );
    }

    if (splashScreenType == 'animated') {
      debugPrint('[FLARESCREEN] Animated');
      return AnimatedSplash(
        imagePath: splashScreenData,
        home: onNextScreen(),
        duration: 2500,
        type: AnimatedSplashType.StaticDuration,
      );
    }
    if (splashScreenType == 'zoomIn') {
      return CustomSplash(
        imagePath: splashScreenData,
        backGroundColor: Colors.black,
        animationEffect: 'zoom-in',
        logoSize: 50,
        home: onNextScreen(),
        duration: 2500,
      );
    }
    if (splashScreenType == 'static') {
      return StaticSplashScreen(
        imagePath: splashScreenData,
      );
    }
    return Container();
  }
}
