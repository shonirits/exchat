import 'dart:convert';

DataString dataStringFromJson(String str) => DataString.fromJson(json.decode(str));
String dataStringToJson(DataString data) => json.encode(data.toJson());

class DataString {
    bool response;
    bool status;
    dynamic data;

    DataString({
        required this.response,
        required this.status,
        required this.data,
    });

    factory DataString.fromJson(Map<String, dynamic> json) => DataString(
        response: json["response"],
        status: json["status"],
        data: json["data"],
    );

    Map<String, dynamic> toJson() => {
        "response": response,
        "status": status,
        "data": data,
    };
}


DataBool dataBoolFromJson(String str) => DataBool.fromJson(json.decode(str));
String dataBoolToJson(DataBool data) => json.encode(data.toJson());

class DataBool {
    bool response;
    bool status;
    bool data;

    DataBool({
        required this.response,
        required this.status,
        required this.data,
    });

    factory DataBool.fromJson(Map<String, dynamic> json) => DataBool(
        response: json["response"],
        status: json["status"],
        data: json["data"],
    );

    Map<String, dynamic> toJson() => {
        "response": response,
        "status": status,
        "data": data,
    };
}


DataVoid dataVoidFromJson(String str) => DataVoid.fromJson(json.decode(str));
String dataVoidToJson(DataVoid data) => json.encode(data.toJson());

class DataVoid {
    bool? response;
    bool? status;
    DataV? data;

    DataVoid({
        this.response,
        this.status,
        this.data,
    });

    factory DataVoid.fromJson(Map<String, dynamic> json) => DataVoid(
        response: json["response"],
        status: json["status"],
        data: json["data"] == false ? null : DataV.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "response": response,
        "status": status,
        "data": data?.toJson(),
    };
}

class DataV {
    String? publicKey;
    String? secretKey;

    DataV({
        this.publicKey,
        this.secretKey,
    });

    factory DataV.fromJson(Map<String, dynamic> json) => DataV(
        publicKey: json["public_key"],
        secretKey: json["secret_key"],
    );

    Map<String, dynamic> toJson() => {
        "public_key": publicKey,
        "secret_key": secretKey,
    };
}


SelfInfo selfInfoFromJson(String str) => SelfInfo.fromJson(json.decode(str));
String selfInfoToJson(SelfInfo data) => json.encode(data.toJson());

class SelfInfo {
    bool? response;
    bool? status;
    DataSI? data;

    SelfInfo({
        this.response,
        this.status,
        this.data,
    });

    factory SelfInfo.fromJson(Map<String, dynamic> json) => SelfInfo(
        response: json["response"],
        status: json["status"],
        data: json["data"] == false ? null : DataSI.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "response": response,
        "status": status,
        "data": data?.toJson(),
    };
}

class DataSI {
    String? userId;
    String? publicKey;
    String? secretKey;
    String? nickname;
    String? gender;
    String? age;
    String? findgender;
    String? agefrom;
    String? ageto;
    String? status;
    String? statusChange;
    String? timeOut;
    String? lastUpdateAt;
    String? lastMomentAt;
    String? lastSeenAt;
    String? latitude;
    String? longitude;
    String? createdAt;
    String? createdIp;
    String? offset;

    DataSI({
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
        this.statusChange,
        this.timeOut,
        this.lastUpdateAt,
        this.lastMomentAt,
        this.lastSeenAt,
        this.latitude,
        this.longitude,
        this.createdAt,
        this.createdIp,
        this.offset,
    });

