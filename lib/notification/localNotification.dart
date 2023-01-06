import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class localNotification{
  static     FlutterLocalNotificationsPlugin flip = new FlutterLocalNotificationsPlugin();
  static void initLocal(){
    // resource to the Android head project.
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');

    var IOS = new DarwinInitializationSettings();

    // initialise settings for both Android and iOS device.
    var settings = new InitializationSettings(android: android,iOS: IOS);
    flip.initialize(settings);
  }
  showNotificationWithDefaultSound(RemoteMessage remoteMessage) async {
    RemoteNotification? notification = remoteMessage.notification;

    // Show a notification after every 15 minute with the first
    // appearance happening a minute after invoking the method
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'zatcare',
        'zatcare',
         importance: Importance.max,
        priority: Priority.high
    );
    var iOSPlatformChannelSpecifics = new DarwinNotificationDetails();

    // initialise channel platform for both Android and iOS device.
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
      iOS:  iOSPlatformChannelSpecifics
    );
    await flip.show(0, notification?.title.toString(),
        notification?.body,
        platformChannelSpecifics, payload: 'Default_Sound'
    );
  }
}