import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../common/config.dart';
import '../helpers/colors.dart';
import '../../main.dart';
import '../helpers/user.dart';
import '../helpers/dialogs.dart';
import '../helpers/api.dart';

//card to represent a single user in home screen
class NearByUserCard extends StatefulWidget {
  final user;
  final selfInfo;

  const NearByUserCard({super.key, required this.user, this.selfInfo});

  @override
  State<NearByUserCard> createState() => _NearByUserCardState();
}

class _NearByUserCardState extends State<NearByUserCard> {
 bool _isSent = false;


 Future<bool> _chatRequest(selfInfo, userId) async {

        if(selfInfo != null){

          try {

        final sendchatRequest = await Api().getUrl('${apiUrl}chat?app_public_key=$apiPublicKey&app_secret_key=$apiSecretKey&user_public_key=${selfInfo!.publicKey}&user_secret_key=${selfInfo!.secretKey}&do=chat_request&id=$userId');

        if (sendchatRequest != null) { 

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

    final _user = widget.user;
    final _selfInfo = widget.selfInfo;
    var _message;   

    final _userGenderDP = User.userGenderDP(_user.gender);

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
                leading: InkWell(
                  onTap: () {
                    showDialog(
                      barrierDismissible: true,
                        context: context,
                        builder: (BuildContext context){
                         return new ProfileDialog(user: _user);
                        }
                         );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(mq.height * .09),
                    child: Image.asset(_userGenderDP),
                  ),
                ),
                //user name
                title: Text(_user.nickname,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: primaryTextColor
                  ),
                overflow: TextOverflow.fade,
                    maxLines: 1),
                //last message
                subtitle: Text(
                    _user.distance,
                    style: TextStyle(
                  color: secondaryTextColor
                  ),
                    overflow: TextOverflow.fade,
                    maxLines: 1),

                //last message time
                trailing: (_isSent) ? const FaIcon(FontAwesomeIcons.hourglassHalf, size: 20, color: quaternaryTextColor,) : InkWell(
                  hoverColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {

                    _chatRequest(_selfInfo, _user.userId);

                    setState(() {
                      _isSent = true;
                    });                    
                  },
                  child: const FaIcon(FontAwesomeIcons.paperPlane, size: 20, color: primaryTextColor,),
                ),

              )
      
    );
  }
}
