import 'dart:convert';

import 'package:http/http.dart';
class RequestAssitance{
  static Future<dynamic>getRequest(String url) async{
    Response response=await get(Uri.parse(url));
    try{
      if(response.statusCode==200){
        String jsonData=response.body;
        var jsondata=jsonDecode(jsonData);
        return jsondata;
      }else{
        return "failed";
      }
    }catch(exp){
      return "failed";
    }
  }
}