    factory DataSI.fromJson(Map<String, dynamic> json) => DataSI(
        userId: json["user_id"],
        publicKey: json["public_key"],
        secretKey: json["secret_key"],
        nickname: json["nickname"],
        gender: json["gender"],
        age: json["age"],
        findgender: json["findgender"],
        agefrom: json["agefrom"],
        ageto: json["ageto"],
        status: json["status"],
        statusChange: json["status_change"],
        timeOut: json["time_out"],
        lastUpdateAt: json["last_update_at"],
        lastMomentAt: json["last_moment_at"],
        lastSeenAt: json["last_seen_at"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        createdAt: json["created_at"],
        createdIp: json["created_ip"],
        offset: json["offset"],
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "public_key": publicKey,
        "secret_key": secretKey,
        "nickname": nickname,
        "gender": gender,
        "age": age,
        "findgender": findgender,
        "agefrom": agefrom,
        "ageto": ageto,
        "status": status,
        "status_change": statusChange,
        "time_out": timeOut,
        "last_update_at": lastUpdateAt,
        "last_moment_at": lastMomentAt,
        "last_seen_at": lastSeenAt,
        "latitude": latitude,
        "longitude": longitude,
        "created_at": createdAt,
        "created_ip": createdIp,
        "offset": offset,
    };
}

NearByUsers nearByUsersFromJson(String str) => NearByUsers.fromJson(json.decode(str));
String nearByUsersToJson(NearByUsers data) => json.encode(data.toJson());

class NearByUsers {
    bool? response;
    bool? status;
    DataNBU? data;

    NearByUsers({
        this.response,
        this.status,
        this.data,
    });

    factory NearByUsers.fromJson(Map<String, dynamic> json) => NearByUsers(
        response: json["response"],
        status: json["status"],
        data: json["data"] == null ? null : DataNBU.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "response": response,
        "status": status,
        "data": data?.toJson(),
    };
}

class DataNBU {
    List<Recipient>? nearby;

    DataNBU({
        this.nearby,
    });

