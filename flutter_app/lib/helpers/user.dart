
import 'dart:io';
import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import '../models/api.dart';
import '../models/hive.dart';
import '../common/config.dart';
import '../helpers/crud.dart';
import '../helpers/colors.dart';
import '../helpers/api.dart';
import '../helpers/notification_service.dart';


class User {

  final _preferencesServices = PreferencesServices();
  final _dataServices = DataServices();


  Future<bool> is_signed_in() async {

        final _is_logged_in = await _preferencesServices.getValue('is_logged_in','bool');
        final _keys = await _preferencesServices.getValue('keys','list');

        if(_keys.length > 0){

          if(_keys[0] != '' && _keys[1] != '' && _is_logged_in == true){

          return true;

          }else{

            return false;

          }

        }else{

          return false;

        }

  }

  Future<SelfInfoModel?> self_info() async {

        final _keys = await _preferencesServices.getValue('keys','list');

        Hive.openBox<SelfInfoModel>('self');

        Box<SelfInfoModel> selfInfoBox = Hive.box<SelfInfoModel>('self');

        if(_keys.length > 0 && selfInfoBox.length > 0){

         final self_info_db = selfInfoBox.getAt(0);

         if(_keys[0] != self_info_db!.publicKey && _keys[1] != self_info_db!.secretKey){

          selfInfoBox.deleteAt(0);

          return null;

         }else{

          return self_info_db;

         }

        }else{

          return null;

        }

  }

  Future<bool> sign_out() async {

    await _preferencesServices.removeEntry('is_logged_in');
    await _preferencesServices.removeEntry('list');

    Box<SelfInfoModel> selfInfoBox = Hive.box<SelfInfoModel>('self');
    Box<RoomsInfoModel> roomsInfoBox = Hive.box<RoomsInfoModel>('rooms');
    Box<ChatsInfoModel> chatsInfoBox = Hive.box<ChatsInfoModel>('chats');
    Box<MessagesInfoModel> messagesInfoBox = Hive.box<MessagesInfoModel>('messages');
    Box<NotificationsInfoModel> notificationsInfoBox = Hive.box<NotificationsInfoModel>('notifications');
    Box<UsersInfoModel> usersInfoBox = Hive.box<UsersInfoModel>('users');

    selfInfoBox.deleteAll(selfInfoBox.keys);
    roomsInfoBox.deleteAll(roomsInfoBox.keys);
    chatsInfoBox.deleteAll(chatsInfoBox.keys);
    messagesInfoBox.deleteAll(messagesInfoBox.keys);
    notificationsInfoBox.deleteAll(notificationsInfoBox.keys);
    usersInfoBox.deleteAll(usersInfoBox.keys);

    await selfInfoBox.clear();
    await roomsInfoBox.clear();
    await chatsInfoBox.clear();
    await messagesInfoBox.clear();
    await notificationsInfoBox.clear();
    await usersInfoBox.clear();

    Hive.deleteFromDisk();

    await _preferencesServices.saveValue('is_logged_in', false, 'bool');
    
    return true;

  }


Future<dynamic> sendFileMessage(chatId, _selfInfo, token, XFile? image) async{
  if(image == null){return 'null';}
  await _dataServices.saveValue('isFree', 'false');
  HttpOverrides.global = MyHttpOverrides();
  final _r = DateTime.now().millisecondsSinceEpoch;

              var stream =  http.ByteStream(image!.openRead());
              stream.cast();
              var length = await image!.length();
              Map<String, String> headers = {
                "Accept": "application/json",
              };
             var postUri = Uri.parse("${apiUrl}chat");
             var request = new http.MultipartRequest("POST", postUri);
              request.fields['app_public_key'] = apiPublicKey;
              request.fields['app_secret_key'] = apiSecretKey;
              request.fields['user_public_key'] = _selfInfo!.publicKey.toString();
              request.fields['user_secret_key'] = _selfInfo!.secretKey.toString();
              request.fields['do'] = 'send_file';
              request.fields['token'] = token;
              request.fields['r'] = _r.toString();
              request.fields['id'] = chatId;

  try {              

              var multipartFileSign = new http.MultipartFile('data', stream, length,
                filename: basename(image!.path));

                request.files.add(multipartFileSign);

                request.headers.addAll(headers);

              await request.send().then((response) async {
                if (response.statusCode == 200){
          await _dataServices.saveValue('isFree', 'true');
                  return 'done';

                }else{
await _dataServices.saveValue('isFree', 'true');
                  return 'null';

                }
              });

           } catch (e) {
      await _dataServices.saveValue('isFree', 'true');
        return 'null';
      }

  }



