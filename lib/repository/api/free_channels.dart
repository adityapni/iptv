import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../constants/strings.dart';

class FreeChannelsApi {

  static Future<Map<String, dynamic>> getFreeChannels() async {
    if (kDebugMode) {
      print('getFreeChannels() Called In IpTvApi');
      print('Url: $kBaseApiUrl/free-channels');
    }

    Map<String, dynamic> finalResult;
    try {
      http.Response response = await http.get(
        Uri.parse('$kBaseApiUrl/free-channels'),
      );
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print(response.body.toString());
        }
        finalResult = {
          'status': true,
          'res': response.body,
        };
      } else {
        var res = jsonDecode(response.body);
        String errMsg = 'SomeThing Went Wrong';
        if (res['message'] != null) {
          errMsg = res['message'];
        }
        finalResult = {'status': false, 'msg': errMsg};
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      finalResult = {'status': false, 'msg': 'SomeThing Went Wrong'};
    }
    if (kDebugMode) {
      print(finalResult);
    }
    return finalResult;
  }

}