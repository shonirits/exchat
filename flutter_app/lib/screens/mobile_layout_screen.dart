import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/hive.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../common/config.dart';
import '../../main.dart';
import '../helpers/colors.dart';
import '../models/api.dart';
import '../helpers/api.dart';
import '../helpers/dialogs.dart';
import '../helpers/common.dart';
import '../helpers/user.dart';
import 'splash_screen.dart';
import '../widgets/nearby.dart';
import '../widgets/rooms.dart';
import '../widgets/chats.dart';
import 'profile_screen.dart';
import 'notifications_screen.dart';
import '../helpers/crud.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import '../helpers/notification_service.dart';


class MobileLayoutScreen extends StatefulWidget {
  final AdSize adSize;
  final String adUnitId = Platform.isAndroid
  // Use this ad unit on Android...
      ? androidAdId
  // ... or this one on iOS.
      : iosAdId;

  final bool isAds = Platform.isAndroid || Platform.isIOS;

final String adUnitIdMain = Platform.isAndroid
  // Use this ad unit on Android...
      ? androidAdIdMain
  // ... or this one on iOS.
      : iosAdIdMain;
  MobileLayoutScreen({super.key, this.adSize = AdSize.banner,});

  @override
  State<MobileLayoutScreen> createState() => _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends State<MobileLayoutScreen> with WidgetsBindingObserver {

  late final AppLifecycleListener _listener;
  final _preferencesServices = PreferencesServices();
  final _dataServices = DataServices();
  final NotificationService notifService = NotificationService();
  BannerAd? _bannerAd;
  BannerAd? _bannerAdMain;

  SelfInfoModel? selfInfo;
  int currentPageIndex = 0;
  int unreadChats = 0;
  int newNotifications = 0;
  bool _isConnected = false;
  late Timer _timer;
  final int _seconds = 7;
  late String _latitude = '';
  late String _longitude = '';
  final bool _isProgressBar = true;
  String _appBadgeSupported = 'Unknown';
  int totalUnReadMessage = 0;
  int totalUnSeenNotification = 0;

  

   @override
  void initState() {
     super.initState();
     _listener = AppLifecycleListener(
      onStateChange: _onStateChanged,
    );
     initPlatformState();
     
     _loadDefault().then((loadDefaultValue) async {

       await _dataServices.saveValue('isFree', 'false');

       Future.delayed(Duration.zero, () {
    //for showing progress bar
    Dialogs.showProgressBar(context);
      
     _timer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      activeTimer(_isProgressBar).then((activeTimerValue) {
     }); 
        
        });

    }); 

    });
    _loadAdMain();
     _loadAd();     
  }

  initPlatformState() async {
    String appBadgeSupported;
    try {
      bool res = await FlutterAppBadger.isAppBadgeSupported();
      if (res) {
        appBadgeSupported = 'Supported';
      } else {
        appBadgeSupported = 'Not supported';
      }
    } on PlatformException {
      appBadgeSupported = 'Failed to get badge support.';
    }

    if (!mounted) return;

    setState(() {
      _appBadgeSupported = appBadgeSupported;
    });
  }