  Future<bool> getConversation(conversation_id, user_id) async {
    await _dataServices.saveValue('isFree', 'false');
    try {

        final getConversationInfo = await Api().getUrl('${apiUrl}conversation?app_public_key=$apiPublicKey&app_secret_key=$apiSecretKey&user_id=$user_id&conversation_id=$conversation_id');

        if (getConversationInfo != null) { 

          final jsonConversationInfo = conversationinfoFromJson(getConversationInfo);

          final jsonStatus = jsonConversationInfo.status;

          if(jsonConversationInfo.status == false){
await _dataServices.saveValue('isFree', 'true');
            return false;

          }else{

            final chatBox = ChatsBox.getData();

           final jsonData = jsonConversationInfo.data;

           final data = ChatsInfoModel(
                  chatId: jsonData?.chatId,
                  roomId: jsonData?.roomId,
                  userId: jsonData?.userId,
                  recipientId: jsonData?.recipientId,
                  startedAt: jsonData?.startedAt,
                  totalParticipants: jsonData?.totalParticipants,
                  totalMessages: jsonData?.totalMessages,
                  lastMessageAt: jsonData?.lastMessageAt,
                  admin: jsonData?.admin,
                  joined: jsonData?.joined,
              );

           final isChatExist = chatBox.values.where((elementChat) => elementChat.chatId == jsonData?.chatId);

              if(isChatExist.isNotEmpty){

                final chatRow =  isChatExist.first;

                chatRow.totalParticipants = jsonData?.totalParticipants;
                chatRow.totalMessages = jsonData?.totalMessages;
                chatRow.lastMessageAt = jsonData?.lastMessageAt;
                chatRow.admin = jsonData?.admin;
                chatRow.joined = jsonData?.joined;
                chatRow.save();
              }else{
                chatBox.add(data);

              }           
await _dataServices.saveValue('isFree', 'true');
          return true; 

          }       
              
        }else{
await _dataServices.saveValue('isFree', 'true');
        return false;

        }

      } catch (e) {
      await _dataServices.saveValue('isFree', 'true');
        return false;
      }

  }


