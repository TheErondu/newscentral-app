import 'dart:ui';

import 'package:after_layout/after_layout.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'app_init.dart';
import 'common/config.dart';
import 'common/styles.dart';
import 'common/tools.dart';
import 'generated/l10n.dart';
import 'models/app.dart';
import 'models/blog_news.dart';
import 'models/category.dart';
import 'models/notification.dart';
import 'models/recent_blog.dart';
import 'models/search.dart';
import 'models/user.dart';
import 'models/wishlist.dart';
import 'route.dart';
import 'services/wordpress.dart';
import 'tabbar.dart';
import 'widgets/firebase/firebase_cloud_messaging_wapper.dart';
import 'widgets/onesignal/onesignal.dart';

FirebaseAnalytics analytics = FirebaseAnalytics();

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp>
    with AfterLayoutMixin
    implements FirebaseCloudMessagingDelegate {
  final _app = AppModel();
  final _wishlist = WishListModel();
  final _search = SearchModel();
  final _recent = RecentModel();
  final _blog = BlogNewsModel();
  bool isChecking = true;
  bool isLoggedIn = true;

  @override
  void afterFirstLayout(BuildContext context) async {
    MyOneSignal().oneSignalInit(context);
    WordPress().setAppConfig(serverConfig);
    await _app.loadAppConfig();
  }

  void _saveMessage(Map<String, dynamic> message) {
    if (message.containsKey('data')) {
      _app.deeplink = message['data'];
    }

    FStoreNotification a = FStoreNotification.fromJsonFirebase(message);
    final id = message['notification'] != null
        ? message['notification']['tag']
        : message['data']['google.message_id'];

    a.saveToLocal(id);
  }

  @override
  void onLaunch(Map<String, dynamic> message) {
    print('[app.dart] onLaunch Pushnotification: $message');

    _saveMessage(message);
  }

  @override
  void onMessage(Map<String, dynamic> message) {
    print('[app.dart] onMessage Pushnotification: $message');

    _saveMessage(message);
  }

  @override
  void onResume(Map<String, dynamic> message) {
    print('[app.dart] onResume Pushnotification: $message');

    _saveMessage(message);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppModel>.value(
      value: _app,
      child: Consumer<AppModel>(
        builder: (context, value, child) {
          if (value.isLoading) {
            return Container(
              color: Theme.of(context).backgroundColor,
            );
          }

          return MultiProvider(
            providers: [
              Provider<BlogNewsModel>.value(value: _blog),
              Provider<WishListModel>.value(value: _wishlist),
              Provider<SearchModel>.value(value: _search),
              Provider<RecentModel>.value(
                value: _recent,
              ),
              ChangeNotifierProvider(create: (context) => UserModel()),
              ChangeNotifierProvider(create: (context) => CategoryModel()),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'News Central TV',
              locale: Locale(
                  Provider.of<AppModel>(context, listen: false).locale, ""),
              navigatorObservers: [
                FirebaseAnalyticsObserver(analytics: analytics),
              ],
              localizationsDelegates: [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: S.delegate.supportedLocales,
              home: Scaffold(
                body: AppInit(
                  onNext: (config) => MainTabs(),
                ),
              ),
              routes: kRouteApp,
              theme: Provider.of<AppModel>(context, listen: false).darkTheme
                  ? buildDarkTheme().copyWith(
                      primaryColor:
                          HexColor(_app.appConfig["Setting"]["MainColor"]))
                  : buildLightTheme().copyWith(
                      primaryColor:
                          HexColor(_app.appConfig["Setting"]["MainColor"])),
            ),
          );
        },
      ),
    );
  }
}
