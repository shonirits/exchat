
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../common/config.dart';
import '../helpers/crud.dart';
import '../../main.dart';
import '../helpers/colors.dart';
import '../helpers/ext_str.dart';
import '../widgets/custom_utilities.dart';
import '../models/api.dart';
import '../screens/splash_screen.dart';
import '../helpers/api.dart';
import '../helpers/dialogs.dart';
import '../models/hive.dart';
import '../helpers/user.dart';
import 'mobile_layout_screen.dart';

class LoginVerifyScreen extends StatefulWidget {
  final nickName;
   final userGender;
   final userAge;
   final findGender;
   final startAge;
   final endAge;
   const LoginVerifyScreen({Key? key, required this.nickName, required this.userGender, required this.userAge, required this.findGender, required this.startAge, required this.endAge}) : super(key: key);

  @override
  State<LoginVerifyScreen> createState() => new _LoginVerifyScreenState();
}

class _LoginVerifyScreenState extends State<LoginVerifyScreen> {

      final now = DateTime.now();
      final _preferencesServices = PreferencesServices();
      
      bool _isAnimate = false;
      final _formKey = GlobalKey<FormState>();
      String _captchaToken = '';
      var imageUrl = 'https://cdn.fishingcab.com/public/images/frontend/mint/loading.png';
      String _captchaCode = '';
      String _latitude = '41.286380';
      String _longitude = '-73.923000';
      var nickName;
      var userGender;
      var userAge;
      var findGender;
      var startAge;
      var endAge;
      final _offset = '';
      var htmlError = '';



   @override
  void initState() {
    super.initState();
     //for auto triggering animation
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() => _isAnimate = true);
    });

_loadDefault();
   
  }

  @override
