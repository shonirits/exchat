import 'dart:convert';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;


int getRand(input){
    Random random = Random();
    int randomNumber = random.nextInt(input);
    if(input == randomNumber){
      randomNumber = input-1;
    }
    return randomNumber;
  }

  String token_fnc(int len) {
  var r = Random();
  const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  return List.generate(len, (index) => chars[r.nextInt(chars.length)]).join();
}


String localTime(timestamp, convert){

var microSeconds = int.parse(timestamp);

  if(convert == true){
  microSeconds = int.parse('${timestamp}000000');
  }

var dt = DateTime.fromMicrosecondsSinceEpoch(microSeconds);

final response = DateFormat('HH:mm').format(dt);

return response.toString();

}

String localTimeFull(timestamp, convert){

  var microSeconds = int.parse(timestamp);

  if(convert == true){
 microSeconds = int.parse('${timestamp}000000');
  }

 var dt = DateTime.fromMicrosecondsSinceEpoch(microSeconds);

 final response = DateFormat('yyyy-MM-dd HH:mm:ss').format(dt);

 return response.toString();

}


String momentTime(timestamp, convert){

var microSeconds = int.parse(timestamp);

if(convert == true){
microSeconds = int.parse('${timestamp}000');
}

var dt = DateTime.fromMicrosecondsSinceEpoch(microSeconds);

final response = timeago.format(dt);

return response.toString();

}



