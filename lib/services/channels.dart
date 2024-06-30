enum Source { iptv, youtube }

class Channel {
  Channel(
      {required this.channelName,
      required this.link,
      required this.source,
      required this.contactpage});

  String channelName;
  String link;
  Source source;
  String contactpage;

  String getChannelName() {
    return channelName;
  }
}

class Channels {
  List<Channel> getMatchingChannels(List<String> channelNames) {
    List<Channel> matchingChannels = [];

    for (Channel channel in channelList) {
      if (channelNames.contains(channel.channelName)) {
        matchingChannels.add(channel);
      }
    }

    return matchingChannels;
  }

  int getIndexByChannelName(String channelName) {
    for (int i = 0; i < channelList.length; i++) {
      if (channelList[i].channelName == channelName) {
        return i;
      }
    }
    return -1;
  }

  List<Channel> channelList = [
    Channel(
        channelName: "Radio Alquraan Alkareem",
        link:
            "https://201526.global.ssl.fastly.net/647cfcb338286342d6a88374/live_bbd05190a0c411eeb39537ffb10ca47f/index.m3u8",
        source: Source.iptv,
        contactpage: 'https://oohlivetv.com'),
    Channel(
        channelName: "News Tv",
        link:
            "https://svs.itworkscdn.net/bloomberarlive/bloomberg.smil/playlist_dvr.m3u8",
        source: Source.iptv,
        contactpage: 'https://oohlivetv.com'),
    Channel(
        channelName: "Radio Alahadeeth Alnabwya",
        link:
        "https://201526.global.ssl.fastly.net/647cfcb338286342d6a88374/live_65fd3ec0a57b11eea288c1c448e91e1c/index.m3u8",
        source: Source.iptv,
        contactpage: 'https://oohlivetv.com'),
    Channel(
        channelName: "Kidzy TV",
        link:
        "https://201526.global.ssl.fastly.net/647cfcb338286342d6a88374/live_004865302c7e11eeae53dd7fb7a75e7a/index.m3u8",
        source: Source.iptv,
        contactpage: 'https://oohlivetv.com'),
    Channel(
        channelName: "NouNou TV",
        link:
        "https://201526.global.ssl.fastly.net/647cfcb338286342d6a88374/live_192ddaa0a57b11eeb8b44f6a1475a4a3/index.m3u8",
        source: Source.iptv,
        contactpage: 'https://oohlivetv.com'),
  ];
}