void setState(VoidCallback fn){
  if(mounted){
    super.setState(fn);
  }
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

    _getCaptchaToken();

    _determinePosition();

    Hive.openBox<SelfInfoModel>('self');

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


  Future<dynamic> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return 'Location services are disabled.';
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return 'Location permissions are denied';
    }
  }
  
  if (permission == LocationPermission.deniedForever) {

    return 'Location permissions are permanently denied, we cannot request permissions.';
  } 

  try {
   Position? position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high, timeLimit: Duration(seconds: 5));
   if(position != null){  
 setState(() {
_latitude = position.latitude.toString();
_longitude = position.longitude.toString();
   });
}
  } catch (e) {
    Position? position = await Geolocator.getLastKnownPosition();
    if(position != null){  
 setState(() {
_latitude = position.latitude.toString();
_longitude = position.longitude.toString();
   });
}
  }

  return true;
}


  Future<dynamic> _letsFishing() async {

    setState(() {

        htmlError = '';

        });

    //for showing progress bar
    Dialogs.showProgressBar(context);

    _determinePosition().then((getPermission) async {

      // if(getPermission != true){
      //
      //   //for hiding progress bar
      // Navigator.pop(context);
      //
      // Dialogs.showSnackbar(context, getPermission, errorBGColor, errorTextColor);
      //
      // }else{

    _getCaptchaVerify().then((getVerify) async {

      if (getVerify != false) {     
        
    _signupUser().then((getReturn) async {

      if (getReturn != null) { 

       final _is_logged_in = await _preferencesServices.getValue('is_logged_in','bool');
       final _keys = await _preferencesServices.getValue('keys','list');

       if(_is_logged_in == true){

        _selfInfo(_keys[0], _keys[1]).then((getself) async {

      final selfInfo = selfInfoFromJson(getself);

      if(selfInfo.response == true && selfInfo.status == true){

      final selfData = selfInfo.data;

      final data = SelfInfoModel(
        userId: selfData!.userId,
        publicKey: selfData!.publicKey,
        secretKey: selfData!.secretKey,
        nickname: selfData!.nickname,
        gender: selfData!.gender,
        age: selfData!.age,
        findgender: selfData!.findgender,
        agefrom: selfData!.agefrom,
        ageto: selfData!.ageto,
        status: selfData!.status,
        lastSeenAt: selfData!.lastSeenAt,
        latitude: selfData!.latitude,
        longitude: selfData!.longitude,
        offset: selfData!.offset,
         ) ;


      final _selfBox = SelfBox.getData();
      
       _selfBox.add(data);

         Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const SplashScreen())
                ); 

       Dialogs.showSnackbar(context, 'Success', successBGColor, successTextColor);

      }else{

         //for hiding progress bar
          Navigator.pop(context);

        Dialogs.showSnackbar(context, 'Server is very busy right now', errorBGColor, errorTextColor);

      }

       });

       }else{

         //for hiding progress bar
          Navigator.pop(context);

        _getCaptchaToken();

        Dialogs.showSnackbar(context, 'Unknown Error. Please try again!', errorBGColor, errorTextColor);

       }        

      }           
        });

      }else{

        //for hiding progress bar
      Navigator.pop(context);

    _getCaptchaToken();

    Dialogs.showSnackbar(context, 'Invalid CAPTCHA Code', errorBGColor, errorTextColor);

      }

    });

     // }

    });

  }


  Future<dynamic> _selfInfo(user_public_key, user_secret_key)  async{


    try {

        final getUserInfo = await Api().getUrl('${apiUrl}user_info?app_public_key=$apiPublicKey&app_secret_key=$apiSecretKey&user_public_key=$user_public_key&user_secret_key=$user_secret_key');

        if (getUserInfo != null) { 

          return getUserInfo;         

        }else{

        // ignore: use_build_context_synchronously
        Dialogs.showSnackbar(context, 'Server unable to complete request', errorBGColor, errorTextColor);

        return null;

        }

      } catch (e) {

        if (mounted) {
          Dialogs.showSnackbar(context, 'Something Went Wrong (Check Internet!)', errorBGColor, errorTextColor);
        }

        return null;
      }


  }


  Future<dynamic> _signupUser()  async{

      try {

        final _offset = now.timeZoneOffset.inHours;

        final letSignup= await Api().getUrl('${apiUrl}signup?token=$_captchaToken&app_public_key=$apiPublicKey&app_secret_key=$apiSecretKey&nickname=$nickName&gender=$userGender&age=$userAge&findgender=$findGender&agefrom=$startAge&ageto=$endAge&latitude=$_latitude&longitude=$_longitude&offset=$_offset');

        if (letSignup != null) { 

         final isSignup = dataVoidFromJson(letSignup);

        if(isSignup.response == true && isSignup.status == true){

          var publicKey = isSignup.data!.publicKey.toString();
          var secretKey = isSignup.data!.secretKey.toString();

         List<String>? keys = <String>[publicKey, secretKey];

          await _preferencesServices.saveValue('keys', keys, 'list');
          await _preferencesServices.saveValue('is_logged_in', true, 'bool');

          return 'success';

        }else{

          //for hiding progress bar
      Navigator.pop(context);

      setState(() {

        htmlError = '<ul>${isSignup.data}</ul>';

        });

          return null;

        }      

        }else{

        Dialogs.showSnackbar(context, 'Server unable to complete request', errorBGColor, errorTextColor);

        return null;

        }

      } catch (e) {

        if (mounted) {
          Dialogs.showSnackbar(context, 'Something Went Wrong (Check Internet!)', errorBGColor, errorTextColor);
        }

        return null;
      }

    }


    Future<bool> _getCaptchaVerify()  async{

      try {

        final letVerified = await Api().getUrl('${apiUrl}get_captcha_verify?app_public_key=$apiPublicKey&app_secret_key=$apiSecretKey&token=$_captchaToken&captcha_code=$_captchaCode');

        if (letVerified != null) { 

         final captchaVerify = dataBoolFromJson(letVerified);

        if(captchaVerify.response == true && captchaVerify.status == true){

          return true;

        }else{

          return false;

        }      

        }else{

        return false;

        }

      } catch (e) {

        if (mounted) {
          Dialogs.showSnackbar(context, 'Something Went Wrong (Check Internet!)', errorBGColor, errorTextColor);
        }

        return false;
      }

    }


  Future<bool> _getCaptchaToken()  async{

     setState(() {

        imageUrl = 'https://fishingcab.com/public/images/frontend/mint/loading.png';

        });

    try {
      
      final getContent = await Api().getUrl('${apiUrl}get_captcha_token?app_public_key=$apiPublicKey&app_secret_key=$apiSecretKey');

      if (getContent != null) { 

      final captchaToken = dataStringFromJson(getContent);

      if(captchaToken.response == true && captchaToken.status == true){

        setState(() {

        _captchaToken = captchaToken.data;

        imageUrl = '${apiUrl}get_captcha_image/$_captchaToken';

        });

        return true;

      }else{

        return false;

      }      

      }else{

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
setState(() {
      nickName = widget.nickName;
       userGender = widget.userGender;
       userAge = widget.userAge;
       findGender = widget.findGender;
       startAge = widget.startAge.toString();
       endAge = widget.endAge.toString();
      });
    
  
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
         //app bar
        appBar: AppBar(
          automaticallyImplyLeading: true,
           titleSpacing: 0,
          title: const Text('Almost Done!', style: TextStyle(
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
                      RichText(
                  text: TextSpan(
                      style: TextStyle(color: secondaryTextColor, fontSize: 15),
                      children: [
                        const TextSpan(
                            text: ' Nickname:  ',
                            style: TextStyle(fontWeight: FontWeight.w500)
                            ),
                        TextSpan(text: nickName),
                      ]),
                ),
                SizedBox(width: mq.width, height: mq.height * .03),
                RichText(
                  text: TextSpan(
                      style: TextStyle(color: secondaryTextColor, fontSize: 15),
                      children: [
                        const TextSpan(
                            text: ' Gender:  ',
                            style: TextStyle(fontWeight: FontWeight.w500)
                            ),
                        TextSpan(text: userGender),
                      ]),
                ),
                SizedBox(width: mq.width, height: mq.height * .03),
                RichText(
                  text: TextSpan(
                      style: const TextStyle(color: secondaryTextColor, fontSize: 15),
                      children: [
                        const TextSpan(
                            text: ' Age:  ',
                            style: TextStyle(fontWeight: FontWeight.w500)
                            ),
                        TextSpan(text: userAge),
                      ]),
                ),                
                const Divider(
                  height: 50,
                  color: highlightBGColor,
                  thickness: 5,
                  indent : 5,
                  endIndent : 5,
                ),
                 const Text('Looking For',
            style: TextStyle(color: primaryTextColor, fontSize: 20, fontWeight: FontWeight.bold)),
               SizedBox(width: mq.width, height: mq.height * .03),
                RichText(
                  text: TextSpan(
                      style: const TextStyle(color: secondaryTextColor, fontSize: 15),
                      children: [
                        const TextSpan(
                            text: ' Gender:  ',
                            style: TextStyle(fontWeight: FontWeight.w500)
                            ),
                        TextSpan(text: findGender),
                      ]),
                ),
                SizedBox(width: mq.width, height: mq.height * .03),
                RichText(
                  text: TextSpan(
                      style: const TextStyle(color: secondaryTextColor, fontSize: 15),
                      children: [
                        const TextSpan(
                            text: ' Age:  ',
                            style: TextStyle(fontWeight: FontWeight.w500)
                            ),
                        TextSpan(text: startAge),
                        const TextSpan(text: ' - '),
                        TextSpan(text: endAge),
                      ]),
                ),
                const Divider(
                  height: 50,
                  color: highlightBGColor,
                  thickness: 5,
                  indent : 5,
                  endIndent : 5,
                ),
                const Text('Please verify you are human',
            style: TextStyle(color: primaryTextColor, fontSize: 20, fontWeight: FontWeight.bold)),
             SizedBox(width: mq.width, height: mq.height * .03),
            Row(
               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
               mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                //profile picture
                        Flexible(
                          flex: 4,
                          child:                    
                              //image from server
                              ClipRRect(                            
                                  child: CachedNetworkImage(                                  
                                    fit: BoxFit.cover,
                                    imageUrl: imageUrl,
                                    errorWidget: (context, url, error) =>
                                        const CircleAvatar(
                                            child: Icon(CupertinoIcons.person)),
                                  ),
                                ),
                        ),

                                //edit image button
                           Flexible(
                            flex: 1,
                             child: MaterialButton(
                              elevation: 1,
                              onPressed: () {
                               _getCaptchaToken();
                              },
                              shape: const CircleBorder(),
                              color: highlightBGColor,
                              child: const Icon(Icons.refresh, color: primaryTextColor),
                                                       ),
                           )
                        
              ],
            ),
              SizedBox(width: mq.width, height: mq.height * .03),
           TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: const InputDecoration(
        prefixIcon: FaIcon(
        FontAwesomeIcons.userSecret,
      ),
      errorStyle: 
      TextStyle(
      fontFamily: 'Montserrat',
      color: Colors.red,
      fontSize: 15
      ),
      hintText: 'Enter characters shown above picture',
      labelText: 'CAPTCHA Code',
      ),
       validator: (String? input){
      if (input != null) {
         if (!input.isValidValue) {
            return 'Enter characters shown above picture.';
          }
         }
       return null;
       }, 
       onChanged: (String? value) {
              // This is called when the user change value.
              setState(() {
                _captchaCode = value!;
              });
            },      
      ),
      SizedBox(width: mq.width, height: mq.height * .01),
      Container(
        color: errorBGColor,
        child: HtmlWidget('<span style="color: red"> $htmlError </span>'),
      ),

            Container(
      padding: EdgeInsets.only(left: mq.width * .3, top: mq.height * .04),
      child: CustomButton(
        icon: FontAwesomeIcons.arrowRightToBracket,
        side: 'right',
        text: 'Let\'s Fishing',
        bgColor: highlightBGColor,
        textColor: primaryTextColor,
        onPressed: () => {
          if (_formKey.currentState!.validate()) {
             _letsFishing()
          }
        },
      )
      ),
       SizedBox(width: mq.width, height: mq.height * .1),
                    ],
                  ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}