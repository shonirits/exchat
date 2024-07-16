import 'package:flutter/material.dart';
import '../../main.dart';
import '../helpers/user.dart';
import '../helpers/colors.dart';
import '../widgets/custom_utilities.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Dialogs {
  static void showSnackbar(BuildContext context, String msg, Color bgc, Color txc) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg,
        style: TextStyle(color: txc),
        ),
        backgroundColor: bgc.withOpacity(.8),
        behavior: SnackBarBehavior.floating));
  }

  static void showProgressBar(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => const Center(
                child: CircularProgressIndicator(
              strokeWidth: 1,
            )));
  }
}

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({super.key, required this.user});

  final user;

  @override
  Widget build(BuildContext context) {

    final _userGenderDP = User.userGenderDP(user.gender);
    final _userStatusColor = User.userStatusColor(user.status);

    return AlertDialog(
      alignment: Alignment.topCenter,
      titlePadding: const EdgeInsets.all(7.0),
      contentPadding: const EdgeInsets.all(7.0),
      actionsPadding: const EdgeInsets.all(7.0),
      backgroundColor: highlightBGColor.withOpacity(.7),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Center(child: Column(
        children: <Widget>[
          CircleAvatar(
                radius: 75,
                backgroundColor: _userStatusColor,
                child: Padding(
                  padding: const EdgeInsets.all(3), // Border radius
                  child: ClipOval(child: Image.asset(_userGenderDP)),
                ),
              ),
              const Divider(
          height: 20,
          color: tertiaryBGColor,
          thickness: 3,
          indent : 3,
          endIndent : 3,
        ),
        ],
      )),
      content: SingleChildScrollView(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
          children:  <Widget>[    
             const Text('About',
              style: TextStyle(color: primaryTextColor, fontSize: 17, fontWeight: FontWeight.bold)),
                SizedBox(width: mq.width, height: mq.height * .02),
                        RichText(
                    text: TextSpan(
                        style: TextStyle(color: secondaryTextColor, fontSize: 15),
                        children: [
                          TextSpan(
                              text: ' Nickname:  ',
                              style: TextStyle(fontWeight: FontWeight.w500)
                              ),
                          TextSpan(text: user.nickname),
                        ]),
                  ),
                  SizedBox(width: mq.width, height: mq.height * .02),
                  RichText(
                    text: TextSpan(
                        style: TextStyle(color: secondaryTextColor, fontSize: 15),
                        children: [
                          TextSpan(
                              text: ' Gender:  ',
                              style: TextStyle(fontWeight: FontWeight.w500)
                              ),
                          TextSpan(text: user.gender),
                        ]),
                  ),
                  SizedBox(width: mq.width, height: mq.height * .02),
                  RichText(
                    text: TextSpan(
                        style: TextStyle(color: secondaryTextColor, fontSize: 15),
                        children: [
                          TextSpan(
                              text: ' Age:  ',
                              style: TextStyle(fontWeight: FontWeight.w500)
                              ),
                          TextSpan(text: user.age),
                        ]),
                  ),  
                  SizedBox(width: mq.width, height: mq.height * .02),
                  RichText(
                    text: TextSpan(
                        style: TextStyle(color: secondaryTextColor, fontSize: 15),
                        children: [
                          TextSpan(
                              text: ' Last Seen:  ',
                              style: TextStyle(fontWeight: FontWeight.w500)
                              ),
                          TextSpan(text: user.lastSeen),
                        ]),
                  ), 
                  SizedBox(width: mq.width, height: mq.height * .02),
                  RichText(
                    text: TextSpan(
                        style: TextStyle(color: secondaryTextColor, fontSize: 15),
                        children: [
                          TextSpan(
                              text: ' Distance:  ',
                              style: TextStyle(fontWeight: FontWeight.w500)
                              ),
                          TextSpan(text: user.distance),
                        ]),
                  ),               
                  const Divider(
                      height: 20,
                      color: tertiaryBGColor,
                      thickness: 3,
                      indent : 3,
                      endIndent : 3,
                    ),
                   const Text('Interest',
              style: TextStyle(color: primaryTextColor, fontSize: 17, fontWeight: FontWeight.bold)),
                 SizedBox(width: mq.width, height: mq.height * .02),
                  RichText(
                    text: TextSpan(
                        style: TextStyle(color: secondaryTextColor, fontSize: 15),
                        children: [
                          TextSpan(
                              text: ' Gender:  ',
                              style: TextStyle(fontWeight: FontWeight.w500)
                              ),
                          TextSpan(text: user.findgender),
                        ]),
                  ),
                  SizedBox(width: mq.width, height: mq.height * .02),
                  RichText(
                    text: TextSpan(
                        style: TextStyle(color: secondaryTextColor, fontSize: 15),
                        children: [
                          TextSpan(
                              text: ' Age:  ',
                              style: TextStyle(fontWeight: FontWeight.w500)
                              ),
                          TextSpan(text: user.agefrom),
                          TextSpan(text: ' - '),
                          TextSpan(text: user.ageto),
                        ]),
                  ),               
          ],
        ),
      ),
      actions: <Widget>[
              Center(
                child: CustomButton(
        icon: FontAwesomeIcons.circleXmark,
        side: 'left',
        text: 'CLOSE',
        bgColor: primaryBGColor,
        textColor: secondaryTextColor,
        onPressed: () => {
          Navigator.of(context).pop()
        },
      ),
              )
            ],
    );
  }
}
