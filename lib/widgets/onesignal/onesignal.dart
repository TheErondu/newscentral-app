import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../common/config.dart' as config;
import '../../screens/home/deeplink_item.dart';

class MyOneSignal {
  void oneSignalInit(context) {
    OneSignal.shared.init(config.kOneSignalKey['appID'], iOSSettings: {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.inAppLaunchUrl: true
    });
    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);
  }

  void navigateToOneSignalItem(context) {
    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      print(result.notification.jsonRepresentation().replaceAll("\\n", "\n"));
      int postIdFromResult = result.notification.payload.additionalData['id'];
      if (postIdFromResult != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ItemDeepLink(
              itemId: postIdFromResult,
            ),
          ),
        );
      }
      return;
    });
  }
}
