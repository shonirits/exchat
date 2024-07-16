import '../models/hive.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../common/config.dart';
import '../helpers/colors.dart';
import '../../main.dart';
import '../helpers/user.dart';
import '../helpers/dialogs.dart';
import '../helpers/api.dart';

//card to represent a single user in home screen
class RoomsCard extends StatefulWidget {
  final id;
  final room;
  final selfInfo;

  const RoomsCard({super.key, required int this.id, required this.room, this.selfInfo});

  @override
  State<RoomsCard> createState() => _RoomsCardState();
}

class _RoomsCardState extends State<RoomsCard> {

 bool _isJoined = false;


 Future<bool> _joinRoom(selfInfo, roomId, id) async {

        if(selfInfo != null){

          try {

        final joinRoom = await Api().getUrl('${apiUrl}chat?app_public_key=$apiPublicKey&app_secret_key=$apiSecretKey&user_public_key=${selfInfo!.publicKey}&user_secret_key=${selfInfo!.secretKey}&do=join_room&id=$roomId');

        if (joinRoom != null) { 

          final box = RoomsBox.getData();

          final row = box.getAt(id);

          row?.joined = '1';

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
    final _room = widget.room;
    final _selfInfo = widget.selfInfo;
    var _message;   

    if(_room?.joined == '1'){
    _isJoined = true;
    }

    final _genderDP = User.userGenderDP('Room');

    return Card(
      margin: EdgeInsets.symmetric(vertical: 1),
      shape: RoundedRectangleBorder(),
      clipBehavior: Clip.hardEdge,
      color: tertiaryBGColor,
      elevation: 0,
      child: ListTile(
          mouseCursor: MouseCursor.defer,
            dense: true,
                //user profile picture
                leading:  ClipRRect(
                    borderRadius: BorderRadius.circular(mq.height * .09),
                    child: Image.asset(_genderDP),
                  ),
                //user name
                title: Text(_room?.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: primaryTextColor
                  ),
                overflow: TextOverflow.fade,
                    maxLines: 1),
                //last message
                subtitle: Text(
                    _room?.totalUsers,
                    style: TextStyle(
                  color: secondaryTextColor
                  ),
                    overflow: TextOverflow.fade,
                    maxLines: 1),

                //last message time
                trailing: (_isJoined) ? const FaIcon(FontAwesomeIcons.comment, size: 20, color: quaternaryTextColor,) : InkWell(
                  hoverColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {                  

                   _joinRoom(_selfInfo, _room?.roomId, _id);

                    setState(() {
                      _isJoined = true;
                    });    

                  },
                  child: FaIcon(FontAwesomeIcons.rightToBracket, size: 20, color: primaryTextColor,),
                ),

              )
      
    );
  }
}
