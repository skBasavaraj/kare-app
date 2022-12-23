import 'dart:convert';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';

import 'package:nb_utils/nb_utils.dart';
import 'package:workmanager/workmanager.dart';
import 'dart:developer'as logDev;
import 'package:http/http.dart' as http;
import 'package:zatcare/spalshScreen.dart';

import 'appConstants.dart';
import 'network/apiService.dart';

late PackageInfoData packageInfo;



PickedFile? image;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialize();


  packageInfo = await getPackageInfo();


/*  await  Workmanager().initialize(

    // The top level function, aka callbackDispatcher
      callbackDispatcher,

      // If enabled it will post a notification whenever
      // the task is running. Handy for debugging tasks
      isInDebugMode: true
  );*/
  // Periodic task registration
/*  await Workmanager()
      .registerPeriodicTask(
      "2",


      "ZatCare",


      frequency:   Duration(minutes: 15),

      constraints: Constraints(networkType:  NetworkType.connected)
  );*/
  runApp(MyApp());
}

/*void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {

     FlutterLocalNotificationsPlugin flip = FlutterLocalNotificationsPlugin();

    // app_icon needs to be a added as a drawable
    // resource to the Android head project.
    var android = const AndroidInitializationSettings('@mipmap/app_icon');
    var IOS = const DarwinInitializationSettings();


    logDev.log("NOT message1", name: ';;');
    var settings = InitializationSettings(android: android,iOS: IOS);
    flip.initialize(settings);
    //var getCount = await getNotificaton();

     //
     // print("length11"+getCount.first.name.toString());
     _showNotificationWithDefaultSound(flip, "Nothing");

     logDev.log("NOT message", name: ';;');

    return Future.value(true);

  });
}*/

/*Future _showNotificationWithDefaultSound(flip,String msg) async {

  // Show a notification after every 15 minute with the first
  // appearance happening a minute after invoking the method
  var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'your channel id',
      'your channel name',

      importance: Importance.max,
      priority: Priority.high
  );
  var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();

  // initialise channel platform for both Android and iOS device.
  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics
  );
  await flip.show(0,  "ZatCare",
      msg ,
      platformChannelSpecifics, payload: 'Default_Sound'
  );
}*/

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => MaterialApp(

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
