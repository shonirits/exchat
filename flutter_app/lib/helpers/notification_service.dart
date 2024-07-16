import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'colors.dart';
import 'crud.dart';


class NotificationService {


 static final _notification = FlutterLocalNotificationsPlugin();

  static initialize() {

    _notification.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings()
      ));  
    }


    static pushNotification({required int id, required String title, required String body}) async {

      final _dataServices = DataServices();

      final getScreen = await _dataServices.getValue('screen');

      var androidDetails = const AndroidNotificationDetails(
        'important_notification_channel', 
        'My Notification Channel',
        importance: Importance.max,
        priority: Priority.high,
        sound: RawResourceAndroidNotificationSound('notification'),
        color: primaryBGColor,
        playSound: true,
        );

      var iosDetails = const DarwinNotificationDetails();

      var notificationDetails = NotificationDetails(android: androidDetails, iOS: iosDetails);

      if(getScreen != 'notification'){
      await _notification.show(id, title, body, notificationDetails);
      }

    }


    static pushMessage({required int id, required String title, required String body}) async {

      final _dataServices = DataServices();

      final getScreen = await _dataServices.getValue('screen');

      var androidDetails = const AndroidNotificationDetails(
        'important_message_channel', 
        'My Message Channel',
        importance: Importance.max,
        priority: Priority.high,
        sound: RawResourceAndroidNotificationSound('message'),
        color: primaryBGColor,
        playSound: true,
        );

      var iosDetails = const DarwinNotificationDetails();

      var notificationDetails = NotificationDetails(android: androidDetails, iOS: iosDetails);

      if(getScreen != id.toString()){
      await _notification.show(id, title, body, notificationDetails);
      }

    }


     static pushSilent({required int id, required String title, required String body}) async {

      var androidDetails = const AndroidNotificationDetails(
        'silent_notification_channel', 
        'My Silent Notification Channel',
        importance: Importance.min,
        priority: Priority.low,
        color: primaryBGColor,
        playSound: false,
        ongoing: true,
        );

      var iosDetails = const DarwinNotificationDetails();

      var notificationDetails = NotificationDetails(android: androidDetails, iOS: iosDetails);

      await _notification.show(id, title, body, notificationDetails);

    }

}
