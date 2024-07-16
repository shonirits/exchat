// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SelfInfoModelAdapter extends TypeAdapter<SelfInfoModel> {
  @override
  final int typeId = 0;

  @override
  SelfInfoModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SelfInfoModel(
      userId: fields[0] as String?,
      publicKey: fields[1] as String?,
      secretKey: fields[2] as String?,
      nickname: fields[3] as String?,
      gender: fields[4] as String?,
      age: fields[5] as String?,
      findgender: fields[6] as String?,
      agefrom: fields[7] as String?,
      ageto: fields[8] as String?,
      status: fields[9] as String?,
      statusChange: fields[10] as String?,
      timeOut: fields[11] as String?,
      lastUpdateAt: fields[12] as String?,
      lastMomentAt: fields[13] as String?,
      lastSeenAt: fields[14] as String?,
      latitude: fields[15] as String?,
      longitude: fields[16] as String?,
      createdAt: fields[17] as String?,
      createdIp: fields[18] as String?,
      offset: fields[19] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SelfInfoModel obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.publicKey)
      ..writeByte(2)
      ..write(obj.secretKey)
      ..writeByte(3)
      ..write(obj.nickname)
      ..writeByte(4)
      ..write(obj.gender)
      ..writeByte(5)
      ..write(obj.age)
      ..writeByte(6)
      ..write(obj.findgender)
      ..writeByte(7)
      ..write(obj.agefrom)
      ..writeByte(8)
      ..write(obj.ageto)
      ..writeByte(9)
      ..write(obj.status)
      ..writeByte(10)
      ..write(obj.statusChange)
      ..writeByte(11)
      ..write(obj.timeOut)
      ..writeByte(12)
      ..write(obj.lastUpdateAt)
      ..writeByte(13)
      ..write(obj.lastMomentAt)
      ..writeByte(14)
      ..write(obj.lastSeenAt)
      ..writeByte(15)
      ..write(obj.latitude)
      ..writeByte(16)
      ..write(obj.longitude)
      ..writeByte(17)
      ..write(obj.createdAt)
      ..writeByte(18)
      ..write(obj.createdIp)
      ..writeByte(19)
      ..write(obj.offset);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SelfInfoModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RoomsInfoModelAdapter extends TypeAdapter<RoomsInfoModel> {
  @override
  final int typeId = 1;

  @override
  RoomsInfoModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RoomsInfoModel(
      roomId: fields[0] as String?,
      title: fields[1] as String?,
      lastEntryAt: fields[2] as String?,
      lastExitAt: fields[3] as String?,
      totalUsers: fields[4] as String?,
      joined: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, RoomsInfoModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.roomId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.lastEntryAt)
      ..writeByte(3)
      ..write(obj.lastExitAt)
      ..writeByte(4)
      ..write(obj.totalUsers)
      ..writeByte(5)
      ..write(obj.joined);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoomsInfoModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChatsInfoModelAdapter extends TypeAdapter<ChatsInfoModel> {
  @override
  final int typeId = 2;

  @override
  ChatsInfoModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatsInfoModel(
      chatId: fields[0] as String?,
      roomId: fields[1] as String?,
      userId: fields[2] as String?,
      recipientId: fields[3] as String?,
      startedAt: fields[4] as String?,
      totalParticipants: fields[5] as String?,
      totalMessages: fields[6] as String?,
      lastMessageAt: fields[7] as String?,
      joined: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ChatsInfoModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.chatId)
      ..writeByte(1)
      ..write(obj.roomId)
      ..writeByte(2)
      ..write(obj.userId)
      ..writeByte(3)
      ..write(obj.recipientId)
      ..writeByte(4)
      ..write(obj.startedAt)
      ..writeByte(5)
      ..write(obj.totalParticipants)
      ..writeByte(6)
      ..write(obj.totalMessages)
      ..writeByte(7)
      ..write(obj.lastMessageAt)
      ..writeByte(8)
      ..write(obj.joined);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatsInfoModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MessagesInfoModelAdapter extends TypeAdapter<MessagesInfoModel> {
  @override
  final int typeId = 3;

  @override
  MessagesInfoModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MessagesInfoModel(
      messageId: fields[0] as String?,
      chatId: fields[1] as String?,
      userId: fields[2] as String?,
      messageType: fields[3] as String?,
      messageContent: fields[4] as String?,
      messageStatus: fields[5] as String?,
      token: fields[6] as String?,
      sentAt: fields[7] as String?,
      deliveredAt: fields[8] as String?,
      readAt: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MessagesInfoModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.messageId)
      ..writeByte(1)
      ..write(obj.chatId)
      ..writeByte(2)
      ..write(obj.userId)
      ..writeByte(3)
      ..write(obj.messageType)
      ..writeByte(4)
      ..write(obj.messageContent)
      ..writeByte(5)
      ..write(obj.messageStatus)
      ..writeByte(6)
      ..write(obj.token)
      ..writeByte(7)
      ..write(obj.sentAt)
      ..writeByte(8)
      ..write(obj.deliveredAt)
      ..writeByte(9)
      ..write(obj.readAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessagesInfoModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NotificationsInfoModelAdapter
    extends TypeAdapter<NotificationsInfoModel> {
  @override
  final int typeId = 4;

  @override
  NotificationsInfoModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationsInfoModel(
      notificationId: fields[0] as String?,
      userId: fields[1] as String?,
      parentId: fields[2] as String?,
      parentType: fields[3] as String?,
      subId: fields[4] as String?,
      notificationStatus: fields[5] as String?,
      addedAt: fields[6] as String?,
      updatedAt: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, NotificationsInfoModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.notificationId)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.parentId)
      ..writeByte(3)
      ..write(obj.parentType)
      ..writeByte(4)
      ..write(obj.subId)
      ..writeByte(5)
      ..write(obj.notificationStatus)
      ..writeByte(6)
      ..write(obj.addedAt)
      ..writeByte(7)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationsInfoModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UsersInfoModelAdapter extends TypeAdapter<UsersInfoModel> {
  @override
  final int typeId = 5;

  @override
  UsersInfoModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UsersInfoModel(
      userId: fields[0] as String?,
      publicKey: fields[1] as String?,
      nickname: fields[2] as String?,
      gender: fields[3] as String?,
      age: fields[4] as String?,
      findgender: fields[5] as String?,
      agefrom: fields[6] as String?,
      ageto: fields[7] as String?,
      status: fields[8] as String?,
      lastSeen: fields[9] as String?,
      distance: fields[10] as String?,
      chatRequest: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UsersInfoModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.publicKey)
      ..writeByte(2)
      ..write(obj.nickname)
      ..writeByte(3)
      ..write(obj.gender)
      ..writeByte(4)
      ..write(obj.age)
      ..writeByte(5)
      ..write(obj.findgender)
      ..writeByte(6)
      ..write(obj.agefrom)
      ..writeByte(7)
      ..write(obj.ageto)
      ..writeByte(8)
      ..write(obj.status)
      ..writeByte(9)
      ..write(obj.lastSeen)
      ..writeByte(10)
      ..write(obj.distance)
      ..writeByte(11)
      ..write(obj.chatRequest);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UsersInfoModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TmpInfoModelAdapter extends TypeAdapter<TmpInfoModel> {
  @override
  final int typeId = 6;

  @override
  TmpInfoModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TmpInfoModel(
      tmpId: fields[0] as String?,
      data: fields[1] as String?,
      addTime: fields[2] as String?,
      status: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TmpInfoModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.tmpId)
      ..writeByte(1)
      ..write(obj.data)
      ..writeByte(2)
      ..write(obj.addTime)
      ..writeByte(3)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TmpInfoModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
