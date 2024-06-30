part of 'ads_cubit.dart';

@immutable
abstract class AdsState {}

class AdsInitial extends AdsState {}

class RandomAdLoaded extends AdsState {
  final Ads ads;

  RandomAdLoaded(this.ads);
}

class AdsError extends AdsState {
  final String msg;

  AdsError(this.msg);
}
