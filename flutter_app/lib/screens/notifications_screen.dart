
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/hive.dart';
import '../../main.dart';
import '../helpers/colors.dart';
import '../widgets/notifications/chat_accept.dart';
import '../widgets/notifications/chat_request.dart';
import '../helpers/user.dart';
import 'splash_screen.dart';
import 'mobile_layout_screen.dart';
import '../helpers/dialogs.dart';
import '../helpers/crud.dart';

class NotificationsScreen extends StatefulWidget {
  final selfInfo;
  const NotificationsScreen({super.key, this.selfInfo});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {

  final _dataServices = DataServices();

   @override
  void initState() {
    super.initState();
    _loadDefault().then((loadDefault_value) async {

      await _dataServices.saveValue('screen', 'notification');

      //for showing progress bar
    Dialogs.showProgressBar(context);

    await User().is_signed_in().then((isSignedIn) async {

      if (isSignedIn != true) { 

      User().sign_out().then((signOut) {                            
                //navigate to login screen
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => const SplashScreen()),
                (route) => false
        );

      });

            return null;

      }else{

      //for hiding progress bar
       Navigator.pop(context);

      }

    });

    }); 
  }

  @override
void setState(VoidCallback fn){
  if(mounted){
    super.setState(fn);
  }
}

  Future<dynamic> _loadDefault() async{

    await Hive.openBox<SelfInfoModel>('self');
    await Hive.openBox<RoomsInfoModel>('rooms');
    await Hive.openBox<ChatsInfoModel>('chats');
    await Hive.openBox<MessagesInfoModel>('messages');
    await Hive.openBox<NotificationsInfoModel>('notifications');
    await Hive.openBox<UsersInfoModel>('users');
    await Hive.openBox<TmpInfoModel>('tmp');
    await Hive.openBox('data');

  }

  



 @override
  Widget build(BuildContext context) {
    //initializing media query (for getting device screen size)
    mq = MediaQuery.of(context).size;

    final _selfInfo = widget.selfInfo;

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: PopScope(  
        canPop: false,      
        onPopInvoked: (_) async {          
            Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => MobileLayoutScreen()));
        },
        //
        child: Scaffold(
          //app bar
          appBar: AppBar(
            automaticallyImplyLeading: true,
            backgroundColor: quaternaryBGColor,            
            elevation: 0,           
            centerTitle: false,
            title: const Text('Notifications', style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Oswald',
                      fontWeight: FontWeight.bold,
                  color: primaryTextColor
                  )),      
          ),

          backgroundColor: secondaryTextColor,

          //body
          body: SafeArea(
            child: SingleChildScrollView(
          child: ValueListenableBuilder<Box<NotificationsInfoModel>>(
        valueListenable: NotificationsBox.getData().listenable(),
        builder: (context,box ,_){

          var data = box.values.toList().cast<NotificationsInfoModel>();

          return  ListView.builder(
                itemCount: box.length,
                reverse: true,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index){

                  var notification = data[index];

                if(notification.parentType == 'chat_accept'){  

                return ChatAcceptCard(id: index, notification: notification, selfInfo: _selfInfo);

                }else if(notification.parentType == 'chat_request'){  

                return ChatRequestCard(id: index, notification: notification, selfInfo: _selfInfo);

                }else{

                  return Text('Unknown Notification');

                }
              }            
          );

        },
          )        
          ),
          ),
        ),
      ),
    );
  }
}