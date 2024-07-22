import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/hive.dart';
import 'screens/splash_screen.dart';
import 'helpers/colors.dart';
import 'helpers/crud.dart';
import '../helpers/user.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'helpers/notification_service.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _preferencesServices = PreferencesServices();

const notificationChannelId = 'silent_notification_channel';
const notificationId = 6426;

 int periodicSeconds = 30;
 int delayedSeconds = 10;

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  if (service is AndroidServiceInstance) {
      service.setAutoStartOnBootMode(true);
      service.on('setAsForeground').listen((event) {
        service.setAsForegroundService();
      });
      service.on('setAsBackground').listen((event) {
        service.setAsBackgroundService();
      });
    }
    service.on('stopService').listen((event) {
      service.stopSelf();
    });  
  Timer.periodic(Duration(seconds: periodicSeconds), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
    flutterLocalNotificationsPlugin.show(
          notificationId,
          'exChat',
          'Running...',
          const NotificationDetails(
            android: AndroidNotificationDetails(
              notificationChannelId,
              'exChat FOREGROUND SERVICE',
              icon: '@mipmap/ic_launcher',
              color: primaryBGColor,
              playSound: false,
              ongoing: true,
            ),
          ),
        );
   Future.delayed(Duration(seconds: delayedSeconds), () async {
    final sPers = await SharedPreferences.getInstance();
  await sPers.reload();
  final _state = sPers.getString('state') ?? '';
    if(_state != 'opened' && _state != 'resumed' && _state != 'inactive' && _state != 'hidden' && _state != 'paused' && _state != 'signout'){
    await hiveInitialize().then((intReturn) async {
callbackOnStart();
    });
    }
   });
      }
    } 
    final sPersd = await SharedPreferences.getInstance();
  await sPersd.reload();
  final _stated = sPersd.getString('state') ?? '';
    if(_stated != 'opened' && _stated != 'resumed' && _stated != 'inactive' && _stated != 'hidden' && _stated != 'paused' && _stated != 'signout'){
await hiveInitialize().then((intReturn) async {
callbackOnStart();
});
    }
service.invoke('update');
if(periodicSeconds < 50){
        periodicSeconds = periodicSeconds + 3;
        delayedSeconds = delayedSeconds + 1;
      }
  });
}

void callbackOnStart() async {
 try {
  await User().isStream().then((doCall) async {
      if(doCall == true){
     await User().liveListing().then((isDone) {
     });
      }
       });

 } catch (e) {
 print('Error retrieving data: $e');
 }
 }

Future<void> initializeService() async {  
  final service = FlutterBackgroundService();
  
   const AndroidNotificationChannel channel = AndroidNotificationChannel(
    notificationChannelId, // id
    'exChat', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.low, // importance must be at low or higher level
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      notificationChannelId: notificationChannelId, // this must match with notification channel you created above.
      initialNotificationTitle: 'exChat',
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: notificationId,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );

}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}


