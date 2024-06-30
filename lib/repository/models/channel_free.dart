import 'package:OOHLIVETV_iptv/services/channels.dart';

class ChannelFree {
  late int? id;
  late String? channelName;
  late String? link;
  late Source source;
  late String contactpage;

  ChannelFree.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? 0;
    channelName = json["name"] ?? '';
    link = json["url"] ?? '';
    source = Source.iptv;
    contactpage = 'https://oohlivetv.com';
  }

}