@override
void setState(VoidCallback fn){
  if(mounted){
    super.setState(fn);
  }
}

  @override
  void dispose() {
    _listener.dispose();
    if (_timer.isActive) _timer.cancel();
    _bannerAd?.dispose();
    _bannerAdMain?.dispose();
    super.dispose();
  }

 Future<void> _onStateChanged(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.detached:
      await _preferencesServices.saveValue('state', 'detached', 'string'); 
      case AppLifecycleState.resumed:
      await _preferencesServices.saveValue('state', 'resumed', 'string'); 
      case AppLifecycleState.inactive:
      await _preferencesServices.saveValue('state', 'inactive', 'string'); 
      case AppLifecycleState.hidden:
      await _preferencesServices.saveValue('state', 'hidden', 'string'); 
      case AppLifecycleState.paused:
      await _preferencesServices.saveValue('state', 'paused', 'string'); 
    }
  }


   void _addBadge(totalBadge) {
    FlutterAppBadger.updateBadgeCount(totalBadge);
  }

  void _removeBadge() {
    FlutterAppBadger.removeBadge();
  }

  void _loadAd() {
    if( widget.isAds != true ){ return; }
    final bannerAd = BannerAd(
      size: widget.adSize,
      adUnitId: widget.adUnitId,
      request: const AdRequest(),
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, error) {
          debugPrint('BannerAd failed to load: $error');
          ad.dispose();
        },
      ),
    );

    // Start loading.
    bannerAd.load();
  }

  void _loadAdMain() {
     if( widget.isAds != true ){ return; }
    final bannerAdMain = BannerAd(
      size: widget.adSize,
      adUnitId: widget.adUnitIdMain,
      request: const AdRequest(),
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() {
            _bannerAdMain = ad as BannerAd;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, error) {
          debugPrint('BannerAdMain failed to load: $error');
          ad.dispose();
        },
      ),
    );

    // Start loading.
    bannerAdMain.load();
  }

  Future<bool> activeTimer(_isProgressBar) async {

     _timer.cancel();

      if(_isProgressBar == true) {
        setState(() {_isProgressBar=false;});
        Future.delayed(Duration.zero, () {
          //for hiding progress bar
          Navigator.pop(context);
        });
      }

     await User().isStream().then((doCall) async {

      if(doCall == true){

     await User().liveListing().then((isDone) async {

      setState(() {
                  _isConnected = isDone;
                });

      _timer = Timer.periodic(Duration(seconds: _seconds), (timer) {
     activeTimer(_isProgressBar);
        });


     });

      }else{

        _timer = Timer.periodic(Duration(seconds: _seconds), (timer) {
     activeTimer(_isProgressBar);
        });

      }

        });

  return true;

  }


  Future<dynamic> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    Dialogs.showSnackbar(context, 'Location services are disabled.', errorBGColor, errorTextColor);
    return 'Location services are disabled.';
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      Dialogs.showSnackbar(context, 'Location permissions are denied', errorBGColor, errorTextColor);
      return 'Location permissions are denied';
    }
  }
  
  if (permission == LocationPermission.deniedForever) {
    Dialogs.showSnackbar(context, 'Location permissions are permanently denied, we cannot request permissions.', errorBGColor, errorTextColor);
    return 'Location permissions are permanently denied, we cannot request permissions.';
  } 

