import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../helpers/colors.dart';
import '../../main.dart';
import 'login_form_screen.dart';
import '../helpers/user.dart';
import 'mobile_layout_screen.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/hive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool _isAnimate = false;

  @override
  void initState() {
    super.initState();

    _loadDefault();

    //for auto triggering animation
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() => _isAnimate = true);
    });
  }

  Future<dynamic> _loadDefault() async {
    
   await Hive.openBox<SelfInfoModel>('self');
   await Hive.openBox<RoomsInfoModel>('rooms');
   await Hive.openBox<ChatsInfoModel>('chats');
   await Hive.openBox<MessagesInfoModel>('messages');
   await Hive.openBox<NotificationsInfoModel>('notifications');
   await Hive.openBox<UsersInfoModel>('users');
   await Hive.openBox<TmpInfoModel>('tmp');
   await Hive.openBox('data');

    User().is_signed_in().then((status) {
      Future.delayed(Duration.zero, () {

        if (status == true) {
          //navigate to home screen
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => MobileLayoutScreen()),
                  (route) => false
          );

        }
      });

    });

  }

  @override
void setState(VoidCallback fn){
  if(mounted){
    super.setState(fn);
  }
}

 @override
  Widget build(BuildContext context) {
    //initializing media query (for getting device screen size)
    mq = MediaQuery.of(context).size;

    return Scaffold(
           //body
      body: Stack(children: [
        //app logo
        AnimatedPositioned(
            top: mq.height * .10,
            right: _isAnimate ? mq.width * .30 : -mq.width * .4,
            width: mq.width * .4,
            duration: const Duration(seconds: 1),
            child: Image.asset('media/images/login-screen-logo.png')),

             //user text
        Positioned(
            bottom: mq.height * .25,
            left: mq.width * .05,
            width: mq.width * .9,
            height: mq.height * .08,
            child: RichText(
                  text: const TextSpan(
                      style: TextStyle(color: secondaryTextColor, fontSize: 15),
                      children: [
                        TextSpan(text: 'exChat use FishingCab.com API and By clicking'),
                        TextSpan(
                            text: ' "ENTER" ',
                            style: TextStyle(fontWeight: FontWeight.w500)
                            ),
                            TextSpan(text: ', I am over '),
                             TextSpan(
                            text: ' "18+" ',
                            style: TextStyle(fontWeight: FontWeight.w500)
                            ),
                            TextSpan(text: 'and '),
                            TextSpan(
                            text: '"AGREE"',
                            style: TextStyle(fontWeight: FontWeight.w500)
                            ),
                            TextSpan(text: ' to FishingCab.com all terms and policy.'),
                      ]),
                )),

        //google login button
        Positioned(
            bottom: mq.height * .10,
            left: mq.width * .05,
            width: mq.width * .9,
            height: mq.height * .06,
            child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    backgroundColor: highlightBGColor,
                    shape: const StadiumBorder(),
                    elevation: 1),

                // on tap
                onPressed: (){

                   Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const LoginFormScreen()));
                },

                //google icon
                icon: const FaIcon(FontAwesomeIcons.rightToBracket, size: 24, color: primaryTextColor,),

                //login with google label
                label: RichText(
                  text: const TextSpan(
                      style: TextStyle(color: primaryTextColor, fontSize: 16),
                      children: [
                        TextSpan(
                            text: 'ENTER',
                            style: TextStyle(fontWeight: FontWeight.w500)),
                      ]),
                ))),
      ]),
    );
  }
}