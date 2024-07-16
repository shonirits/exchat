
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/hive.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import '../common/config.dart';
import '../../main.dart';
import '../helpers/colors.dart';
import '../helpers/common.dart';
import '../models/api.dart';
import '../helpers/api.dart';
import '../helpers/dialogs.dart';
import '../helpers/user.dart';
import 'mobile_layout_screen.dart';
import '../widgets/messages.dart';
import 'splash_screen.dart';
import '../helpers/crud.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';

class ChatScreen extends StatefulWidget {
  final id;
  final chat;
  final selfInfo;
  final String adUnitId = Platform.isAndroid
  // Use this ad unit on Android...
      ? androidAdId
  // ... or this one on iOS.
      : iosAdId;

  final bool isAds = Platform.isAndroid || Platform.isIOS;

  ChatScreen({super.key, required int this.id, required this.chat, this.selfInfo});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
late UsersInfoModel _user;
  final _dataServices = DataServices();
 var _chatTitle = '';
 var _chatSubTitle = '';
 var _genderDP = User.userGenderDP('Unknown');
 var _userID = '0';
 bool _isFree = true;
 
 Color _statusColor = User.userStatusColor('Offline');

  //for handling message text changes
  final _textController = TextEditingController();

  late final FocusNode _focus = FocusNode(
  onKeyEvent: (node, evt) {
    final enterPressedWithShift = evt is KeyDownEvent &&
        evt.physicalKey == PhysicalKeyboardKey.enter &&
        !HardwareKeyboard.instance.physicalKeysPressed.any(
          (key) => <PhysicalKeyboardKey>{
            PhysicalKeyboardKey.shiftLeft,
            PhysicalKeyboardKey.shiftRight,
          }.contains(key),
        );

    if (enterPressedWithShift) {
      if (_textController.text.isNotEmpty && _isFree) {
      doSendNow();
      }
      return KeyEventResult.handled;
    }
    else {
      return KeyEventResult.ignored;
    }
  },
);

  //showEmoji -- for storing value of showing or hiding emoji
  //isUploading -- for checking if image is uploading or not?
  bool _showEmoji = false, _isUploading = false;

   @override
  void initState() {
    super.initState();
    _loadDefault().then((loaddefaultValue) async {

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

       final chat = widget.chat;
       late final selfInfo = widget.selfInfo;
       final roomid = chat?.roomId;

       if(selfInfo?.userId == chat?.userId){
        _userID = chat?.recipientId;
        }else{
        _userID = chat?.userId; 
        }
        setState((){});

       await _dataServices.saveValue('screen', chat?.chatId);
       await _dataServices.saveValue('isFree', 'false');

        await User().isConnected(selfInfo, selfInfo?.latitude, selfInfo?.longitude).then((isConnected_Value) async { 
          
         if(roomid == '0'){          

      await User().getProfile(_userID, selfInfo?.userId).then((profile_Value) async {

          Future.delayed(Duration.zero, () async {

          await _dataServices.saveValue('isFree', 'true');

                  return false;

                });

            });

         }else{

          await User().getConversation(chat?.chatId, selfInfo?.userId).then((conversation_Value) async {

          Future.delayed(Duration.zero, () async {

          await _dataServices.saveValue('isFree', 'true');

                  return false;

                });

            });


         }

          });    


      }

    });

    });  
    _focus.addListener(_onFocusChange); 
  }

  @override