  Future<bool> getProfile(profile_id, user_id) async {
  await _dataServices.saveValue('isFree', 'false');
    try {

        final getProfileInfo = await Api().getUrl('${apiUrl}profile?app_public_key=$apiPublicKey&app_secret_key=$apiSecretKey&user_id=$user_id&profile_id=$profile_id');

        if (getProfileInfo != null) { 

          final jsonProfileInfo = profileinfoFromJson(getProfileInfo);

          final jsonStatus = jsonProfileInfo.status;

          if(jsonProfileInfo.status == false){
await _dataServices.saveValue('isFree', 'true');
            return false;

          }else{

            final userBox = UsersBox.getData();

           final jsonData = jsonProfileInfo.data;

           final data = UsersInfoModel(
                  userId: jsonData?.userId,
                  publicKey: jsonData?.publicKey,
                  nickname: jsonData?.nickname,
                  gender: jsonData?.gender,
                  age: jsonData?.age,
                  findgender: jsonData?.findgender,
                  agefrom: jsonData?.agefrom,
                  ageto: jsonData?.ageto,
                  status: jsonData?.status,
                  lastSeen: jsonData?.lastSeen,
                  distance: jsonData?.distance,
                  chatRequest: jsonData?.chatRequest,
              );

          final isUserExist = userBox.values.where((elementUser) => elementUser.userId == jsonData?.userId);

          if(isUserExist.isNotEmpty){

                final userRow =  isUserExist.first;

                userRow.nickname = jsonData?.nickname;
                userRow.gender = jsonData?.gender;
                userRow.age = jsonData?.age;
                userRow.findgender = jsonData?.findgender;
                userRow.agefrom = jsonData?.agefrom;
                userRow.ageto = jsonData?.ageto;
                userRow.status = jsonData?.status;
                userRow.lastSeen = jsonData?.lastSeen;
                userRow.distance = jsonData?.distance;
                userRow.chatRequest = jsonData?.chatRequest;
                userRow.save();

              }else{

                userBox.add(data);

              }           
await _dataServices.saveValue('isFree', 'true');
          return true; 

          }       
              
        }else{
await _dataServices.saveValue('isFree', 'true');
        return false;

        }

      } catch (e) {
      await _dataServices.saveValue('isFree', 'true');
        return false;
      }

  }

Future<dynamic> liveListing() async {

  var getIsFree = await _dataServices.getValue('isFree');
  if(getIsFree != 'true'){return false;}
  await _dataServices.saveValue('isFree', 'false');

  final SelfInfoModel? selfInfo = await User().self_info();

  if(selfInfo != null){

try {        

    final getStreamResult = await Api().getUrl('${apiUrl}chat?app_public_key=$apiPublicKey&app_secret_key=$apiSecretKey&user_public_key=${selfInfo!.publicKey}&user_secret_key=${selfInfo!.secretKey}&do=stream');

      if (getStreamResult != null) {

    final jsonStreamResult = streamChatFromJson(getStreamResult);

    final jsonStreamUsers = jsonStreamResult.data!.users;

           if(jsonStreamUsers!.isNotEmpty){

          final streamAllUsers = jsonStreamUsers!.entries;

          if(streamAllUsers.isNotEmpty){

            for (MapEntry<String, Recipient> user in streamAllUsers) {

            usersUpdate(user, selfInfo);

            }

          }
          
      }

      final jsonStreamChats = jsonStreamResult.data!.chats;

           if(jsonStreamChats != null){

          final streamAllChats = jsonStreamChats!.entries;

          if(streamAllChats.isNotEmpty){

            for (MapEntry<String, Chat> chat in streamAllChats) {

              chatsUpdate(chat, selfInfo);

            }

          }
          
      }

      final jsonStreamMChat = jsonStreamResult.data!.messages;

           if(jsonStreamMChat != null){

          final streamAllMChat = jsonStreamMChat!.entries;

          if(streamAllMChat.isNotEmpty){

            for (var mChat in streamAllMChat) {

              final streamAllMessages =  mChat.value!;

              if(streamAllMessages.isNotEmpty){

               final streamChatMessages = streamAllMessages!.entries;

              if(streamChatMessages.isNotEmpty){

               for (MapEntry<String, Message> message in streamChatMessages) {  

                final messageValues =  message.value!;
                
                 messagesUpdate(messageValues, selfInfo); 

               }

              }              

              }         

              }

          }
          
      }

      final jsonStreamAllPush = jsonStreamResult.data!.allPush;

           if(jsonStreamAllPush != null){

            for (var streamAllPush in jsonStreamAllPush) {

              if(streamAllPush.parentType == 'chat_remove'){

                User().deleteConversation(streamAllPush.parentId);

              }else if(streamAllPush.parentType == 'messages_remove'){

               User().deleteMessages(streamAllPush.parentId, streamAllPush.subId);

              }else if(streamAllPush.parentType == 'room_exit'){

               User().roomExit(streamAllPush.parentId, streamAllPush.subId);

              }else if(streamAllPush.parentType == 'notification_user_remove'){

               User().deleteNotifications(streamAllPush.parentId, streamAllPush.subId);

              }else if(streamAllPush.parentType == 'chat_request' || streamAllPush.parentType == 'chat_accept'){

                final notificationData = NotificationsInfoModel(
                  notificationId: streamAllPush.parentId,
                  userId: streamAllPush.userId,
                  parentId: streamAllPush.parentId,
                  parentType: streamAllPush.parentType,
                  subId: streamAllPush.subId,
                  notificationStatus: '0',
                  addedAt: DateTime.now().toUtc().millisecondsSinceEpoch.toString(),
                  updatedAt: DateTime.now().toUtc().millisecondsSinceEpoch.toString(),
                  );

               notificationsUpdate(notificationData, selfInfo);

              }else{

            

              }

            }

           }
          
      }

    await _dataServices.saveValue('isFree', 'true');
    return true;

  } catch (e) {

    await _dataServices.saveValue('isFree', 'true');
    return false;

      }

  }

}

