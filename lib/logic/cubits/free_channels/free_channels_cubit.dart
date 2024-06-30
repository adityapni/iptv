import 'package:OOHLIVETV_iptv/repository/locale/free_channels.dart';
import 'package:OOHLIVETV_iptv/repository/models/channel_free.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
part 'free_channels_state.dart';

class FreeChannelsCubit extends Cubit<FreeChannelsState> {
  FreeChannelsCubit() : super(FreeChannelsInitial());

  void getFreeChannels() {
    FreeChannelsLocale.getFreeChannels().then((freeChannelsRes) {
      try {
        if (freeChannelsRes['status']) {
          emit(FreeChannelsLoaded(freeChannelsRes['freeChannels']));
        } else {
          emit(FreeChannelsError(freeChannelsRes['msg']));
        }
      } catch (e) {
        emit(FreeChannelsError('SomeThing Went Wrong'));
      }
    });
  }
}