void setState(VoidCallback fn){
  if(mounted){
    super.setState(fn);
  }
}

  @override
  void dispose() {
    super.dispose();
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
  }



  void _onFocusChange() {
    if (_showEmoji) setState(() => _showEmoji = !_showEmoji);
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



  Future<bool> _sendTextMessage(chatId, userId, content, token) async {

    final timestamp = DateTime.now().millisecondsSinceEpoch;

        final data = MessagesInfoModel(
                  messageId: '0',
                  chatId: chatId,
                  userId: userId,
                  messageType: 'text',
                  messageContent: content,
                  messageStatus: '0',
                  token: token,
                  sentAt: timestamp.toString(),
                  deliveredAt: timestamp.toString(),
                  readAt: timestamp.toString(),
                  );

                  final messageBox = MessagesBox.getData();

                  final isMessageExist = messageBox.values.where((elementMessage) => elementMessage.messageId == '0' && elementMessage.chatId == chatId && elementMessage.userId == userId && elementMessage.messageType == 'text' && elementMessage.messageContent == content);

                  if(isMessageExist.isEmpty) {
                    messageBox.add(data);

                    final chatBox = ChatsBox.getData();
                    final isChatExist = chatBox.values.where((elementChat) => elementChat.chatId == chatId);

                    if(isChatExist.isNotEmpty){

                      final chatRow =  isChatExist.first;
                      chatRow.lastMessageAt = timestamp.toString();
                      chatRow.save();

                    }

                  }

                  return true;

    }



    exitRoom(BuildContext context, selfInfo, userID, chatId) { 
                Widget cancelButton = TextButton(
                  child: const Text("Cancel"),
                  onPressed:  () {
                    Navigator.pop(context);
                  },
                );
                Widget continueButton = TextButton(
                  child: const Text("Yes! Exit"),
                  onPressed:  () async {

                     await _dataServices.saveValue('isFree', 'false');

                      doExitRoom(selfInfo, userID, chatId);
                    
                  },
                );  // set up the AlertDialog
                AlertDialog alert = AlertDialog(
                  title: const Text("Exit Room"),
                  content: const Text("After Exit, your all messages in this conversation will be deleted from server forever. Are you sure to exit from this room?."),
                  actions: [
                    cancelButton,
                    continueButton,
                  ],
                );  // show the dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return alert;
                  },
                );
              }



    void doExitRoom(SelfInfoModel? selfInfo, userID, chatId) async {  

    try {

    final isExit = await Api().getUrl('${apiUrl}chat?app_public_key=$apiPublicKey&app_secret_key=$apiSecretKey&user_public_key=${selfInfo!.publicKey}&user_secret_key=${selfInfo.secretKey}&do=exit_room&id=$chatId');

    if (isExit != null) {

      final jsonData = dataStringFromJson(isExit);

    final returnData = jsonData.data!;

    if(jsonData.status != false){

      final messageBox = MessagesBox.getData();

      final isMessageExist = messageBox.values.where((elementMessage) => elementMessage.chatId == chatId);

              if(isMessageExist.isNotEmpty){

                for (var message in isMessageExist) {

                  final messageKey = message.key;
                  
                  User().deleteMessage(messageKey);

                }            
  
              }

      final chatBox = ChatsBox.getData();

      final isChatExist = chatBox.values.where((elementChat) => elementChat.chatId == chatId);

              if(isChatExist.isNotEmpty){

                for (var chat in isChatExist) {

                  final chatKey = chat.key;
                  
                  User().deleteChat(chatKey);

                }
  
              }

               await _dataServices.saveValue('isFree', 'true');

       // ignore: use_build_context_synchronously
       Dialogs.showSnackbar(context, 'Exit Successfully', successBGColor, successTextColor);

                Navigator.pushReplacement(
            // ignore: use_build_context_synchronously
            context, MaterialPageRoute(builder: (_) => MobileLayoutScreen()));

      }else{

         await _dataServices.saveValue('isFree', 'true');

      // ignore: use_build_context_synchronously
      Dialogs.showSnackbar(context, 'An unknown error occurred ', errorBGColor, errorTextColor);
      
    }


    }else{

       await _dataServices.saveValue('isFree', 'true');

      // ignore: use_build_context_synchronously
      Dialogs.showSnackbar(context, 'Unable to complete request', errorBGColor, errorTextColor);
      
    }

    } catch (e) {

       await _dataServices.saveValue('isFree', 'true');

      // ignore: use_build_context_synchronously
      Dialogs.showSnackbar(context, 'No Internet Connection', errorBGColor, errorTextColor);
      
      }
}


        deleteMessages(BuildContext context, selfInfo, chatId, roomId) { 
                        Widget cancelButton = TextButton(
                          child: const Text("Cancel"),
                          onPressed:  () {
                            Navigator.pop(context);
                          },
                        );
                        Widget continueButton = TextButton(
                          child: const Text("Yes! Delete"),
                          onPressed:  () async {

                             await _dataServices.saveValue('isFree', 'false');

                              doDeleteMessages(selfInfo, chatId, roomId);
                            
                          },
                        );  // set up the AlertDialog
                        AlertDialog alert = AlertDialog(
                          title: const Text("Delete Messages"),
                          content: const Text("After delete messages, this conversation all messages will be deleted from server forever. Are you sure to delete all messages?."),
                          actions: [
                            cancelButton,
                            continueButton,
                          ],
                        );  // show the dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return alert;
                          },
                        );
                      }


                      void doDeleteMessages(SelfInfoModel? selfInfo, chatId, roomId) async { 

    try {

      var isDeletedxist;

    final isDeleted = await Api().getUrl('${apiUrl}chat?app_public_key=$apiPublicKey&app_secret_key=$apiSecretKey&user_public_key=${selfInfo!.publicKey}&user_secret_key=${selfInfo.secretKey}&do=delete_messages&id=$chatId');

    if (isDeleted != null) {

      final jsonData = dataStringFromJson(isDeleted);

    final returnData = jsonData.data!;

    if(jsonData.status != false){

      final messageBox = MessagesBox.getData();

      (roomId == '0')? isDeletedxist = messageBox.values.where((elementMessage) => elementMessage.chatId == chatId):
      isDeletedxist = messageBox.values.where((elementMessage) => elementMessage.chatId == chatId && elementMessage.userId == selfInfo.userId);

              if(isDeletedxist.isNotEmpty){

                isDeletedxist.forEach((message){

                  final messageKey = message.key;
                  
                  User().deleteMessage(messageKey);

                });            
  
              }

               await _dataServices.saveValue('isFree', 'true');

              // ignore: use_build_context_synchronously
              Navigator.pop(context);

            // ignore: use_build_context_synchronously
            Dialogs.showSnackbar(context, 'Messages Deleted Successfully', successBGColor, successTextColor);

      }else{

         await _dataServices.saveValue('isFree', 'true');

      // ignore: use_build_context_synchronously
      Dialogs.showSnackbar(context, 'An unknown error occurred ', errorBGColor, errorTextColor);      

    }


    }else{

       await _dataServices.saveValue('isFree', 'true');

      // ignore: use_build_context_synchronously
      Dialogs.showSnackbar(context, 'Unable to complete request', errorBGColor, errorTextColor);
      
    }

    } catch (e) {

       await _dataServices.saveValue('isFree', 'true');

      // ignore: use_build_context_synchronously
      Dialogs.showSnackbar(context, 'No Internet Connection', errorBGColor, errorTextColor);
      
      }
}


            blockUser(BuildContext context, selfInfo, _userID, chatId) { 
                Widget cancelButton = TextButton(
                  child: const Text("Cancel"),
                  onPressed:  () {
                    Navigator.pop(context);
                  },
                );
                Widget continueButton = TextButton(
                  child: const Text("Yes! Block"),
                  onPressed:  () async {

                    await _dataServices.saveValue('isFree', 'false');

                      doBlockUser(selfInfo, _userID, chatId);
                    
                  },
                );  // set up the AlertDialog
                AlertDialog alert = AlertDialog(
                  title: const Text("Block User"),
                  content: const Text("After block, you cannot unblock, talk or see this user and this conversation will be deleted from server forever. Are you sure to block this user?."),
                  actions: [
                    cancelButton,
                    continueButton,
                  ],
                );  // show the dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return alert;
                  },
                );
              }


    void doBlockUser(SelfInfoModel? selfInfo, _userID, chatId) async { 

    try {

    final isBlocked = await Api().getUrl('${apiUrl}chat?app_public_key=$apiPublicKey&app_secret_key=$apiSecretKey&user_public_key=${selfInfo!.publicKey}&user_secret_key=${selfInfo!.secretKey}&do=user_block&id=${_userID}');

    if (isBlocked != null) {

      final jsonData = dataStringFromJson(isBlocked);

    final returnData = jsonData.data!;

    if(jsonData.status != false){

      final messageBox = MessagesBox.getData();

      final isMessageExist = messageBox.values.where((elementMessage) => elementMessage.chatId == chatId);

              if(isMessageExist.isNotEmpty){

                for (var message in isMessageExist) {

                  final messageKey = message.key;
                  
                  User().deleteMessage(messageKey);

                }
  
              }

      final chatBox = ChatsBox.getData();

      final isChatExist = chatBox.values.where((elementChat) => elementChat.chatId == chatId);

              if(isChatExist.isNotEmpty){

                for (var chat in isChatExist) {

                  final chatKey = chat.key;
                  
                  User().deleteChat(chatKey);

                }
  
              }

              await _dataServices.saveValue('isFree', 'true');

            // ignore: use_build_context_synchronously
            Dialogs.showSnackbar(context, 'Blocked Successfully', successBGColor, successTextColor);

                Navigator.pushReplacement(
            // ignore: use_build_context_synchronously
            context, MaterialPageRoute(builder: (_) => MobileLayoutScreen()));


      }else{

         await _dataServices.saveValue('isFree', 'true');

      // ignore: use_build_context_synchronously
      Dialogs.showSnackbar(context, 'An unknown error occurred ', errorBGColor, errorTextColor);      

    }


    }else{

       await _dataServices.saveValue('isFree', 'true');

      // ignore: use_build_context_synchronously
      Dialogs.showSnackbar(context, 'Unable to complete request', errorBGColor, errorTextColor);
      
    }

    } catch (e) {

       await _dataServices.saveValue('isFree', 'true');

      // ignore: use_build_context_synchronously
      Dialogs.showSnackbar(context, 'No Internet Connection', errorBGColor, errorTextColor);
      
      }
}

          doSendNow() async {

            if (_textController.text.isNotEmpty && _isFree) {
              final textMessage = _textController.text;
              _textController.text = '';
              setState(() {_isFree = false;});
              final chat = widget.chat;
              final selfInfo = widget.selfInfo;              

              await _dataServices.saveValue('isFree', 'false');

              _sendTextMessage(chat.chatId, selfInfo.userId, textMessage, token_fnc(8)).then((textMessage){

                Future.delayed(const Duration(milliseconds: 100), () async {

                  setState(() {_isFree = true;});

                  await _dataServices.saveValue('isFree', 'true');

                });

              });

            }

          }

  // bottom chat input field
  Widget _chatInput(chatId, _selfInfo) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: mq.height * .01, horizontal: mq.width * .025),
      child: Row(
        children: [
          //input field & buttons
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  //emoji button
                  IconButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        setState(() => _showEmoji = !_showEmoji);
                      },
                      icon: const Icon(Icons.emoji_emotions,
                          color: disableTextColor, size: 25)),

                  Expanded(
                      child: TextField(
                    readOnly: (_isUploading)?true:false,
                    controller: _textController,
                    focusNode: _focus,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onTap: () {
                      if (_showEmoji) setState(() => _showEmoji = !_showEmoji);
                    },
                    decoration: const InputDecoration(                        
                        hintText: 'Type Something...',
                        hintStyle: TextStyle(color: disableTextColor),
                        border: InputBorder.none),
                  )),

                  //pick image from gallery button
                  IconButton(
                      onPressed: () async {

                        if (_showEmoji) setState(() => _showEmoji = !_showEmoji);

                        if(_isUploading){

                      Dialogs.showSnackbar(context, 'Still Sending Image, Please Wait...', infoBGColor, infoTextColor);

                        }else{                        
                        
                        final ImagePicker picker = ImagePicker();
                          if (picker == null) return;
                        try {
                        // Picking image
                        final XFile? image = await picker.pickImage(
                          source: ImageSource.gallery, 
                          maxWidth: 500,
                          maxHeight: 500,
                          imageQuality: 70);

                          if (image != null) {                            
                           // uploading & sending image 
                           setState(() => _isUploading = true); 
                           await _dataServices.saveValue('isFree', 'false');

                           await User().sendFileMessage(chatId, _selfInfo, token_fnc(8), image).then((value) async { 

                            await _dataServices.saveValue('isFree', 'true');
                            
                            setState(() {                       

                            Dialogs.showSnackbar(context, 'Uploading Completed Please Wait...', successBGColor, successTextColor);

                            _isUploading = false;
                            
                            });

                            });

                          }

                        } catch (e) {
                        setState(() {
                          _isUploading = false;                          
                        });
                        Dialogs.showSnackbar(context, 'Error: Unable to pick image', errorBGColor, errorTextColor);
                        }
                        }
                       
                      },
                      icon: const Icon(Icons.image,
                          color: disableTextColor, size: 26)),

                  //adding some space
                  SizedBox(width: mq.width * .02),
                ],
              ),
            ),
          ),

          //send message button
          MaterialButton(
            onPressed: !_isFree ? null : () {
              if (_textController.text.isNotEmpty && _isFree) {
              doSendNow();
              }
            },
            minWidth: 0,
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            shape: const CircleBorder(),
            color: quaternaryBGColor,
            child: const Icon(Icons.send, color: primaryTextColor, size: 28),
          )
        ],
      ),
    );
  }

 @override
  Widget build(BuildContext context) {
    //initializing media query (for getting device screen size)
    mq = MediaQuery.of(context).size;

    final int _id = widget.id;
    final chat = widget.chat;
    final selfInfo = widget.selfInfo;

    if(selfInfo?.userId == chat.userId){
    _userID = chat.recipientId;
    }else{
     _userID = chat.userId; 
    }


    if(chat.roomId != '0'){

    final roomBox = RoomsBox.getData();

    final isRoomExist = roomBox.values.where((elementRoom) => elementRoom.roomId == chat.roomId);

    if(isRoomExist.isNotEmpty){

                final roomRow =  isRoomExist.first;

                setState(() {            
                
                 _chatTitle = roomRow.title!;
                 _chatSubTitle = chat.totalParticipants!;
                 _genderDP = User.userGenderDP('Room');
                 _statusColor = User.userStatusColor('Online');

                });

    }

    }else{


     if(_userID != '0') {

    final userBox = UsersBox.getData();

    final isUserExist = userBox.values.where((elementUser) => elementUser.userId == _userID);

    if(isUserExist.isNotEmpty){

                final userRow =  isUserExist.first;

                setState(() {   

                 _user = userRow;     

                 _chatTitle = userRow.nickname!;
                 _chatSubTitle = userRow.distance!;
                 _genderDP = User.userGenderDP(userRow.gender);
                _statusColor = User.userStatusColor(userRow.status);

                });

    }

     }


    }

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: PopScope(
        // onWillPop: () {
        //   if (_showEmoji) {
        //     setState(() => _showEmoji = !_showEmoji);
        //     return Future.value(false);
        //   } else {
        //     return Future.value(true);
        //   }
        // },

        //if emojis are shown & back button is pressed then hide emojis
        //or else simple close current screen on back button click
        canPop: !_showEmoji,
        onPopInvoked: (_) async {
          if (_showEmoji) {
            setState(() => _showEmoji = !_showEmoji);
          } else {
            Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => MobileLayoutScreen()));
          }
        },

        //
        child: Scaffold(
          //app bar
          appBar: AppBar(
            elevation: 0,
            leadingWidth: 25,
            leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: primaryTextColor),
                  onPressed: () =>  Future.delayed(Duration.zero, () {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MobileLayoutScreen()));
                    });

                  }),
                ),
                centerTitle: false,
          title: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: CircleAvatar(
                  backgroundColor: _statusColor,
                radius: 16,
                child: CircleAvatar(
                    radius: 14,
                    backgroundImage: AssetImage(_genderDP),
                  ),
              ),
          onPressed: () {
        if(chat.roomId == '0'){
            showDialog(
                      barrierDismissible: true,
                        context: context,
                        builder: (BuildContext context){
                         return ProfileDialog(user: _user);
                        }
                         );

        }

          },
        ), 
          Column(
            children: [
              Text(_chatTitle,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: primaryTextColor
                  ),
                overflow: TextOverflow.fade,
                    maxLines: 1),
                  
              Text(
                    _chatSubTitle,
                    style: const TextStyle(
                      fontSize: 10,
                  color: secondaryTextColor
                  ),
                    overflow: TextOverflow.fade,
                    maxLines: 1),
            ],
          )    
        
      ],
          ),
          actions: <Widget>[
          (chat.roomId == '0')? 
          Row(
            children: [
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.commentSlash, size: 20, color: secondaryTextColor,),
                tooltip: 'Delete Messages',
                onPressed: () async {
              
                  deleteMessages(context, selfInfo, chat.chatId, chat.roomId);
              
                },
              ),
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.ban, size: 20, color: highlightTextColor,),
                tooltip: 'Block User',
                onPressed: () async {
              
                  blockUser(context, selfInfo, _userID, chat.chatId);
              
                },
              ),
            ],
          )
          :
          Row(
            children: [
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.commentSlash, size: 20, color: secondaryTextColor,),
                tooltip: 'Delete Messages',
                onPressed: () async {
              
                  deleteMessages(context, selfInfo, chat.chatId, chat.roomId);
              
                },
              ),
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.rightFromBracket, size: 20, color: highlightTextColor,),
                tooltip: 'Exit Room',
                onPressed: () async {
                  
                 exitRoom(context, selfInfo, _userID, chat.chatId);
                 
                },
              ),
            ],
          )
          ,
        ],

          ),

          backgroundColor: senaryBGColor,

          //body
          body: SafeArea(
            child: Column(
              children: [
                SafeArea(
                        child: FacebookBannerAd(
    placementId: "410201161996644_410208778662549",
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
                Expanded(
                  child: ValueListenableBuilder<Box<MessagesInfoModel>>(
        valueListenable: MessagesBox.getData().listenable(),
        builder: (context,box ,_){

          var data = box.values.where((elementMessage) => elementMessage.chatId == chat.chatId).toList();

          return  ListView.builder(
                itemCount: data.length,
                reverse: true,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index){  
                return MessagesCard(id: index, message: data[data.length - 1 - index], selfInfo: selfInfo);
              }            
          );

        },
          ),
                ),

                //progress indicator for showing uploading
                if (_isUploading)
                  const Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                          child: CircularProgressIndicator(strokeWidth: 2))),

                //chat input filed
                _chatInput(chat.chatId, selfInfo),

                

                //show emojis on keyboard emoji button click & vice versa
                if (_showEmoji)
               EmojiPicker(
                      textEditingController: _textController,
                      config: const Config(
                        height: 256,
                    checkPlatformCompatibility: true,
                    swapCategoryAndBottomBar: false,
                    skinToneConfig: SkinToneConfig(),
                    categoryViewConfig: CategoryViewConfig(
                      indicatorColor: quaternaryBGColor,
                      iconColorSelected: quaternaryBGColor,
                      backspaceColor: quaternaryBGColor
                    ),
                    bottomActionBarConfig: BottomActionBarConfig(
                      backgroundColor: quaternaryBGColor,
                      buttonColor: primaryBGColor,
                      buttonIconColor: primaryTextColor
                    ),
                    searchViewConfig: SearchViewConfig(
                      hintText: 'Search Emoji',
                      buttonIconColor: primaryTextColor,
                      backgroundColor: secondaryBGColor

                    ),
                      ),
                    ),                  
              ],
            ),
          ),
        ),
      ),
    );
  }
}
