import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../helpers/colors.dart';
import '../../../main.dart';
import '../../helpers/user.dart';
import '../models/hive.dart';

//card to represent a single user in home screen
class NotificationsCard extends StatefulWidget {
  final id;
  final notification;
  final selfInfo;

  const NotificationsCard({super.key, required int this.id, required this.notification, this.selfInfo});

  @override
  State<NotificationsCard> createState() => _NotificationsCardState();
}

class _NotificationsCardState extends State<NotificationsCard> {


 var _mainTitle = '';
 var _mainDetails = '';
 var _subTitle = '';
 var _displayDP = '';
 var _genderDP = User.userGenderDP('Unknown');
 bool actionIcon = false;



  @override
  Widget build(BuildContext context) {

    final int _id = widget.id;
    final _notification = widget.notification;
    final _selfInfo = widget.selfInfo;

    if(_notification.parentType == 'chat_accept'){


      final userBox = UsersBox.getData();

    final isUserExist = userBox.values.where((elementRoom) => elementRoom.userId == _notification.parentId);

    if(isUserExist.isNotEmpty){

                final userRow =  isUserExist.first;

                setState(() {            
                
                 _mainTitle = userRow.nickname!;
                 _mainDetails = 'accept your chat request.';
                 _subTitle = userRow.distance!;
                 _genderDP = User.userGenderDP(userRow.gender);

                });

    }

      }else if(_notification.parentType == 'chat_request'){


          final userBox = UsersBox.getData();

    final isUserExist = userBox.values.where((elementRoom) => elementRoom.userId == _notification.parentId);

    if(isUserExist.isNotEmpty){

                final userRow =  isUserExist.first;

                setState(() {            
                
                 _mainTitle = userRow.nickname!;
                 _mainDetails = 'send you chat request.';
                 _subTitle = userRow.distance!;
                 _genderDP = User.userGenderDP(userRow.gender);

                });

    }



      }

    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 0.5, horizontal: 1.0),
      shape: const RoundedRectangleBorder(),
      clipBehavior: Clip.hardEdge,
      color: tertiaryTextColor,
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
                  
                  trailing: (actionIcon)?InkWell(
                  hoverColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {             

                   },
                  child: FaIcon(FontAwesomeIcons.check, size: 25, color: successBGColor,),
                ):Text('ok'),              
              )
      
    );
  }
}
