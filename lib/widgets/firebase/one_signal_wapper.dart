import 'dart:io' show Platform;

import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../common/config.dart';
import '../../models/notification.dart';

class OneSignalWapper {
  init() {
    if (kOneSignalKey['appID'] != '') {
      Future.delayed(Duration.zero, () async {
        bool allowed =
            await OneSignal.shared.promptUserForPushNotificationPermission();
        if (Platform.isIOS && allowed != null || !Platform.isIOS) {
          OneSignal.shared.setNotificationOpenedHandler(
              (OSNotificationOpenedResult result) {
            print(result.notification
                .jsonRepresentation()
                .replaceAll("\\n", "\n"));
          });
          await OneSignal.shared.init(
            kOneSignalKey['appID'],
            iOSSettings: {
              OSiOSSettings.autoPrompt: false,
              OSiOSSettings.inAppLaunchUrl: true
            },
          );
          await OneSignal.shared
              .setInFocusDisplayType(OSNotificationDisplayType.notification);

          OneSignal.shared
              .setNotificationReceivedHandler((OSNotification osNotification) {
            // print(osNotification.payload.body.toString());
            // print(osNotification.payload.notificationId);
            FStoreNotification a =
                FStoreNotification.fromOneSignal(osNotification);
            a.saveToLocal(
              osNotification.payload.notificationId != null
                  ? osNotification.payload.notificationId
                  : DateTime.now().toString(),
            );
          });
        }
      });
    }
  }
}
