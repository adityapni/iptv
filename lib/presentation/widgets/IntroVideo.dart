import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class IntroVideo extends StatefulWidget {
  final bool isTv;
  const IntroVideo({super.key, this.isTv = false});

  @override
  State<IntroVideo> createState() => _IntroVideoState();
}

class _IntroVideoState extends State<IntroVideo> {
  VideoPlayerController? _videoController;

  void reload() {
    _videoController?.dispose();

    // _videoController = VideoPlayerController.networkUrl(
    //     Uri.parse("https://media.w3.org/2010/05/sintel/trailer.mp4"));

    _videoController = VideoPlayerController.asset('assets/videos/intro.mp4');
    _videoController?.setLooping(true);

    _videoController!.initialize().then((value) {
      if (_videoController!.value.isInitialized) {
        _videoController!.play();
        setState(() {});

        _videoController!.addListener(() {
          if (_videoController!.value.isCompleted) {
            log("ui: player completed, pos=${_videoController!.value.position}");
          }
        });
      } else {
        log("video file load failed");
      }
    }).catchError((e) {
      log("controller.initialize() error occurs: $e");
    });
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    reload();
  }

  @override
  void dispose() {
    super.dispose();
    _videoController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('intro-video-visible-key'),
      onVisibilityChanged: (visibilityInfo) {
        var visiblePercentage = visibilityInfo.visibleFraction * 100;
        debugPrint('Widget ${visibilityInfo.key} is $visiblePercentage% visible');
        if(visiblePercentage == 0){
          _videoController?.pause();
        }
        else{
          _videoController?.play();
        }
      },
      child: Center(
        child: _videoController!.value.isInitialized
            ? AspectRatio(
                aspectRatio: _videoController!.value.aspectRatio,
                child: VideoPlayer(_videoController!),
              )
            : Container(),
      ),
    );
  }
}