    factory DataNBU.fromJson(Map<String, dynamic> json) => DataNBU(
        nearby: json["nearby"] == null ? [] : List<Recipient>.from(json["nearby"]!.map((x) => Recipient.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "nearby": nearby == null ? [] : List<dynamic>.from(nearby!.map((x) => x.toJson())),
    };
}


InitializeChat initializeChatFromJson(String str) => InitializeChat.fromJson(json.decode(str));
String initializeChatToJson(InitializeChat data) => json.encode(data.toJson());

class InitializeChat {
    bool? response;
    bool? status;
    DataIC? data;

    InitializeChat({
        this.response,
        this.status,
        this.data,
    });

    factory InitializeChat.fromJson(Map<String, dynamic> json) => InitializeChat(
        response: json["response"],
        status: json["status"],
        data: json["data"] == null ? null : DataIC.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "response": response,
        "status": status,
        "data": data?.toJson(),
    };
}

class DataIC {
    Map<String, Room>? rooms;
   // Map<String, Recipient>? users;
    //Map<String, Chat>? chats;
   // Map<String, List<Message>>? messages;

    DataIC({
        this.rooms,
       // this.users,
      //  this.messages,
      //  this.chats,
    });

    factory DataIC.fromJson(Map<String, dynamic> json) => DataIC(
        rooms: Map.from(json["rooms"]??{}).map((k, v) => MapEntry<String, Room>(k, Room.fromJson(v))),
       // users: Map.from(json["users"]??{}).map((k, v) => MapEntry<String, Recipient>(k, Recipient.fromJson(v))),
      //  chats: Map.from(json["chats"]??{}).map((k, v) => MapEntry<String, Chat>(k, Chat.fromJson(v))),
      //  messages: Map.from(json["messages"]??{}).map((k, v) => MapEntry<String, List<Message>>(k, List<Message>.from(v.map((x) => Message.fromJson(x))))),
    );

    Map<String, dynamic> toJson() => {
        "rooms": Map.from(rooms!).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
       // "users": Map.from(users!).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
      //  "chats": Map.from(chats!).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
      //  "messages": Map.from(messages!).map((k, v) => MapEntry<String, dynamic>(k, List<dynamic>.from(v.map((x) => x.toJson())))),
    };
}

StreamChat streamChatFromJson(String str) => StreamChat.fromJson(json.decode(str));
String streamChatToJson(StreamChat data) => json.encode(data.toJson());


class StreamChat {
    bool? response;
    bool? status;
    DataSC? data;

    StreamChat({
        this.response,
        this.status,
        this.data,
    });

    factory StreamChat.fromJson(Map<String, dynamic> json) => StreamChat(
        response: json["response"],
        status: json["status"],
        data: json["data"] == null ? null : DataSC.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "response": response,
        "status": status,
        "data": data?.toJson(),
    };
}

class DataSC {
    Map<String, Recipient>? users;
    Map<String, Chat>? chats;
    Map<String, Map<String, Message>>? messages;
    List<AllPush>? allPush;

    DataSC({
        this.users,
        this.chats,
        this.messages,
        this.allPush,
    });

    factory DataSC.fromJson(Map<String, dynamic> json) => DataSC(
      users: Map.from(json["users"]??{}).map((k, v) => MapEntry<String, Recipient>(k, Recipient.fromJson(v))),
      chats: Map.from(json["chats"]??{}).map((k, v) => MapEntry<String, Chat>(k, Chat.fromJson(v))),
      messages: Map.from(json["messages"]??{}).map((k, v) => MapEntry<String, Map<String, Message>>(k, Map.from(v).map((k, v) => MapEntry<String, Message>(k, Message.fromJson(v))))),
      allPush: json["all_push"] == null ? [] : List<AllPush>.from(json["all_push"]!.map((x) => AllPush.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
     "users": Map.from(users!).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
     "chats": Map.from(chats!).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
     "messages": Map.from(messages!).map((k, v) => MapEntry<String, dynamic>(k, Map.from(v).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())))),
     "all_push": allPush == null ? [] : List<dynamic>.from(allPush!.map((x) => x.toJson())),
    };
}



class AllPush {
    String? pushId;
    String? userId;
    String? parentId;
    String? parentType;
    String? subId;

    AllPush({
        this.pushId,
        this.userId,
        this.parentId,
        this.parentType,
        this.subId,
    });

    factory AllPush.fromJson(Map<String, dynamic> json) => AllPush(
        pushId: json["push_id"],
        userId: json["user_id"],
        parentId: json["parent_id"],
        parentType: json["parent_type"],
        subId: json["sub_id"],
    );

    Map<String, dynamic> toJson() => {
        "push_id": pushId,
        "user_id": userId,
        "parent_id": parentId,
        "parent_type": parentType,
        "sub_Id": subId,
    };
}



Profileinfo profileinfoFromJson(String str) => Profileinfo.fromJson(json.decode(str));
String profileinfoToJson(Profileinfo data) => json.encode(data.toJson());

class Profileinfo {
    bool? response;
    bool? status;
    Recipient? data;

    Profileinfo({
        this.response,
        this.status,
        this.data,
    });

    factory Profileinfo.fromJson(Map<String, dynamic> json) => Profileinfo(
        response: json["response"],
        status: json["status"],
        data: json["data"] == false ? null : Recipient.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "response": response,
        "status": status,
        "data": data?.toJson(),
    };
}


Recipient recipientFromJson(String str) => Recipient.fromJson(json.decode(str));
String recipientToJson(Recipient data) => json.encode(data.toJson());

class Recipient {
    String? userId;
    String? publicKey;
    String? nickname;
    String? gender;
    String? age;
    String? findgender;
    String? agefrom;
    String? ageto;
    String? status;
    String? lastSeen;
    String? distance;
    String? chatRequest;

    Recipient({
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
    });

    factory Recipient.fromJson(Map<String, dynamic> json) => Recipient(
        userId: json["user_id"],
        publicKey: json["public_key"],
        nickname: json["nickname"],
        gender: json["gender"],
        age: json["age"],
        findgender: json["findgender"],
        agefrom: json["agefrom"],
        ageto: json["ageto"],
        status: json["status"],
        lastSeen: json["last_seen"],
        distance: json["distance"],
        chatRequest: json["chat_request"].toString(),
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "public_key": publicKey,
        "nickname": nickname,
        "gender": gender,
        "age": age,
        "findgender": findgender,
        "agefrom": agefrom,
        "ageto": ageto,
        "status": status,
        "last_seen": lastSeen,
        "distance": distance,
        "chat_request": chatRequest,
    };
}



Conversationinfo conversationinfoFromJson(String str) => Conversationinfo.fromJson(json.decode(str));
String conversationinfoToJson(Conversationinfo data) => json.encode(data.toJson());

class Conversationinfo {
    bool? response;
    bool? status;
    Chat? data;

    Conversationinfo({
        this.response,
        this.status,
        this.data,
    });

    factory Conversationinfo.fromJson(Map<String, dynamic> json) => Conversationinfo(
        response: json["response"],
        status: json["status"],
        data: json["data"] == false ? null : Chat.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "response": response,
        "status": status,
        "data": data?.toJson(),
    };
}


Chat chatFromJson(String str) => Chat.fromJson(json.decode(str));
String chatToJson(Chat data) => json.encode(data.toJson());

class Chat {
    String? chatId;
    String? roomId;
    String? userId;
    String? recipientId;
    String? startedAt;
    String? totalParticipants;
    String? totalMessages;
    String? lastMessageAt;
    String? admin;
    String? joined;

    Chat({
        this.chatId,
        this.roomId,
        this.userId,
        this.recipientId,
        this.startedAt,
        this.totalParticipants,
        this.totalMessages,
        this.lastMessageAt,
        this.admin,
        this.joined,
    });

    factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        chatId: json["chat_id"],
        roomId: json["room_id"],
        userId: json["user_id"],
        recipientId: json["recipient_id"],
        startedAt: json["started_at"],
        totalParticipants: json["total_participants"],
        totalMessages: json["total_messages"],
        lastMessageAt: json["last_message_at"],
        admin: json["admin"],
        joined: json["joined"],
    );

    Map<String, dynamic> toJson() => {
        "chat_id": chatId,
        "room_id": roomId,
        "user_id": userId,
        "recipient_id": recipientId,
        "started_at": startedAt,
        "total_participants": totalParticipants,
        "total_messages": totalMessages,
        "last_message_at": lastMessageAt,
        "admin": admin,
        "joined": joined,
    };
}


Message messageFromJson(String str) => Message.fromJson(json.decode(str));
String messageToJson(Message data) => json.encode(data.toJson());

class Message {
    String? messageId;
    String? chatId;
    String? userId;
    String? messageType;
    String? messageContent;
    String? messageStatus;
    String? token;
    String? sentAt;
    String? deliveredAt;
    String? readAt;

