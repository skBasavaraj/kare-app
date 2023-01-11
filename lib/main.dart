import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';

import 'package:nb_utils/nb_utils.dart';

import 'package:zatcare/spalshScreen.dart';
import 'notification/localNotification.dart';

late PackageInfoData packageInfo;


PickedFile? image;

@pragma('vm:entry-point')
Future<void> backgroundHandler(RemoteMessage message) async {
  localNotification().showNotificationWithDefaultSound(message);

  print('Handling a background message ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  await initialize();
  packageInfo = await getPackageInfo();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) =>
          MaterialApp(

            //  navigatorObservers: [FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance)],
            debugShowCheckedModeBanner: false,

            title: "appName",
            navigatorKey: navigatorKey,
            home: SplashScreen(),
            builder: scrollBehaviour(),
          ),
    );
  }

}