  Future<bool> isStream() async {

    var getIsFree = await _dataServices.getValue('isFree');
  if(getIsFree != 'true'){return false;}
    await _dataServices.saveValue('isFree', 'false');
    final SelfInfoModel? selfInfo = await User().self_info(); 

    if(selfInfo != null){

     try {

        final getStream = await Api().getUrl('${apiUrl}stream?app_public_key=$apiPublicKey&app_secret_key=$apiSecretKey&user_public_key=${selfInfo!.publicKey}&user_secret_key=${selfInfo!.secretKey}');

        if (getStream != null) {

         final jsonStream = dataStringFromJson(getStream); 

          if(jsonStream.status == true){
        await _dataServices.saveValue('isFree', 'true');
        return true;

          }else{
await _dataServices.saveValue('isFree', 'true');
        return false;

          }

        }else{
await _dataServices.saveValue('isFree', 'true');
        return false;

        }

      } catch (e) {
      await _dataServices.saveValue('isFree', 'true');
        return false;
      }

    }else{

      return false;

    }


  }

  Future<bool> isConnected(SelfInfoModel? selfInfo, latitude, longitude) async {
   await _dataServices.saveValue('isFree', 'false');
    try {

        final getUserInfo = await Api().getUrl('${apiUrl}user_info?app_public_key=$apiPublicKey&app_secret_key=$apiSecretKey&user_public_key=${selfInfo!.publicKey}&user_secret_key=${selfInfo!.secretKey}&latitude=$latitude&longitude=$longitude');

        if (getUserInfo != null) { 

          final jsonSelfInfo = selfInfoFromJson(getUserInfo);

          if(jsonSelfInfo.status == false){

await _dataServices.saveValue('isFree', 'true');
            return false;

          }else{

           final jsonData = jsonSelfInfo.data;

            final selfBox = SelfBox.getData();
            
            final getSelfInfo = selfBox.getAt(0);            

              getSelfInfo!.userId = jsonData!.userId;
              getSelfInfo.publicKey = jsonData!.publicKey;
              getSelfInfo.secretKey = jsonData!.secretKey;
              getSelfInfo.nickname = jsonData!.nickname;
              getSelfInfo.gender = jsonData!.gender;
              getSelfInfo.age = jsonData!.age;
              getSelfInfo.findgender = jsonData!.findgender;
              getSelfInfo.agefrom = jsonData!.agefrom;
              getSelfInfo.ageto = jsonData!.ageto;
              getSelfInfo.status = jsonData!.status;
              getSelfInfo.statusChange = jsonData!.statusChange;
              getSelfInfo.timeOut = jsonData!.timeOut;
              getSelfInfo.lastUpdateAt = jsonData!.lastUpdateAt;
              getSelfInfo.lastMomentAt = jsonData!.lastMomentAt;
              getSelfInfo.lastSeenAt = jsonData!.lastSeenAt;
              getSelfInfo.latitude = jsonData!.latitude;
              getSelfInfo.longitude = jsonData!.longitude;
              getSelfInfo.createdAt = jsonData!.createdAt;
              getSelfInfo.createdIp = jsonData!.createdIp;
              getSelfInfo.offset = jsonData!.offset;

              getSelfInfo.save();    
await _dataServices.saveValue('isFree', 'true');
          return true; 
          
          }       

        }else{
await _dataServices.saveValue('isFree', 'true');
        return false;

        }

      } catch (e) {
      await _dataServices.saveValue('isFree', 'true');
        return false;
      }

  }

  Future<dynamic> saveTmpInfo(TmpInfoModel? tmpInfo) async {

    final _tmpBox = TmpBox.getData();

     final isTmpExist = _tmpBox.values.where((elementTmp) => elementTmp.tmpId == tmpInfo?.tmpId);

              if(isTmpExist.isEmpty){            

                _tmpBox.add(tmpInfo!);

              } 

  }


