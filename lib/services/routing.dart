import 'package:OOHLIVETV_iptv/repository/models/channel_free.dart';
import 'package:flutter/material.dart';

import 'storage.dart';
import 'Formatting.dart';
import 'package:OOHLIVETV_iptv/pages/HomePage.dart';
import 'package:OOHLIVETV_iptv/pages/channelpage-iptv.dart';

goToHomePage(
    {required BuildContext context,
      required StorageProvider storage,
      required FormattingProvider formatingProvider}) {
  Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => HomePage(
            storage: storage,
            formattingProvider: formatingProvider,
          )));
}