Future<bool> hiveInitialize() async {

   final _path = await _preferencesServices.getValue('path','string');  
   Hive.init(_path); 
   await Hive.initFlutter();   
   if(!Hive.isAdapterRegistered(0)){
   Hive.registerAdapter(SelfInfoModelAdapter());
   }
   if(!Hive.isAdapterRegistered(1)){
   Hive.registerAdapter(RoomsInfoModelAdapter());
   }
   if(!Hive.isAdapterRegistered(2)){
   Hive.registerAdapter(ChatsInfoModelAdapter());
   }
   if(!Hive.isAdapterRegistered(3)){
   Hive.registerAdapter(MessagesInfoModelAdapter());
   }
   if(!Hive.isAdapterRegistered(4)){
   Hive.registerAdapter(NotificationsInfoModelAdapter());
   }
   if(!Hive.isAdapterRegistered(5)){
   Hive.registerAdapter(UsersInfoModelAdapter());
   }
   if(!Hive.isAdapterRegistered(6)){
   Hive.registerAdapter(TmpInfoModelAdapter());
   }
   if (Hive.isBoxOpen('self')) {
    await Hive.box<SelfInfoModel>('self').close();
    }
    if (Hive.isBoxOpen('rooms')) {
    await Hive.box<RoomsInfoModel>('rooms').close();
    }
    if (Hive.isBoxOpen('chats')) {
    await Hive.box<ChatsInfoModel>('chats').close();
    }
    if (Hive.isBoxOpen('messages')) {
    await Hive.box<MessagesInfoModel>('messages').close();
    }
    if (Hive.isBoxOpen('notifications')) {
    await Hive.box<NotificationsInfoModel>('notifications').close();
    }
    if (Hive.isBoxOpen('users')) {
    await Hive.box<UsersInfoModel>('users').close();
    }
    if (Hive.isBoxOpen('tmp')) {
    await Hive.box<TmpInfoModel>('tmp').close();
    }
    if (Hive.isBoxOpen('data')) {
    await Hive.box('data').close();
    }
   await Hive.openBox<SelfInfoModel>('self');
   await Hive.openBox<RoomsInfoModel>('rooms');
   await Hive.openBox<ChatsInfoModel>('chats');
   await Hive.openBox<MessagesInfoModel>('messages');
   await Hive.openBox<NotificationsInfoModel>('notifications');
   await Hive.openBox<UsersInfoModel>('users');
   await Hive.openBox<TmpInfoModel>('tmp');
   await Hive.openBox('data');

   return true;

}

late Size mq;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final _path = await _preferencesServices.getValue('path','string');
  if(_path == ''){
  final directory = await getApplicationDocumentsDirectory() ;
  final path = directory.path;
  await _preferencesServices.saveValue('path', path, 'string');  
  }
  await hiveInitialize();
  NotificationService.initialize();
  FacebookAudienceNetwork.init();
  await MobileAds.instance.initialize();
  await initializeService();
  //enter full-screen
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

   //for setting orientation to portrait only
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) {
    runApp(const Welcome());
  });

}



class Welcome extends StatelessWidget {
  const Welcome({super.key});

  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(     
        title: 'exChat',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
           textSelectionTheme: const TextSelectionThemeData(
            cursorColor: infoTextColor, 
            selectionColor: highlightTextColor,
            selectionHandleColor: errorTextColor),
        sliderTheme: SliderThemeData(
          trackHeight: 10.0,
          trackShape: const RoundedRectSliderTrackShape(),
          activeTrackColor: activeBGColor,
          inactiveTrackColor: disableBGColor,
          thumbShape: const RoundSliderThumbShape(
            enabledThumbRadius: 14.0,
            pressedElevation: 8.0,
          ),
          thumbColor: quaternaryBGColor,
          overlayColor: quaternaryBGColor.withOpacity(0.2),
          overlayShape: const RoundSliderOverlayShape(overlayRadius: 32.0),
          tickMarkShape: const RoundSliderTickMarkShape(),
          activeTickMarkColor: activeBGColor,
          inactiveTickMarkColor: disableBGColor,
          valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
          valueIndicatorColor: highlightBGColor,
          valueIndicatorTextStyle: const TextStyle(
            color: primaryTextColor,
            fontSize: 14.0,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
         prefixIconColor: WidgetStateColor.resolveWith(
                 (Set<WidgetState> states) {
               if (states.contains(WidgetState.focused)) {
                 return quaternaryBGColor;
               }
               if (states.contains(WidgetState.error)) {
                 return errorBGColor;
               }
               return primaryTextColor;
             },
         ),
          labelStyle: const TextStyle(color: primaryTextColor),
          floatingLabelStyle: const TextStyle(
            color: quaternaryBGColor,
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: primaryTextColor),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              style: BorderStyle.solid,
              color: highlightBGColor,
            ),
          ),
        ),
        scaffoldBackgroundColor: primaryBGColor,
        appBarTheme: const AppBarTheme(
          toolbarHeight: 45.0,
          color: secondaryBGColor,
        ),
      ),
        home: const SplashScreen());
  }
}

