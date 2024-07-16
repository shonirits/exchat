import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/hive.dart';
import '../helpers/api.dart';
import '../../main.dart';
import '../common/config.dart';
import '../helpers/colors.dart';
import '../helpers/ext_str.dart';
import '../widgets/custom_utilities.dart';
import '../helpers/user.dart';
import 'splash_screen.dart';
import 'mobile_layout_screen.dart';
import '../helpers/dialogs.dart';


class ProfileScreen extends StatefulWidget {
  final selfInfo;
  const ProfileScreen({super.key, this.selfInfo});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String nickName = '';
  String userGender  = userGenders.first;
  String userAge  = ageFrom.toString();
  String findGender  = findGenders.first;
  int startAge = ageFrom;
  int endAge = ageTo;
  String userStatus = 'Online';
  bool _isSet = false;


   @override
  void initState() {
    super.initState();
    _loadDefault().then((loadDefault_value) async {

      //for showing progress bar
    Dialogs.showProgressBar(context);

    await User().is_signed_in().then((isSignedIn) async {

      if (isSignedIn != true) { 

      User().sign_out().then((signOut) {                            
                //navigate to login screen
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => const SplashScreen()),
                (route) => false
        );

      });

            return null;

      }else{

      //for hiding progress bar
       Navigator.pop(context);

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

  Future<dynamic> _loadDefault() async{

    await Hive.openBox<SelfInfoModel>('self');
    await Hive.openBox<RoomsInfoModel>('rooms');
    await Hive.openBox<ChatsInfoModel>('chats');
    await Hive.openBox<MessagesInfoModel>('messages');
    await Hive.openBox<NotificationsInfoModel>('notifications');
    await Hive.openBox<UsersInfoModel>('users');
    await Hive.openBox<TmpInfoModel>('tmp');

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


  Future<bool> updateProfile(SelfInfoModel _selfInfo, status, nickname, gender, age, findgender, agefrom, ageto) async {

    try {

        final isUpdated = await Api().getUrl('${apiUrl}profile_update?app_public_key=$apiPublicKey&app_secret_key=$apiSecretKey&user_public_key=${_selfInfo.publicKey}&user_secret_key=${_selfInfo.secretKey}&status=$status&nickname=$nickname&gender=$gender&age=$age&findgender=$findgender&agefrom=$agefrom&ageto=$ageto');

        if (isUpdated != null) { 

        Dialogs.showSnackbar(context, 'Updated Successfully', successBGColor, successTextColor);

        return true;
          
        }else{

        Dialogs.showSnackbar(context, 'Server unable to complete request', errorBGColor, errorTextColor);

          return false;

        }

      } catch (e) {

        if (mounted) {
          Dialogs.showSnackbar(context, 'Something Went Wrong (Check Internet!)', errorBGColor, errorTextColor);
        }

        return false;

      }
  }

 @override
  Widget build(BuildContext context) {
    //initializing media query (for getting device screen size)
    mq = MediaQuery.of(context).size;

    final _selfInfo = widget.selfInfo;

    (!_isSet)?setState(() {
      _isSet = true;
        nickName = _selfInfo.nickname;
        userGender  = _selfInfo.gender;
        userAge  = _selfInfo.age;
        findGender  = _selfInfo.findgender;
        userStatus = _selfInfo.status;
       startAge = int.parse(_selfInfo.agefrom);
      endAge = int.parse(_selfInfo.ageto);
    }):'';

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: PopScope(  
        canPop: false,      
        onPopInvoked: (_) async {          
            Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => MobileLayoutScreen()));
        },
        //
        child: Scaffold(
          //app bar
          appBar: AppBar(
            automaticallyImplyLeading: true,
            backgroundColor: quaternaryBGColor, 
            elevation: 0,           
            centerTitle: false,
            title: const Text('Profile', style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Oswald',
                      fontWeight: FontWeight.bold,
                  color: secondaryTextColor
                  )),      
          ),

          backgroundColor: senaryBGColor,

          //body
          body: SafeArea(
            child: SingleChildScrollView(
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
            style: TextStyle(color: tertiaryTextColor, fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(width: mq.width, height: mq.height * .03),
      DropdownButtonFormField<String>(
          value: _selfInfo.status,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: const InputDecoration(
             errorStyle: 
              TextStyle(
              fontFamily: 'Montserrat',
              color: Colors.red,
              fontSize: 15
              ),
            labelText: 'Status',
            hintText: 'Select your status',
            prefixIcon: FaIcon(
              FontAwesomeIcons.chartSimple,
            ),
          ),
          validator: (String? input){
              if (input != null) {
                if (!input.isValidValue) {
                    return 'Select your status';
                  }
                }
              return null;
              },
            onChanged: (String? value) {
              // This is called when the user selects an item.
              setState(() {
                userStatus = value!;
              });
            },
            items: userStatuss.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        SizedBox(width: mq.width, height: mq.height * .03),
      TextFormField(
      initialValue: _selfInfo.nickname,
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
          value: _selfInfo.gender,
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
          value: _selfInfo.age.toString(),       
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
        style: TextStyle(color: tertiaryTextColor, fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(width: mq.width, height: mq.height * .03),
        DropdownButtonFormField<String>(
          value: _selfInfo.findgender,
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
        icon: FontAwesomeIcons.penFancy,
        side: 'right',
        text: 'Update',
        bgColor: highlightBGColor,
        textColor: activeTextColor,
        onPressed: () async => {
          if (_formKey.currentState!.validate()) {

            //for showing progress bar
            Dialogs.showProgressBar(context),

            await updateProfile(_selfInfo, userStatus, nickName, userGender, userAge, findGender, startAge, endAge).then((isUpdated) {
              
              //for hiding progress bar
               Navigator.pop(context);

            })
               
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
        ),
      ),
    );
  }
}