try {
   Position? position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high, timeLimit: const Duration(seconds: 5));
   if(position != null){  
 setState(() {
_latitude = position.latitude.toString();
_longitude = position.longitude.toString();
   });
}
  } catch (e) {
    Position? position = await Geolocator.getLastKnownPosition();
    if(position != null){  
 setState(() {
_latitude = position.latitude.toString();
_longitude = position.longitude.toString();
   });
}
  }

  return true;
}


  Future<dynamic> _loadDefault() async{

    await _preferencesServices.saveValue('state', 'opened', 'string');
    final getScreen = await _dataServices.getValue('screen');
    
   await Hive.openBox<SelfInfoModel>('self');
   await Hive.openBox<RoomsInfoModel>('rooms');
   await Hive.openBox<ChatsInfoModel>('chats');
   await Hive.openBox<MessagesInfoModel>('messages');
   await Hive.openBox<NotificationsInfoModel>('notifications');
   await Hive.openBox<UsersInfoModel>('users');
   await Hive.openBox<TmpInfoModel>('tmp');
   await Hive.openBox('data');

    await User().is_signed_in().then((isSignedIn) async {

      if(getScreen == 'splash'){
        await _dataServices.saveValue('screen', 'layout');
      }else{
        await _dataServices.saveValue('screen', 'layout');
      }

      if (isSignedIn != true) { 

      User().sign_out().then((signOut) {                            
                //navigate to login screen
        Navigator.pushReplacement(
            context, MaterialPageRoute(
              builder: (_) => const SplashScreen()
              )
            );
            });

            return null;

      }else{

        final watchNotificationBox = NotificationsBox.getData();   

              final isNewNotificationExist = watchNotificationBox.values.where((elementNotification) => elementNotification.notificationStatus == '0');

               if(isNewNotificationExist.isNotEmpty){

                setState(() {
                  newNotifications = isNewNotificationExist.length;
                  totalUnSeenNotification = newNotifications;
                  
                });                              

                }else{
                  setState(() {
                  newNotifications = 0;
                  totalUnSeenNotification = newNotifications;
                });

                _addBadge(totalUnSeenNotification+totalUnReadMessage);

                }

               watchNotificationBox.listenable().addListener(() async {

              final isNewNotificationExist = watchNotificationBox.values.where((elementNotification) => elementNotification.notificationStatus == '0');

               if(isNewNotificationExist.isNotEmpty){

                setState(() {
                  newNotifications = isNewNotificationExist.length;
                  totalUnSeenNotification = newNotifications;
                });                              

                }else{

                  setState(() {
                  newNotifications = 0;
                  totalUnSeenNotification = newNotifications;
                });

                }

                _addBadge(totalUnSeenNotification+totalUnReadMessage);

               }); 

        await User().self_info().then((selfInfoValue) async {

                if(selfInfoValue != null){

           selfInfo = selfInfoValue;

              setState(() {
                selfInfo = selfInfoValue;
               });

      Future.delayed(const Duration(milliseconds: 500), () async {

           final watchUnreadMessagesBox = MessagesBox.getData();

           final isNewMessageExist = watchUnreadMessagesBox.values.where((elementNewMessage) => elementNewMessage.userId != selfInfo?.userId && elementNewMessage.messageStatus != '3');

           if(isNewMessageExist.isNotEmpty){

             setState(() {
               unreadChats = isNewMessageExist.length;
               totalUnReadMessage = unreadChats;
             });

           }else{

             setState(() {
               unreadChats = 0;
               totalUnReadMessage = unreadChats;
             });

           }

           _addBadge(totalUnSeenNotification+totalUnReadMessage);

               watchUnreadMessagesBox.listenable().addListener(() async {

              final isNewMessageExist = watchUnreadMessagesBox.values.where((elementNewMessage) => elementNewMessage.userId != selfInfo?.userId && elementNewMessage.messageStatus != '3');

               if(isNewMessageExist.isNotEmpty){

                setState(() {
                  unreadChats = isNewMessageExist.length;
                  totalUnReadMessage = unreadChats;
                });

                }else{

                  setState(() {
                  unreadChats = 0;
                  totalUnReadMessage = unreadChats;
                });

                }

                _addBadge(totalUnSeenNotification+totalUnReadMessage);

                 });

           _determinePosition().then((getPermission) async {

            await User().isConnected(selfInfo, _latitude, _longitude).then((connectedValue) async {

              Future.delayed(Duration.zero, () async { 

                await _dataServices.saveValue('isFree', 'true');  

                });

               setState(() {
                  _isConnected = connectedValue;
                });

              if(connectedValue == true) {

                await _dataServices.saveValue('isFree', 'false');

               await _loadInitialize().then((initializeValue) async { 

                Future.delayed(Duration.zero, () async { 

                await _dataServices.saveValue('isFree', 'true');  

                });            

                final watchMessagesBox = MessagesBox.getData();  
              
                final isUnSendMessageExist = watchMessagesBox.values.where((elementMessage) => elementMessage.messageStatus == '0'); 

                if(isUnSendMessageExist.isNotEmpty){

                  await _dataServices.saveValue('isFree', 'false');

                  final unSendMessageRow =  isUnSendMessageExist.first;
                  final pendingMessage = unSendMessageRow;
                  unSendMessageRow.messageStatus = '4';
                  unSendMessageRow.save();

              Future.delayed(const Duration(milliseconds: 100), () async {
                  await User().sendMessage(pendingMessage, selfInfo).then((isSendMessage) {

                  if(isSendMessage != null){

                    if(isSendMessage != false){

                  unSendMessageRow.messageId = isSendMessage.toString();
                  unSendMessageRow.messageStatus = '1';
                  unSendMessageRow.save();

                    }else{

                      unSendMessageRow.delete();

                    }

                   }else{

                    Future.delayed(const Duration(milliseconds: 25), () async {
                    unSendMessageRow.messageStatus = '0';
                    unSendMessageRow.save();
                    });

                  }

                  Future.delayed(Duration.zero, () async {

                    await _dataServices.saveValue('isFree', 'true');

                });

                });

                });

                }
               

                final watchTmpBox = TmpBox.getData();
                            
                  final watchTmpExist = watchTmpBox.values.where((elementTmp) => elementTmp.status == '0');

                if(watchTmpExist.isNotEmpty){

                  await _dataServices.saveValue('isFree', 'false');

                  final watchTmpRow =  watchTmpExist.first;
                  final pendingTmp = watchTmpRow;
                  watchTmpRow.status = '1';
                  watchTmpRow.save();

                  Future.delayed(const Duration(milliseconds: 100), () async {

                  await User().sendTmpInfo(pendingTmp, selfInfo).then((isSendTmp) {

                  if(isSendTmp != false ){

                  watchTmpRow.delete();

                   }else{
                    Future.delayed(const Duration(milliseconds: 25), () async {
                    watchTmpRow.status = '0';
                    watchTmpRow.save();
                    });

                  }

                Future.delayed(Duration.zero, () async {

                  await _dataServices.saveValue('isFree', 'true');

                });

                });

                });

                }              
        
               return 'done';

               });

              }

               });

                });


                Future.delayed(const Duration(milliseconds: 300), () async {

                final watchMessagesBox = MessagesBox.getData(); 
        
                watchMessagesBox.listenable().addListener(() async {

                    Future.delayed(const Duration(milliseconds: 25), () async {

                final isUnSendMessageExist = watchMessagesBox.values.where((elementMessage) => elementMessage.messageStatus == '0');

                if(isUnSendMessageExist.isNotEmpty){

                  await _dataServices.saveValue('isFree', 'false');

                  Future.delayed(const Duration(milliseconds: 100), () async {

                  int unSendMessageLength = isUnSendMessageExist.length;

                  if(unSendMessageLength > 0){
                    
                  int unSendMessagerand = getRand(unSendMessageLength);

                  final unSendMessageRow =  isUnSendMessageExist.elementAt(unSendMessagerand);
                  final pendingMessage = unSendMessageRow;
                  unSendMessageRow.messageStatus = '4';
                  unSendMessageRow.save();

              Future.delayed(const Duration(milliseconds: 100), () async {

                await User().isConnected(selfInfo, _latitude, _longitude).then((connectedValue) async {

                  Future.delayed(Duration.zero, () async { 

                await _dataServices.saveValue('isFree', 'true');  

                });

               setState(() {
                  _isConnected = connectedValue;
                });

                  if(connectedValue == true) {

                    await _dataServices.saveValue('isFree', 'false');

                  await User().sendMessage(pendingMessage, selfInfo).then((isSendMessage) {

                  if(isSendMessage != null){

                  if(isSendMessage != false){

                  unSendMessageRow.messageId = isSendMessage.toString();
                  unSendMessageRow.messageStatus = '1';
                  unSendMessageRow.save();

                  }else{

                    unSendMessageRow.delete();

                  }

                   }else{
                    Future.delayed(const Duration(milliseconds: 25), () async {
                    unSendMessageRow.messageStatus = '0';
                    unSendMessageRow.save();
                    });
                  }

                  Future.delayed(Duration.zero, () async {

                    await _dataServices.saveValue('isFree', 'true');

                });

                });

              }else{

                 Future.delayed(const Duration(milliseconds: 25), () async {
                    unSendMessageRow.messageStatus = '0';
                    unSendMessageRow.save();
                    });

              }

                  });

                });

                  }

                });

                }
                    });
 

               }); 

               }); 


                 Future.delayed(const Duration(milliseconds: 300), () async {  

                  final watchTmpBox = TmpBox.getData();     
                
                watchTmpBox.listenable().addListener(() async {

                Future.delayed(const Duration(milliseconds: 25), () async { 

                final watchTmpExist = watchTmpBox.values.where((elementTmp) => elementTmp.status == '0');

                if(watchTmpExist.isNotEmpty){

                  await _dataServices.saveValue('isFree', 'false');

                  Future.delayed(const Duration(milliseconds: 100), () async {

                  int watchTmpLength = watchTmpExist.length;

                  if(watchTmpLength > 0){

                  int watchTmprand = getRand(watchTmpLength);

                  final watchTmpRow =  watchTmpExist.elementAt(watchTmprand);
                  final pendingTmp = watchTmpRow;
                  watchTmpRow.status = '1';
                  watchTmpRow.save();

                  Future.delayed(const Duration(milliseconds: 100), () async {

                 await User().isConnected(selfInfo, _latitude, _longitude).then((connectedValue) async {

                   Future.delayed(Duration.zero, () async { 

                await _dataServices.saveValue('isFree', 'true');  

                });

               setState(() {
                  _isConnected = connectedValue;
                });

                   if(connectedValue == true) {

                    await _dataServices.saveValue('isFree', 'false');

                  await User().sendTmpInfo(pendingTmp, selfInfo).then((isSendTmp) {

                  if(isSendTmp != false ){

                  watchTmpRow.delete();

                   }else{

                    Future.delayed(const Duration(milliseconds: 25), () async {

                    watchTmpRow.status = '0';
                    watchTmpRow.save();

                    });

                  }

                Future.delayed(Duration.zero, () async {

                  await _dataServices.saveValue('isFree', 'true');

                });

                });

                  }else{

                    Future.delayed(const Duration(milliseconds: 25), () async {

                    watchTmpRow.status = '0';
                    watchTmpRow.save();

                    });


                  }

                  });

                });

                  }

                });

                }

                });

               

              });

                });

                });

                }else{

                 Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const SplashScreen()));

            return null;

                }
              
              });

      }

       });

  }

  Future<dynamic> _loadInitialize() async {

        if(selfInfo != null){

          await _dataServices.saveValue('isFree', 'false'); 

          final getInitialize = await Api().getUrl('${apiUrl}chat?app_public_key=$apiPublicKey&app_secret_key=$apiSecretKey&user_public_key=${selfInfo!.publicKey}&user_secret_key=${selfInfo!.secretKey}&do=rooms');

          if(getInitialize != null){

          final jSonInitialize = initializeChatFromJson(getInitialize);

           final intRooms = jSonInitialize.data!.rooms;

           if(intRooms != null){

          final allRooms = intRooms!.entries;

          if(allRooms.isNotEmpty){ 

            for (MapEntry<String, Room> room in allRooms) {

             User.roomsUpdate(room, selfInfo);
              
            }           

          }
          
          }

          // final intChats = _Initialize.data!.chats;

          //  if(intChats != null){

          // final allChats = intChats!.entries;

          // if(allChats.isNotEmpty){ 

          //   for (MapEntry<String, Chat> chat in allChats) {

          //    // _chatsUpdate(chat);
              
          //   }           

          // }
          
          // }


          //  final intUsers = _Initialize.data!.users;

          //  if(intUsers != null){

          // final allUsers = intUsers!.entries;

          // if(allUsers.isNotEmpty){ 

          //   for (MapEntry<String, Recipient> user in allUsers) {

          //   //  _usersUpdate(user);
              
          //   }           

          // }
          
          // }



          // final intMChat = _Initialize.data!.messages;

          //  if(intMChat != null){

          // final allMChat = intMChat!.entries;

          // if(allMChat.isNotEmpty){  

          //   for (MapEntry<String, List<Message>> mChat in allMChat) {

          //    final allMessages =  mChat.value!;

          //    if(allMessages.isNotEmpty){   

          //     allMessages.forEach((message) {

          //       //_messagesUpdate(message);                 

          //     });      


          //    }             
              
          //   }           

          // }
          
          // }

          }

           Future.delayed(Duration.zero, () async { 

                await _dataServices.saveValue('isFree', 'true');  

                });

          return 'done';
          
        }else{
          return null;
        }

      }


      Future<dynamic> _loadNearBy() async {

     if(currentPageIndex == 1){

        if(selfInfo != null){

          try {

        final getNearBy = await Api().getUrl('${apiUrl}chat?app_public_key=$apiPublicKey&app_secret_key=$apiSecretKey&user_public_key=${selfInfo!.publicKey}&user_secret_key=${selfInfo!.secretKey}&do=nearby');

        if (getNearBy != null) { 

          return nearByUsersFromJson(getNearBy);         

        }else{

        return Future.error('Server unable to complete request');

        }

      } catch (e) {

        return Future.error('Something Went Wrong (Check Internet!)');

      }          
        
        }else{

          return Future.error('Request not completed');

        }

      }else{

  return null;

  }

      }


      void handleClick(int item, selfInfo) {
  switch (item) {
    case 0:

    Navigator.push(
             context,
              MaterialPageRoute(
                            builder: (_) => ProfileScreen(selfInfo: selfInfo)
             )
            );

      break;
    case 1:
    User().sign_out();
    Navigator.pushReplacement(
    context, MaterialPageRoute(builder: (_) => const SplashScreen()));
      break;
  }
}