    Message({
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
    });

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        messageId: json["message_id"],
        chatId: json["chat_id"],
        userId: json["user_id"],
        messageType: json["message_type"],
        messageContent: json["message_content"],
        messageStatus: json["message_status"],
        token: json["token"],
        sentAt: json["sent_at"],
        deliveredAt: json["delivered_at"],
        readAt: json["read_at"],
    );

    Map<String, dynamic> toJson() => {
        "message_id": messageId,
        "chat_id": chatId,
        "user_id": userId,
        "message_type": messageType,
        "message_content": messageContent,
        "message_status": messageStatus,
        "token": token,
        "sent_at": sentAt,
        "delivered_at": deliveredAt,
        "read_at": readAt,
    };
}


Room roomFromJson(String str) => Room.fromJson(json.decode(str));
String roomToJson(Room data) => json.encode(data.toJson());

class Room {
    String? roomId;
    String? title;
    String? lastEntryAt;
    String? lastExitAt;
    String? totalUsers;
    String? admin;
    String? joined;

    Room({
        this.roomId,
        this.title,
        this.lastEntryAt,
        this.lastExitAt,
        this.totalUsers,
        this.admin,
        this.joined,
    });

    factory Room.fromJson(Map<String, dynamic> json) => Room(
        roomId: json["room_id"],
        title: json["title"],
        lastEntryAt: json["last_entry_at"],
        lastExitAt: json["last_exit_at"],
        totalUsers: json["total_users"],
        admin: json["admin"],
        joined: json["joined"],
    );

    Map<String, dynamic> toJson() => {
        "room_id": roomId,
        "title": title,
        "last_entry_at": lastEntryAt,
        "last_exit_at": lastExitAt,
        "total_users": totalUsers,
        "admin": admin,
        "joined": joined,
    };
}

