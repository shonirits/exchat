import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/hive.dart';
import '../common/config.dart';
import '../../main.dart';
import '../helpers/colors.dart';
import '../helpers/user.dart';
import '../helpers/crud.dart';
import 'login_screen.dart';
import 'mobile_layout_screen.dart';
import 'package:permission_handler/permission_handler.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final _dataServices = DataServices();  
  final _preferencesServices = PreferencesServices();

   @override
  void initState() {
    super.initState();
    _loadDefault().then((loadDefault_value) async {

    await _dataServices.saveValue('screen', 'splash');

    if (!await Permission.location.isGranted) {
    await Permission.location.request();
    }

    if (!await Permission.notification.isGranted) {
    await Permission.notification.request();
    }


    Future.delayed(const Duration(seconds: 2), () {
      //exit full-screen
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          systemNavigationBarColor: primaryBGColor,
          statusBarColor: primaryBGColor));

            User().is_signed_in().then((status) {

              Future.delayed(Duration.zero, () async {

              if (status == true) {        
        //navigate to home screen

              final chatBox = ChatsBox.getData();
              final isChatExist = chatBox.values.where((elementChat) => elementChat.chatId == null);
              if(isChatExist.isNotEmpty){
                for (var chat in isChatExist) {
                  final chatKey = chat.key;                  
                  User().deleteChat(chatKey);
                }          
               }

               final userBox = UsersBox.getData();
              final isUserExist = userBox.values.where((elementUser) => elementUser.userId == null);
              if(isUserExist.isNotEmpty){
                for (var user in isUserExist) {
                  final userKey = user.key;                  
                  User().deleteUser(userKey);
                }         
                }

              final messageBox = MessagesBox.getData();
              final isMessageExist = messageBox.values.where((elementMessage) => elementMessage.messageId == null);
              if(isMessageExist.isNotEmpty){
                for (var message in isMessageExist) {
                  final messageKey = message.key;                  
                  User().deleteMessage(messageKey);
                }         
                }

              final notificationBox = NotificationsBox.getData();
              final isNotificationExist = notificationBox.values.where((elementNotification) => elementNotification.notificationId == null);
              if(isNotificationExist.isNotEmpty){
                for (var notification in isNotificationExist) {
                  final notificationKey = notification.key;                  
                  User().deleteNotification(notificationKey);
                }         
                }

                final tmpBox = TmpBox.getData();
                final isTmpExist = tmpBox.values.where((elementTmp) => elementTmp.tmpId == null);
                if(isTmpExist.isNotEmpty){
                  for (var tmp in isTmpExist) {
                    final tmpKey = tmp.key;                  
                    User().deleteTmp(tmpKey);
                  }         
                  }

              final roomBox = RoomsBox.getData();
              final isRoomExist = roomBox.values.where((elementRoom) => elementRoom.roomId == null);
              if(isRoomExist.isNotEmpty){
                for (var room in isRoomExist) {
                    final roomKey = room.key;                  
                    User().deleteRoom(roomKey);
                  }  
              }

              final selfBox = SelfBox.getData();
              final isSelfExist = selfBox.values.where((elementSelf) => elementSelf.userId == null);
              if(isSelfExist.isNotEmpty){
                for (var self in isSelfExist) {
                    final selfKey = self.key;                  
                    User().deleteSelf(selfKey);
                  }  
              }

                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => MobileLayoutScreen()),
                        (route) => false
                );

      } else {
        //navigate to login screen
        await _preferencesServices.saveValue('state', 'logout', 'string'); 
        await _preferencesServices.saveValue('is_logged_in', false, 'bool');
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => LoginScreen()),
                        (route) => false
                );

      }
      });

      });

      });
         
    });
  }

  Future<dynamic> _loadDefault() async{

    await Hive.openBox<SelfInfoModel>('self');
    await Hive.openBox<RoomsInfoModel>('rooms');
    await Hive.openBox<ChatsInfoModel>('chats');
    await Hive.openBox<MessagesInfoModel>('messages');
    await Hive.openBox<NotificationsInfoModel>('notifications');
    await Hive.openBox<UsersInfoModel>('users');
    await Hive.openBox<TmpInfoModel>('tmp');

  }

  @override
void setState(VoidCallback fn){
  if(mounted){
    super.setState(fn);
  }
}

  

 @override
  Widget build(BuildContext context) {
    //initializing media query (for getting device screen size)
    mq = MediaQuery.of(context).size;

    return Scaffold(
      //body
      body: Stack(children: [
        //app logo
        Positioned(
            top: mq.height * .15,
            right: mq.width * .25,
            width: mq.width * .5,
            child: Image.asset('media/images/splash-screen-logo.png')),

        //google login button
        Positioned(
            bottom: mq.height * .15,
            width: mq.width,
            child: const Text(appVersion,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12, color: quaternaryTextColor, letterSpacing: .3))),
      ]),
    );
  }
}