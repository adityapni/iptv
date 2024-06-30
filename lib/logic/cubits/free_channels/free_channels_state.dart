part of 'free_channels_cubit.dart';

@immutable
abstract class FreeChannelsState {}

class FreeChannelsInitial extends FreeChannelsState {}

class FreeChannelsLoaded extends FreeChannelsState {
  final List<ChannelFree> freeChannels;

  FreeChannelsLoaded(this.freeChannels);
}

class FreeChannelsError extends FreeChannelsState {
  final String msg;

  FreeChannelsError(this.msg);
}