Widget bannerAdWidget() {
    return StatefulBuilder(
      builder: (context, setState) => Container(
        width: widget.adSize.width.toDouble(),
        height: widget.adSize.height.toDouble(),
        alignment: Alignment.center,
        child: _bannerAd == null || widget.isAds != true
                          // Nothing to render yet.
                              ? CachedNetworkImage(
                          imageUrl: '${uploadUrl}ads/main.png',
                          placeholder: (context, url) => const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.image, size: 70),
                        )
                          // The actual ad.
                              : AdWidget(ad: _bannerAd!),
      ),
    );
  }

  Widget bannerAdMainWidget() {
    return StatefulBuilder(
      builder: (context, setState) => Container(
        width: widget.adSize.width.toDouble(),
      height: widget.adSize.height.toDouble(),
        alignment: Alignment.center,
        child: _bannerAdMain == null || widget.isAds != true
                          // Nothing to render yet.
                              ? CachedNetworkImage(
                          imageUrl: '${uploadUrl}ads/main.png',
                          placeholder: (context, url) => const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.image, size: 70),
                        )
                          // The actual ad.
                              : AdWidget(ad: _bannerAdMain!),
      ),
    );
  }

 @override
  Widget build(BuildContext context) {

 
    //initializing media query (for getting device screen size)
    mq = MediaQuery.of(context).size;

    return Scaffold(
      bottomNavigationBar: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: NavigationBar(
          height: 65,
          backgroundColor: quaternaryBGColor,
          elevation: 0,
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          indicatorColor: highlightTextColor,
          selectedIndex: currentPageIndex,
          
          destinations: <Widget>[
            NavigationDestination(
              icon: (unreadChats > 0) ? Badge(
                label: Text(unreadChats.toString()),
                child: const FaIcon(
                FontAwesomeIcons.comment,
                size: 25,
              ),
              ): const FaIcon(
                FontAwesomeIcons.comment,
                size: 25,
              ),
              label: 'Chats',
            ),
            const NavigationDestination(
              icon: FaIcon(
                FontAwesomeIcons.locationCrosshairs,
                size: 25,
              ),
              label: 'NearBy',
            ),
            const NavigationDestination(
              icon: FaIcon(
                FontAwesomeIcons.peopleGroup,
                size: 25,
              ),
              label: 'Rooms',
            ),
          ],
        ),
      ),
      body: <Widget>[
        /// Home page
        GestureDetector(
      //for hiding keyboard when a tap is detected on screen
      onTap: FocusScope.of(context).unfocus,
      child: PopScope(
        child: Scaffold(
          //app bar
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text('exChat', style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Oswald',
                      fontWeight: FontWeight.bold,
                  color: logoColor
                  )),
            actions: <Widget>[
              IconButton(
      onPressed: () async { 
        Navigator.push(
             context,
              MaterialPageRoute(
                            builder: (_) => NotificationsScreen(selfInfo: selfInfo)
             )
            );
      },
      icon: (newNotifications > 0) ? Badge(
                label: Text(newNotifications.toString()),
                child: const FaIcon(
                FontAwesomeIcons.bell,
                size: 20,
              ),
              ): const FaIcon(
                FontAwesomeIcons.bell,
                size: 20,
              ),
    ),
      PopupMenuButton<int>(
          onSelected: (item) => handleClick(item, selfInfo),
          itemBuilder: (context) => [
            const PopupMenuItem<int>(value: 0, child: Text('Profile')),
            const PopupMenuItem<int>(value: 1, child: Text('Logout')),
          ],
        ),
          ],
          ),
          //body
          body: ValueListenableBuilder<Box<ChatsInfoModel>>(
        valueListenable: ChatsBox.getData().listenable(),
        builder: (context,box ,_){
           var data = box.values.toList().cast<ChatsInfoModel>();

          data.sort((a, b) {
            var atime = DateTime.parse(localTimeFull(a.lastMessageAt!)).microsecondsSinceEpoch;
            var btime = DateTime.parse(localTimeFull(b.lastMessageAt!)).microsecondsSinceEpoch;
            return btime.compareTo(atime);
          });

          return  ListView.builder(
                itemCount: box.length,
                reverse: false,
                shrinkWrap: true,
                itemBuilder: (context, index){
                  if(index == 0){
                  return Column(
                    children: [
                      SafeArea(
                        child: bannerAdMainWidget(),
                      ),
                      ChatsCard(id: index, chat: data[index], selfInfo: selfInfo),
                    ],
                  );
                  }else{
                return ChatsCard(id: index, chat: data[index], selfInfo: selfInfo);
                  }                  
              }            
          );

        },
          ),     
        ),
        )
      ),

        /// NearBy page
        GestureDetector(
      //for hiding keyboard when a tap is detected on screen
      onTap: FocusScope.of(context).unfocus,
      child: PopScope(
        child: Scaffold(
          //app bar
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text('Online users near to you', style: TextStyle(
                      fontSize: 17,
                      fontFamily: 'Oswald',
                      fontWeight: FontWeight.bold,
                  color: secondaryTextColor
                  )),
            actions: [            
              //more features button
              IconButton(
                tooltip: 'Update Location',
                  onPressed: () {
                    
                   //for showing progress bar
              Dialogs.showProgressBar(context);
      
     _determinePosition().then((getPermission) async { 

     //for hiding progress bar
      Navigator.pop(context);

     });
                   
       },
                  icon: const FaIcon(
                FontAwesomeIcons.locationCrosshairs,
                size: 15,
              ))
            ],
          ),
          //body
          body: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(0.01),
          children: [
      SingleChildScrollView(
      child: Form(
      child: Center(
          child: FutureBuilder(
        future: _loadNearBy(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            
            var data = snapshot.data!.data;
            var nearby = data!.nearby;

            if( nearby.length >0 ){

            return ListView.builder(
                                itemCount: nearby.length,
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {

                                  if(index == 0){
                  return Column(
                    children: [
                      SafeArea(
                        child: bannerAdWidget(),
                      ),
                      NearByUserCard(user: nearby[index], selfInfo: selfInfo),
                    ],
                  );
                  }else{
                return  NearByUserCard(user: nearby[index], selfInfo: selfInfo);
                  } 

                      });

            }else{

              return  Column(
                    children: [
                      SafeArea(
                        child: bannerAdWidget(),
                      ),
                      Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  color: infoBGColor,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Oops! Any online user not found near to you.' , style: TextStyle(
                  color: infoTextColor
                  )),
                  )),
              ),
                    ],
                  );

            }
          } else if (snapshot.hasError) {
            return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  color: errorBGColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Error: ${snapshot.error}' , style: const TextStyle(
                  color: errorTextColor
                  )),
                  )),
              );
          }
          return const CircularProgressIndicator();
        },
        ),
      ),
      ),
      ),
          ]
          ),     
        ),
        )
      ),

        /// Rooms page
        GestureDetector(
      //for hiding keyboard when a tap is detected on screen
      onTap: FocusScope.of(context).unfocus,
      child: PopScope(
        child: Scaffold(         
          //body
          body: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(0.01),
          children: [
      SingleChildScrollView(
      child: Form(
      child: Center(
          child: FutureBuilder<Box<RoomsInfoModel>>(
        future: Hive.openBox('rooms'),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data!;
            var rooms = data!;
            if( rooms.length >0 ){
            return ListView.builder(
                                itemCount: rooms.length,
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  if(index == 0){
                  return Column(
                    children: [
                      SafeArea(
                        child: FacebookBannerAd(
    placementId: "410201161996644_412605438422883",
    bannerSize: BannerSize.STANDARD,
    listener: (result, value) {
      switch (result) {
        case BannerAdResult.ERROR:
          print("Error: $value");
          break;
        case BannerAdResult.LOADED:
          print("Loaded: $value");
          break;
        case BannerAdResult.CLICKED:
          print("Clicked: $value");
          break;
        case BannerAdResult.LOGGING_IMPRESSION:
          print("Logging Impression: $value");
          break;
      }
    },
  ),
                      ),
                      RoomsCard(id: index, room: rooms?.get(index), selfInfo: selfInfo),
                    ],
                  );
                  }else{
                return  RoomsCard(id: index, room: rooms?.get(index), selfInfo: selfInfo);
                  } 
                                  
                                });

            }else{

              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  color: infoBGColor,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Oops! No room exist to join' , style: TextStyle(
                  color: infoTextColor
                  )),
                  )),
              );

            }
          } else if (snapshot.hasError) {
            return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  color: errorBGColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Error: ${snapshot.error}' , style: const TextStyle(
                  color: errorTextColor
                  )),
                  )),
              );
          }
          return const CircularProgressIndicator();
        },
        ),
      ),
      ),
      ),
          ]
          ),     
        ),
        )
      ),
      ][currentPageIndex],
    );
  }
}