  Future<bool> roomExit(chatId, userId) async {

    final messageBox = MessagesBox.getData();

      final isMessageExist = messageBox.values.where((elementMessage) => elementMessage.chatId == chatId && elementMessage.userId == userId);

              if(isMessageExist.isNotEmpty){

                for (var message in isMessageExist) {

                  final messageKey = message.key;
                  
                  User().deleteMessage(messageKey);

                }            
  
              }

  return true;

  }

Future<bool> deleteConversation(chatId) async {

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

  return true;

}


Future<bool> deleteMessages(chatId, userId) async {

  final messageBox = MessagesBox.getData();

      final isMessageExist = messageBox.values.where((elementMessage) => elementMessage.chatId == chatId && elementMessage.userId == userId);

              if(isMessageExist.isNotEmpty){

                for (var message in isMessageExist) {

                  final messageKey = message.key;
                  
                  User().deleteMessage(messageKey);

                }            
  
              }

  return true;

}


Future<bool> deleteNotifications(parentId, subId) async {

  final notificationBox = NotificationsBox.getData();

      final isNotificationExist = notificationBox.values.where((elementNotification) => (elementNotification.parentId == parentId && elementNotification.subId == subId) || (elementNotification.subId == parentId && elementNotification.parentId == subId));

              if(isNotificationExist.isNotEmpty){

                for (var notification in isNotificationExist) {

                  final notificationKey = notification.key;
                  
                  User().deleteNotification(notificationKey);

                }            
  
              }

  return true;

}

Future<bool> deleteTmp(tmpKey) async {

  final tmpBox = TmpBox.getData();

  tmpBox.delete(tmpKey);

  return true;

}

Future<bool> deleteSelf(selfKey) async {

  final selfBox = SelfBox.getData();

  selfBox.delete(selfKey);

  return true;

}

Future<bool> deleteRoom(roomKey) async {

  final roomBox = RoomsBox.getData();

  roomBox.delete(roomKey);

  return true;

}

Future<bool> deleteUser(userKey) async {

  final userBox = UsersBox.getData();

  userBox.delete(userKey);

  return true;

}

Future<bool> deleteMessage(messageKey) async {

  final messageBox = MessagesBox.getData();

  messageBox.delete(messageKey);

  return true;

}


Future<bool> deleteChat(chatKey) async {

  final chatBox = ChatsBox.getData();

  chatBox.delete(chatKey);

  return true;

}


Future<bool> deleteNotification(notificationKey) async {

  final notificationBox = NotificationsBox.getData();

  notificationBox.delete(notificationKey);

  return true;

}



  Future<bool> sendTmpInfo(TmpInfoModel? tmpInfo, SelfInfoModel? selfInfo) async {
    await _dataServices.saveValue('isFree', 'false');
    try {      

    final getResult = await Api().getUrl('${apiUrl}chat?app_public_key=$apiPublicKey&app_secret_key=$apiSecretKey&user_public_key=${selfInfo!.publicKey}&user_secret_key=${selfInfo!.secretKey}&do=tmp&data=${tmpInfo?.data}');

    if (getResult != null) { 

    final jsonData = dataStringFromJson(getResult);

    final returnData = jsonData.data!;

    if(jsonData.status != false){

      final tmpInfoData = tmpInfo!.data;

      String? tmpInfoEncode = tmpInfoData!;

      final tmpInfoDecode = jsonDecode(tmpInfoEncode);
await _dataServices.saveValue('isFree', 'true');
    return true;

    }else{
await _dataServices.saveValue('isFree', 'true');
      return false;

    }

    }else{
await _dataServices.saveValue('isFree', 'true');
        return false;

     }

    } catch (e) {
await _dataServices.saveValue('isFree', 'true');
        return false;

      }

  }



  Future<dynamic> sendMessage(MessagesInfoModel unSendMessageRow, SelfInfoModel? selfInfo) async {
    await _dataServices.saveValue('isFree', 'false');
      try {

    final getResult = await Api().getUrl('${apiUrl}chat?app_public_key=$apiPublicKey&app_secret_key=$apiSecretKey&user_public_key=${selfInfo!.publicKey}&user_secret_key=${selfInfo!.secretKey}&do=send_text&id=${unSendMessageRow.chatId}&data=${unSendMessageRow.messageContent}&token=${unSendMessageRow.token}');

    if (getResult != null) { 

    final jsonData = dataStringFromJson(getResult);

    final returnData = jsonData.data!;

    if(jsonData.status != false){
await _dataServices.saveValue('isFree', 'true');
    return returnData;

    }else{
await _dataServices.saveValue('isFree', 'true');
      return null;

    }

    }else{
await _dataServices.saveValue('isFree', 'true');
        return null;

     }

    } catch (e) {
await _dataServices.saveValue('isFree', 'true');
        return null;

      }
    
  }

