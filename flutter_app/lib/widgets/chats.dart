import 'package:flutter/material.dart';
import '../helpers/colors.dart';
import '../../main.dart';
import '../helpers/user.dart';
import '../helpers/common.dart';
import '../models/hive.dart';
import '../screens/chat_screen.dart';

//card to represent a single user in home screen
class ChatsCard extends StatefulWidget {
  final id;
  final chat;
  final selfInfo;

  const ChatsCard({super.key, required int this.id, required this.chat, this.selfInfo});

  @override
  State<ChatsCard> createState() => _ChatsCardState();
}

class _ChatsCardState extends State<ChatsCard> {


 int _unRead = 0;

 var _chatTitle = '';
 var _subTitle = '';
 var _genderDP = User.userGenderDP('Unknown');
 var _userID = '0';
 

    void _countUnRead(userId, chatId) {

      final watchMessagesBox = MessagesBox.getData();   

              final isNewMessageExist = watchMessagesBox.values.where((elementMessage) => elementMessage.userId != userId && elementMessage.messageStatus != '3' && elementMessage.chatId == chatId);

               if(isNewMessageExist.isNotEmpty){

                setState(() {
                  _unRead = isNewMessageExist.length;
                });                              

                }else{

                  setState(() {
                  _unRead = 0;
                });
                
                }
       
      }


  @override
  Widget build(BuildContext context) {

    final int _id = widget.id;
    final _chat = widget.chat;
    final _selfInfo = widget.selfInfo;

    if(_selfInfo?.userId == _chat.userId){
    _userID = _chat.recipientId;
    }else{
     _userID = _chat.userId; 
    }

    _countUnRead(_selfInfo?.userId, _chat.chatId);


    if(_chat.roomId != '0'){

    final roomBox = RoomsBox.getData();

    final isRoomExist = roomBox.values.where((elementRoom) => elementRoom.roomId == _chat.roomId);

    if(isRoomExist.isNotEmpty){

                final roomRow =  isRoomExist.first;

                setState(() {            
                
                 _chatTitle = roomRow.title!;
                 _subTitle = _chat.totalParticipants!;
                 _genderDP = User.userGenderDP('Room');

                });

    }

    }else{


     if(_userID != '0') {

    final userBox = UsersBox.getData();

    final isUserExist = userBox.values.where((elementRoom) => elementRoom.userId == _userID);

    if(isUserExist.isNotEmpty){

                final userRow =  isUserExist.first;

                setState(() {            
                
                 _chatTitle = userRow.nickname!;
                 _subTitle = userRow.distance!;
                 _genderDP = User.userGenderDP(userRow.gender);

                });

    }

     }


    }

    

    final String _unReadStr = (_unRead > 99) ? '99+' : _unRead.toString();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 0.5, horizontal: 1.0),
      shape: const RoundedRectangleBorder(),
      clipBehavior: Clip.hardEdge,
      color: tertiaryBGColor,
      elevation: 0,
      child: ListTile(
          mouseCursor: MouseCursor.defer,
            dense: true,
            onTap: (){

              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ChatScreen(id: _id, chat: _chat, selfInfo: _selfInfo)));
            },
                //user profile picture
                leading:  ClipRRect(
                    borderRadius: BorderRadius.circular(mq.height * .09),
                    child: Image.asset(_genderDP),
                  ),
                //user name
                title: Text(_chatTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: primaryTextColor
                  ),
                overflow: TextOverflow.fade,
                    maxLines: 1),
                //last message
                subtitle: Text(
                    _subTitle,
                    style: const TextStyle(
                  color: secondaryTextColor
                  ),
                    overflow: TextOverflow.fade,
                    maxLines: 1),

                //last message time
                trailing:  Column(children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                    child: Text(localTime(_chat.lastMessageAt),
                      style: const TextStyle(
                    color: quaternaryTextColor
                    ),
                      maxLines: 1),
                  ),
                  if(_unRead > 0 ) ...[
                    Badge(
                      backgroundColor: infoTextColor,
                      label: Text(_unReadStr, style: const TextStyle(
                      color: highlightTextColor
                  ),
                    overflow: TextOverflow.fade,
                    maxLines: 1),
                    )
                  ],                  
                ],),
              )
      
    );
  }
}
