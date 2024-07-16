
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../common/config.dart';
import '../helpers/colors.dart';
import '../../main.dart';
import '../helpers/ext_str.dart';
import '../widgets/custom_utilities.dart';
import '../screens/login_verify_screen.dart';
import '../helpers/user.dart';
import 'mobile_layout_screen.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/hive.dart';


class LoginFormScreen extends StatefulWidget {
   const LoginFormScreen({super.key});

  @override
  State<LoginFormScreen> createState() => _LoginFormScreenState();
}

class _LoginFormScreenState extends State<LoginFormScreen> {

  final _formKey = GlobalKey<FormState>();
  String nickName = 'Hello';
  String userGender  = userGenders.first;
  String userAge  = ageFrom.toString();
  String findGender  = findGenders.first;
  int startAge = ageFrom+5;
  int endAge = ageTo-12;

   @override
  void initState() {
    super.initState();

    _loadDefault();
   
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

  List<DropdownMenuItem<String>> ageDropdownItems(){
    List<DropdownMenuItem<String>> dropdownitems = [];
    for (int i = ageFrom; i < ageTo; i++){
      var newItem = DropdownMenuItem(
      value: i.toString(),
        child: Text(i.toString()),
      );
      dropdownitems.add(newItem);
  }
    return dropdownitems;
  }

 @override
  Widget build(BuildContext context) {
    //initializing media query (for getting device screen size)
    mq = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
         //app bar
        appBar: AppBar(
          automaticallyImplyLeading: true,
           titleSpacing: 0,
          title: const Text('Welcome to exChat', style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Oswald',
                      fontWeight: FontWeight.bold,
                  color: logoColor
                  )),
        ),
        //body
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
      Form(
      key: _formKey,
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: mq.width, height: mq.height * .04),
        const Text('Your Information',
            style: TextStyle(color: primaryTextColor, fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(width: mq.width, height: mq.height * .03),
        const Text('FishingCab need your information.',
            style: TextStyle(color: secondaryTextColor, fontSize: 14)),
        SizedBox(width: mq.width, height: mq.height * .03),
      TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: const InputDecoration(
        prefixIcon: FaIcon(
        FontAwesomeIcons.signature,
      ),
      errorStyle: 
      TextStyle(
      fontFamily: 'Montserrat',
      color: Colors.red,
      fontSize: 15
      ),
      hintText: 'Enter your desire nickname',
      labelText: 'Nickname',
      ),
       validator: (String? input){
      if (input != null) {
         if (!input.isValidValue) {
            return 'Enter a valid nickname';
          }
         }
       return null;
       }, 
       onChanged: (String? value) {
              // This is called when the user change value.
              setState(() {
                nickName = value!;
              });
            },      
      ),
        SizedBox(width: mq.width, height: mq.height * .03),
        DropdownButtonFormField<String>(
          value: userGender,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: const InputDecoration(
             errorStyle: 
              TextStyle(
              fontFamily: 'Montserrat',
              color: Colors.red,
              fontSize: 15
              ),
            labelText: 'Gender',
            hintText: 'Select your gender',
            prefixIcon: FaIcon(
              FontAwesomeIcons.venusMars,
            ),
          ),
          validator: (String? input){
              if (input != null) {
                if (!input.isValidValue) {
                    return 'Select your gender';
                  }
                }
              return null;
              },
            onChanged: (String? value) {
              // This is called when the user selects an item.
              setState(() {
                userGender = value!;
              });
            },
            items: userGenders.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        SizedBox(width: mq.width, height: mq.height * .03),
        DropdownButtonFormField<String>(   
          value: userAge,       
          decoration: const InputDecoration(
            errorStyle: 
              TextStyle(
              fontFamily: 'Montserrat',
              color: Colors.red,
              fontSize: 15
              ),
            labelText: 'Age',
            hintText: 'Select your age',
            prefixIcon: FaIcon(
              FontAwesomeIcons.baby,
            ),
          ),
          validator: (String? input){
              if (input != null) {
                if (!input.isValidValue) {
                    return 'Select your age';
                  }
                }
              return null;
              },
          onChanged: (String? value) {
            // This is called when the user selects an item.
            setState(() {
              userAge = value!;
            });
          },
          items: ageDropdownItems(),
        ),
        const Divider(
          height: 100,
          color: highlightBGColor,
          thickness: 5,
          indent : 5,
          endIndent : 5,
        ),
        const Text('Looking For',
        style: TextStyle(color: primaryTextColor, fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(width: mq.width, height: mq.height * .03),
        const Text('FishingCab need your information.',
            style: TextStyle(color: secondaryTextColor, fontSize: 14)),
        SizedBox(width: mq.width, height: mq.height * .03),
        DropdownButtonFormField<String>(
          value: findGender,
          decoration: const InputDecoration(
            errorStyle: 
              TextStyle(
              fontFamily: 'Montserrat',
              color: Colors.red,
              fontSize: 15
              ),
            labelText: 'Gender',
            hintText: 'Select your gender',
            prefixIcon: FaIcon(
              FontAwesomeIcons.venusMars,
            ),
          ),
          validator: (String? input){
              if (input != null) {
                if (!input.isValidValue) {
                    return 'Select your age';
                  }
                }
              return null;
              },
          onChanged: (String? value) {
            // This is called when the user selects an item.
            setState(() {
              findGender = value!;
            });
          },
          items: findGenders.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        SizedBox(width: mq.width, height: mq.height * .03),
        const Row(
          children: [
             FaIcon(
              FontAwesomeIcons.baby,
            ),
             Text(' Age',
                style: TextStyle(fontSize: 18))
          ],
        ),
        const SizedBox(height: 5),
            RangeSlider(
              max: ageTo.toDouble(),
              min: ageFrom.toDouble(),
              divisions: ageTo-1,
              labels: RangeLabels(
                "From: $startAge",
                "To: $endAge",
              ),
              values: RangeValues(startAge.round().toDouble(), endAge.round().toDouble()),
              onChanged: (RangeValues values) {
                setState(() {
                  startAge = values.start.round();
                  endAge = values.end.round();
                 // _currentAgeRangeValues = values;
                });
              },
            ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(
              "From: $startAge",
              textAlign: TextAlign.left,
            ),
            Text(
              "To: $endAge",
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.left,
            )
          ],
        ),
         Container(
      padding: EdgeInsets.only(left: mq.width * .3, top: mq.height * .04),
      child: CustomButton(
        icon: FontAwesomeIcons.arrowRightToBracket,
        side: 'right',
        text: 'Take Cab',
        bgColor: highlightBGColor,
        textColor: primaryTextColor,
        onPressed: () => {
          if (_formKey.currentState!.validate()) {
            Navigator.push(
             context,
              MaterialPageRoute(
                            builder: (_) => LoginVerifyScreen(nickName: nickName, userGender: userGender, userAge: userAge, findGender: findGender, startAge: startAge, endAge: endAge)
             )
            )    
          }
        },
      )
      ),
      SizedBox(width: mq.width, height: mq.height * .1),
      ],
      ),
      ),
      
              ],
            ),
          ),
        ),
      ),
    );
  }
}