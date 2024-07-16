import 'dart:io';

import 'package:http/http.dart' as http;
import '../helpers/crud.dart';



class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}


class Api{

  final _dataServices = DataServices();

  Future<dynamic> getUrl(link) async{

    await _dataServices.saveValue('isFree', 'false');

    try {

    final _getLinkContent = await Api().getLinkContent(link);

    if(_getLinkContent != 'failed' && _getLinkContent != null){

      return _getLinkContent;

    }else{

      return null;

    }

    } on Exception catch (e) {

    return null;

  }

  }


  Future<dynamic> getLinkContent(link) async{
    
  HttpOverrides.global = MyHttpOverrides();
  final _r = DateTime.now().millisecondsSinceEpoch;

  final _uri = '${link}&r=${_r}';

  try {

    //print(_uri);
    
  var response = await http.get(Uri.parse(_uri)).timeout(
    const Duration(milliseconds: 6000),
    onTimeout: () async {
      return http.Response('Error', 408);
    },
  )
  ;

  //print(response.headers);
  //print(response.statusCode);

  if (response.statusCode == 200) {

    final response_body = response.body; 

  //print('BODY: $response_body');

    return response_body;

  } else {

    return 'failed';

  }

  } on Exception catch (e) {

    return 'failed';

  }

}



}