  static notificationsUpdate(notification, selfInfo){

    final data = NotificationsInfoModel(
                  notificationId: notification.notificationId,
                  userId: notification.userId,
                  parentId: notification.parentId,
                  parentType: notification.parentType,
                  notificationStatus: notification.notificationStatus,
                  subId: notification.subId,
                  addedAt: notification.addedAt,
                  updatedAt: notification.updatedAt,
                  );

              final notificationBox = NotificationsBox.getData();

              final isNotificationExist = notificationBox.values.where((elementNotification) => elementNotification.notificationId == notification.notificationId && elementNotification.parentType == notification.parentType);

              if(isNotificationExist.isNotEmpty){
                final notificationRow =  isNotificationExist.first;
                notificationRow.notificationStatus = notification.notificationStatus;
                notificationRow.updatedAt = notification.updatedAt;
                notificationRow.save();

              }else{

              try{
              notificationBox.add(data);

              if(selfInfo?.userId != notification.parentId){

              var notificationTitle = 'New Notification'; 
              var notificationBody = 'You have a new notification';

              if(notification.parentType == 'chat_accept' || notification.parentType == 'chat_request'){
              final userBox = UsersBox.getData();
              final isUserExist = userBox.values.where((elementUser) => elementUser.userId == notification.parentId);  
              if(isUserExist.isNotEmpty){
                final userRow =  isUserExist.first;               
                if(notification.parentType == 'chat_accept'){  
                  notificationTitle = 'Request Accepted';
                  notificationBody = '${userRow.nickname!} accepted your chat request.';
                }else if(notification.parentType == 'chat_request'){  
                  notificationTitle = 'Chat Request';
                  notificationBody = '${userRow.nickname!} send you chat request.';
                }
              } 
              }

              NotificationService.pushNotification(id: int.parse(notification.notificationId), title: notificationTitle, body: notificationBody);

              }

               }catch (error) {
                notificationBox.add(data);
                print('Notification Crashed! $error');
                }

              }

   }


   static messagesUpdate(message, selfInfo){

    final data = MessagesInfoModel(
                  messageId: message.messageId,
                  chatId: message.chatId,
                  userId: message.userId,
                  messageType: message.messageType,
                  messageContent: message.messageContent,
                  messageStatus: message.messageStatus,
                  token: message.token,
                  sentAt: message.sentAt,
                  deliveredAt: message.deliveredAt,
                  readAt: message.readAt,
                  );

              final messageBox = MessagesBox.getData();

              final isMessageExist = messageBox.values.where((elementMessage) => elementMessage.messageId == message.messageId);

              if(isMessageExist.isNotEmpty){

                final messageRow =  isMessageExist.first;
                messageRow.messageStatus = message.messageStatus;
                messageRow.sentAt = message.sentAt;
                messageRow.deliveredAt = message.deliveredAt;
                messageRow.readAt = message.readAt;
                messageRow.save();

              }else{

                try{
              messageBox.add(data);

              if(selfInfo?.userId != message.userId){

              var notificationTitle = 'New Message'; 
              var notificationBody = 'You have a new message';

              final userBox = UsersBox.getData();
              final isUserExist = userBox.values.where((elementUser) => elementUser.userId == message.userId);  
              if(isUserExist.isNotEmpty){
                final userRow =  isUserExist.first;

                notificationTitle = userRow.nickname!;

              final chatBox = ChatsBox.getData();
              final isChatExist = chatBox.values.where((elementChat) => elementChat.chatId == message.chatId);
              if(isChatExist.isNotEmpty){
                final chatRow =  isChatExist.first;

                if(chatRow.roomId != '0'){

              final roomBox = RoomsBox.getData();
              final isRoomExist = roomBox.values.where((elementRoom) => elementRoom.roomId == chatRow.roomId);
              if(isRoomExist.isNotEmpty){
                final roomRow =  isRoomExist.first;

                notificationTitle = '[${roomRow.title!}] ${userRow.nickname!}';

              }

              }

              }                
              } 

              if(message.messageType == 'text'){
              notificationBody = message.messageContent;
              }else{
              notificationBody = '🖼️';
              }
              
              NotificationService.pushMessage(id: int.parse(message.chatId), title: notificationTitle, body: notificationBody);

              }

               }
               catch (error) {

                messageBox.add(data);
                  print('Message Crashed! $error');
                  
                }

              }

   }


