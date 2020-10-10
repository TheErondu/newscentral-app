import 'dart:async';
import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';
import 'package:connectivity/connectivity.dart';

import '../../common/constants.dart';
import '../../models/app.dart';
import '../../models/category.dart';
import '../../models/notification.dart';
import '../../widgets/blog/index.dart';
import 'deeplink_item.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin, AfterLayoutMixin<HomeScreen> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  Uri _latestUri;
  StreamSubscription _sub;
  int itemId;

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    initPlatformState();
    firebaseCloudMessagingListeners();
  }

  Future<void> initPlatformState() async {
    if (Platform.isAndroid || Platform.isIOS) {
      await initPlatformStateForStringUniLinks();
    }
  }

  Future<void> initPlatformStateForStringUniLinks() async {
    // Attach a listener to the links stream
    _sub = getLinksStream().listen((String link) {
      if (!mounted) return;
      setState(() {
        _latestUri = null;
        try {
          if (link != null) _latestUri = Uri.parse(link);
          setState(() {
            itemId = int.parse(_latestUri.path.split('/')[1]);
          });

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ItemDeepLink(
                itemId: itemId,
              ),
            ),
          );
        } on FormatException {
          print('[initPlatformStateForStringUniLinks] error');
        }
      });
    }, onError: (err) {
      if (!mounted) return;
      setState(() {
        _latestUri = null;
      });
    });

    getLinksStream().listen((String link) {
      print('got link: $link');
    }, onError: (err) {
      print('got err: $err');
    });
  }

  _saveMessage(message) {
    FStoreNotification a = FStoreNotification.fromJsonFirebase(message);
    a.saveToLocal(message['notification'] != null
        ? message['notification']['tag']
        : message['data']['google.message_id']);
  }

  void firebaseCloudMessagingListeners() {
    if (Platform.isIOS) iOSPermission();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) => _saveMessage(message),
      onResume: (Map<String, dynamic> message) => _saveMessage(message),
      onLaunch: (Map<String, dynamic> message) => _saveMessage(message),
    );
  }

  void iOSPermission() {
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {});
  }

  @override
  void afterFirstLayout(BuildContext context) {
    Provider.of<CategoryModel>(context, listen: false).getCategories();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    ErrorWidget.builder = (error) {
      return Container(
        constraints: const BoxConstraints(minHeight: 1),
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.0),
            borderRadius: BorderRadius.circular(5)),
        margin: const EdgeInsets.symmetric(
          horizontal: 1,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
// *   Hide error, if you're developer, enable it to fix error it has
        // child: Center(
        //   child: Text('Error in ${error.exceptionAsString()}'),
        // ),
      );
    };

    return Consumer<AppModel>(
      builder: (context, value, child) {
        if (value.appConfig == null) {
          return kLoadingWidget(context);
        }
        return HomeLayout(configs: value.appConfig);
      },
    );
  }
}
