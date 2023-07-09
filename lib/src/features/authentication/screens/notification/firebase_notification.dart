import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> handlemessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

class FirebaseApi {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    String? fCMToken = await _firebaseMessaging.getToken();
    print('FCM Token: $fCMToken');
    FirebaseMessaging.onBackgroundMessage(handlemessage);
  }
}
