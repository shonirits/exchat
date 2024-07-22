import '../../models/hive.dart';
import 'package:flutter/material.dart';
import '../../helpers/colors.dart';
import '../../../main.dart';
import '../../helpers/user.dart';
import '../../helpers/common.dart';

//card to represent a single user in home screen
class ChatAcceptCard extends StatefulWidget {
  final id;
  final notification;
  final selfInfo;

  const ChatAcceptCard({super.key, required int this.id, required this.notification, this.selfInfo});

  @override
  State<ChatAcceptCard> createState() => _ChatAcceptCardState();
}

class _ChatAcceptCardState extends State<ChatAcceptCard> {

 var _mainTitle = '';
 var _mainDetails = '';
 var _subTitle = '';
 var _displayDP = '';
 var _genderDP = User.userGenderDP('Unknown');
 Color _bgColor = tertiaryTextColor;


  @override
  Widget build(BuildContext context) {

    final int _id = widget.id;
    final _notification = widget.notification;
    final _selfInfo = widget.selfInfo;

    _subTitle = momentTime(_notification.addedAt, true);


    if(_notification.notificationStatus == '0'){
      _bgColor = infoTextColor;

      final box = NotificationsBox.getData();
          final row = box.getAt(_id);
          row?.notificationStatus = '1';
          row?.save();
      
    }

     final userBox = UsersBox.getData();

    final isUserExist = userBox.values.where((elementRoom) => elementRoom.userId == _notification.parentId);

    if(isUserExist.isNotEmpty){

                final userRow =  isUserExist.first;

                setState(() {            
                
                 _mainTitle = userRow.nickname!;
                 _mainDetails = 'accepted your chat request.';
                 _genderDP = User.userGenderDP(userRow.gender);

                });

    }

    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 0.5, horizontal: 1.0),
      shape: const RoundedRectangleBorder(),
      clipBehavior: Clip.hardEdge,
      color: _bgColor,
      elevation: 0,
      child: ListTile(
          mouseCursor: MouseCursor.defer,
            dense: true,
            onTap: (){
              
            },
                //user profile picture
                leading:  ClipRRect(
                    borderRadius: BorderRadius.circular(mq.height * .09),
                    child: Image.asset(_genderDP),
                  ),
                //user name
                title: RichText(
                  text: TextSpan(
                      children: [
                        TextSpan(
                            text: '$_mainTitle ',
                            style: TextStyle(color: primaryBGColor, fontWeight: FontWeight.w500)
                            ),
                             TextSpan(
                            text: _mainDetails,
                            style: TextStyle(color: secondaryBGColor)
                            ),
                          ]),
                ),
                //last message
                subtitle: Text(
                    _subTitle,
                    style: TextStyle(
                  color: quaternaryBGColor
                  ),
                    overflow: TextOverflow.fade,
                    maxLines: 1),              
              )
      
    );
  }
}
