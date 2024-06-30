import 'package:flutter_bloc/flutter_bloc.dart';
class VideoState1 {
  final bool isFull;

  VideoState1({this.isFull = false});
}

class VideoCubit extends Cubit<VideoState1> {
  VideoCubit() : super(VideoState1());

  void changeUrlVideo(bool isFull) {
    emit(VideoState1(isFull: isFull));
  }
}
