import '../../models/hive.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../common/config.dart';
import '../../helpers/colors.dart';
import '../../../main.dart';
import '../../helpers/user.dart';
import '../../helpers/dialogs.dart';
import '../../helpers/api.dart';
import '../../helpers/common.dart';

//card to represent a single user in home screen
class ChatRequestCard extends StatefulWidget {
  final id;
  final notification;
  final selfInfo;

  const ChatRequestCard({super.key, required int this.id, required this.notification, this.selfInfo});

  @override
  State<ChatRequestCard> createState() => _ChatRequestCardState();
}

class _ChatRequestCardState extends State<ChatRequestCard> {


 var _mainTitle = '';
 var _mainDetails = '';
 var _subTitle = '';
 var _displayDP = '';
 var _genderDP = User.userGenderDP('Unknown');
 bool _isAccepted = false;
 Color _bgColor = tertiaryTextColor;


  
      Future<bool> _acceptChat(selfInfo, recipientId, id) async {

        if(selfInfo != null){

          try {

        final isAccepted = await Api().getUrl('${apiUrl}chat?app_public_key=$apiPublicKey&app_secret_key=$apiSecretKey&user_public_key=${selfInfo!.publicKey}&user_secret_key=${selfInfo!.secretKey}&do=chat_accept&id=$recipientId');

        if (isAccepted != null) { 

          final box = NotificationsBox.getData();
          final row = box.getAt(id);
          row?.notificationStatus = '2';
          row?.save();

          return true;         

        }else{

          Dialogs.showSnackbar(context, 'Server unable to complete request', errorBGColor, errorTextColor);

          return false;

        }

      } catch (e) {

        Dialogs.showSnackbar(context, 'Something Went Wrong (Check Internet!)', errorBGColor, errorTextColor);

        return false;

      }
          
        }else{

          Dialogs.showSnackbar(context, 'An unknown error has occurred', errorBGColor, errorTextColor);

        return false;
         
        }

      }


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


    if(_notification.notificationStatus == '2' && !_isAccepted){

    setState(() {  
    _isAccepted = true;
    });

    }

     final userBox = UsersBox.getData();

    final isUserExist = userBox.values.where((elementRoom) => elementRoom.userId == _notification.parentId);

    if(isUserExist.isNotEmpty){

                final userRow =  isUserExist.first;

                setState(() {            
                
                 _mainTitle = userRow.nickname!;
                 _mainDetails = 'send you chat request.';                 
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
                  
                  trailing: (_isAccepted) ? const FaIcon(FontAwesomeIcons.comment, size: 20, color: quaternaryTextColor,) : InkWell(
                  hoverColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {                  

                  _acceptChat(_selfInfo, _notification.parentId, _id);

                    setState(() {
                      _isAccepted = true;
                    });    

                  },
                  child: FaIcon(FontAwesomeIcons.check, size: 25, color: successBGColor,),
                ),              
              )
      
    );
  }
}
