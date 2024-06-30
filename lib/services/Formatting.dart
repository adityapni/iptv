import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import "package:OOHLIVETV_iptv/services/channels.dart";

part 'Formatting.g.dart';

class FormattingProvider = _FormattingProvider with _$FormattingProvider;

abstract class _FormattingProvider with Store {
  @action
  formatIcon(Source source) {
    if (source == Source.iptv) {
      return const Icon(Icons.satellite_alt, color: Colors.red,);
    } else {
      return const Icon(Icons.smart_display, color: Colors.red,);
    }
  }
}