  static roomsUpdate(room, selfInfo){

    final data = RoomsInfoModel(
                  roomId: room.value.roomId,
                  title: room.value.title,
                  lastEntryAt: room.value.lastEntryAt,
                  lastExitAt: room.value.lastExitAt,
                  totalUsers: room.value.totalUsers,
                  admin: room.value.admin,
                  joined: room.value.joined,
              );

              final roomBox = RoomsBox.getData();

              final isRoomExist = roomBox.values.where((elementRoom) => elementRoom.roomId == room.value.roomId);

              if(isRoomExist.isNotEmpty){

                final roomRow =  isRoomExist.first;

                roomRow.lastEntryAt = room.value.lastEntryAt;
                roomRow.lastExitAt = room.value.lastExitAt;
                roomRow.totalUsers = room.value.totalUsers;
                roomRow.joined = room.value.joined;
                roomRow.admin = room.value.admin;

                roomRow.save();

              }else{
                
                try{
                roomBox.add(data);
                }catch (error) {
                roomBox.add(data);
                  print('Room Crashed! $error');
                }

              }

  }

  static chatsUpdate(chat, selfInfo){

    final data = ChatsInfoModel(
                  chatId: chat.value.chatId,
                  roomId: chat.value.roomId,
                  userId: chat.value.userId,
                  recipientId: chat.value.recipientId,
                  startedAt: chat.value.startedAt,
                  totalParticipants: chat.value.totalParticipants,
                  totalMessages: chat.value.totalMessages,
                  lastMessageAt: chat.value.lastMessageAt,
                  admin: chat.value.admin,
                  joined: chat.value.joined,
              );

              final chatBox = ChatsBox.getData();

              final isChatExist = chatBox.values.where((elementChat) => elementChat.chatId == chat.value.chatId);

              if(isChatExist.isNotEmpty){

                final chatRow =  isChatExist.first;
                chatRow.totalParticipants = chat.value.totalParticipants;
                chatRow.totalMessages = chat.value.totalMessages;
                chatRow.lastMessageAt = chat.value.lastMessageAt;
                chatRow.admin = chat.value.admin;
                chatRow.joined = chat.value.joined;
                chatRow.save();

              }else{

                try{
                chatBox.add(data);
                }catch (error) {
                chatBox.add(data);
                  print('Chat Crashed! $error');
                }

              }

  }
  

  static usersUpdate(user, selfInfo){

    final data = UsersInfoModel(
                  userId: user.value.userId,
                  publicKey: user.value.publicKey,
                  nickname: user.value.nickname,
                  gender: user.value.gender,
                  age: user.value.age,
                  findgender: user.value.findgender,
                  agefrom: user.value.agefrom,
                  ageto: user.value.ageto,
                  status: user.value.status,
                  lastSeen: user.value.lastSeen,
                  distance: user.value.distance,
                  chatRequest: user.value.chatRequest,
              );

              final userBox = UsersBox.getData();

              final isUserExist = userBox.values.where((elementUser) => elementUser.userId == user.value.userId);

              if(isUserExist.isNotEmpty){

                final userRow =  isUserExist.first;

                userRow.nickname = user.value.nickname;
                userRow.gender = user.value.gender;
                userRow.age = user.value.age;
                userRow.findgender = user.value.findgender;
                userRow.agefrom = user.value.agefrom;
                userRow.ageto = user.value.ageto;
                userRow.status = user.value.status;
                userRow.lastSeen = user.value.lastSeen;
                userRow.distance = user.value.distance;
                userRow.chatRequest = user.value.chatRequest;
                userRow.save();

              }else{

                userBox.add(data);

              }

  }


  static userStatusColor(status){

    switch (status) {
    case 'Online':
      return statusOnlineColor;
    case 'Away':
      return statusAwayColor;
    case 'Busy':
      return statusBusyColor;
    default:
      return statusOfflineColor;
  }

  }


  static userGenderDP(gender){

    switch (gender) {
    case 'Male':
      return 'media/images/male.png';
    case 'Female':
      return 'media/images/female.png';
    case 'Room':
      return 'media/images/room.png';
    case 'Unknown':
      return 'media/images/unknown.png';
    default:
      return 'media/images/any.png';
  }

  }
  
}

