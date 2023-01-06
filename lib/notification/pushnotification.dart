import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import 'package:zatcare/appConstants.dart';

class pushNotification{
  static Future<void> sendNotification(String token,String title, String message) async {
    if (token == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }

    /*try {
      await http.post(
        Uri.parse('https://api.rnfirebase.io/messaging/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'key=AAAAQIJxVGs:APA91bFPXCjD04Dxfvh8Fa2mHXBynvTHlkr6kROYJapn8PEgCHIFVVTQoDSWVqAbEsN8siqRltnmJTO9Cl0bt4drUaU3120XQ1ZvEKQ-UWmAmv7IIZbVIYbV1RqVGLTRv4Hq8kF_-LjC'
        },
        body: constructFCMPayload(token,title,message ),
      );
      print('FCM request for device sent!');
    } catch (e) {
      print(e);
    }*/
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=AAAAQIJxVGs:APA91bFPXCjD04Dxfvh8Fa2mHXBynvTHlkr6kROYJapn8PEgCHIFVVTQoDSWVqAbEsN8siqRltnmJTO9Cl0bt4drUaU3120XQ1ZvEKQ-UWmAmv7IIZbVIYbV1RqVGLTRv4Hq8kF_-LjC'
    };
    var request = http.Request('POST', Uri.parse('https://fcm.googleapis.com/fcm/send'));
    request.body = json.encode({
      "registration_ids": [
        token
       ],
      "notification": {
        "body": message,
        "title": title,
        "android_channel_id": "zatcare",
        "sound": true
      }
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print("000 OK");
      print(await response.stream.bytesToString());
    }
    else {
      print("111 ERROR");

      print(response.reasonPhrase);
    }

  }
 }