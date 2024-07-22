import 'package:hive/hive.dart';
part 'hive.g.dart';

class SelfBox {

  static Box<SelfInfoModel> getData() => Hive.box<SelfInfoModel>('self');

}


class RoomsBox {

  static Box<RoomsInfoModel> getData() => Hive.box<RoomsInfoModel>('rooms');

}

class ChatsBox {

  static Box<ChatsInfoModel> getData() => Hive.box<ChatsInfoModel>('chats');

}

class MessagesBox {

  static Box<MessagesInfoModel> getData() => Hive.box<MessagesInfoModel>('messages');

}

class NotificationsBox {

  static Box<NotificationsInfoModel> getData() => Hive.box<NotificationsInfoModel>('notifications');

}

class UsersBox {

  static Box<UsersInfoModel> getData() => Hive.box<UsersInfoModel>('users');

}

class TmpBox {

  static Box<TmpInfoModel> getData() => Hive.box<TmpInfoModel>('tmp');

}


@HiveType(typeId: 0)
class SelfInfoModel extends HiveObject {

    @HiveField(0)
    String? userId;
    @HiveField(1)
    String? publicKey;
    @HiveField(2)
    String? secretKey;
    @HiveField(3)
    String? nickname;
    @HiveField(4)
    String? gender;
    @HiveField(5)
    String? age;
    @HiveField(6)
    String? findgender;
    @HiveField(7)
    String? agefrom;
    @HiveField(8)
    String? ageto;
    @HiveField(9)
    String? status;
    @HiveField(10)
    String? lastSeenAt;
    @HiveField(11)
    String? latitude;
    @HiveField(12)
    String? longitude;
    @HiveField(13)
    String? offset;

  SelfInfoModel({
    this.userId,
        this.publicKey,
        this.secretKey,
        this.nickname,
        this.gender,
        this.age,
        this.findgender,
        this.agefrom,
        this.ageto,
        this.status,
        this.lastSeenAt,
        this.latitude,
        this.longitude,
        this.offset,
  }) ;

}


@HiveType(typeId: 1)
class RoomsInfoModel extends HiveObject {

    @HiveField(0)
    String? roomId;
    @HiveField(1)
    String? title;
    @HiveField(2)
    String? lastEntryAt;
    @HiveField(3)
    String? lastExitAt;
    @HiveField(4)
    String? totalUsers;
    @HiveField(5)
    String? admin;
    @HiveField(6)
    String? joined;   
    

  RoomsInfoModel({
    this.roomId,
        this.title,
        this.lastEntryAt,
        this.lastExitAt,
        this.totalUsers,
        this.admin,
        this.joined,
  }) ;

}


@HiveType(typeId: 2)
class ChatsInfoModel extends HiveObject {

    @HiveField(0)
    String? chatId;
    @HiveField(1)
    String? roomId;
    @HiveField(2)
    String? userId;
    @HiveField(3)
    String? recipientId;
    @HiveField(4)
    String? startedAt;
    @HiveField(5)
    String? totalParticipants;  
    @HiveField(6)
    String? totalMessages;
    @HiveField(7)
    String? lastMessageAt;
    @HiveField(8)
    String? adminId;
    @HiveField(9)
    String? joined; 

  ChatsInfoModel({
    this.chatId,
        this.roomId,
        this.userId,
        this.recipientId,
        this.startedAt,
        this.totalParticipants,
        this.totalMessages,
        this.lastMessageAt,
        this.adminId,
        this.joined,
  }) ;

}


@HiveType(typeId: 3)
class MessagesInfoModel extends HiveObject {

    @HiveField(0)
    String? messageId;
    @HiveField(1)
    String? chatId;
    @HiveField(2)
    String? userId;
    @HiveField(3)
    String? messageType;
    @HiveField(4)
    String? messageContent;
    @HiveField(5)
    String? messageStatus;
    @HiveField(6)
    String? token;
    @HiveField(7)
    String? sentAt;
    @HiveField(8)
    String? deliveredAt;
    @HiveField(9)
    String? readAt; 

  MessagesInfoModel({
     this.messageId,
        this.chatId,
        this.userId,
        this.messageType,
        this.messageContent,
        this.messageStatus,
        this.token,
        this.sentAt,
        this.deliveredAt,
        this.readAt,
  }) ;


}


@HiveType(typeId: 4)
class NotificationsInfoModel extends HiveObject {

    @HiveField(0)
    String? notificationId;
    @HiveField(1)
    String? userId;
    @HiveField(2)
    String? parentId;
    @HiveField(3)
    String? parentType;
    @HiveField(4)
    String? subId;
    @HiveField(5)
    String? notificationStatus;
    @HiveField(6)
    String? addedAt;  
    @HiveField(7)
    String? updatedAt; 

  NotificationsInfoModel({
    this.notificationId,
        this.userId,
        this.parentId,
        this.parentType,
        this.subId,
        this.notificationStatus,
        this.addedAt,
        this.updatedAt,
  }) ;

}


@HiveType(typeId: 5)
class UsersInfoModel extends HiveObject {

    @HiveField(0)
    String? userId;
    @HiveField(1)
    String? publicKey;
    @HiveField(2)
    String? nickname;
    @HiveField(3)
    String? gender;
    @HiveField(4)
    String? age;
    @HiveField(5)
    String? findgender;
    @HiveField(6)
    String? agefrom;
    @HiveField(7)
    String? ageto;
    @HiveField(8)
    String? status;
    @HiveField(9)
    String? lastSeen;
    @HiveField(10)
    String? distance;
    @HiveField(11)
    String? chatRequest;


  UsersInfoModel({
    this.userId,
        this.publicKey,
        this.nickname,
        this.gender,
        this.age,
        this.findgender,
        this.agefrom,
        this.ageto,
        this.status,
        this.lastSeen,
        this.distance,
        this.chatRequest,
       
  }) ;

}

@HiveType(typeId: 6)
class TmpInfoModel extends HiveObject {

    @HiveField(0)
    String? tmpId;
    @HiveField(1)
    String? data;
    @HiveField(2)
    String? addTime;
    @HiveField(3)
    String? status;


  TmpInfoModel({
    this.tmpId,
        this.data,
        this.addTime,
      this.status,
  }) ;

}
