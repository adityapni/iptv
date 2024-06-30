import 'package:OOHLIVETV_iptv/repository/locale/ads.dart';
import 'package:OOHLIVETV_iptv/repository/models/ads.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'ads_state.dart';

class AdsCubit extends Cubit<AdsState> {
  final AdsLocale adsLocale;

  AdsCubit(this.adsLocale) : super(AdsInitial());

  void getRandomAd({required double width}) {
    adsLocale.getRandomAd(width: width).then((adsRes) {
      try {
        if (adsRes['status']) {
          emit(RandomAdLoaded(adsRes['ads']));
        } else {
          emit(AdsError(adsRes['msg']));
        }
      } catch (e) {
        emit(AdsError('SomeThing Went Wrong'));
      }
    });
  }
}
