import 'dart:convert';
import 'package:OOHLIVETV_iptv/repository/api/free_channels.dart';
import 'package:flutter/foundation.dart';
import '../models/channel_free.dart';

class FreeChannelsLocale {
  static Future<Map<String, dynamic>> getFreeChannels() async {
    if (kDebugMode) {
      print('getFreeChannels() Called In FreeChannelsLocale');
    }
    var freeChannelsRes = await FreeChannelsApi.getFreeChannels();
    try {
      if (freeChannelsRes['status']) {
        final results = jsonDecode(freeChannelsRes['res'])['freeChannels'];
        freeChannelsRes['freeChannels'] = results.map((result) => ChannelFree.fromJson(result)).toList().cast<ChannelFree>();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      freeChannelsRes['status'] = false;
      freeChannelsRes['msg'] = 'SomeThing Went Wrong';
    }
    return freeChannelsRes;
  }
}