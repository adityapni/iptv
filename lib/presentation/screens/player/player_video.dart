part of '../screens.dart';

class StreamPlayerPage extends StatefulWidget {
  const StreamPlayerPage({super.key, required this.videoUrl});
  final String videoUrl;

  @override
  State<StreamPlayerPage> createState() => _StreamPlayerPageState();
}

class _StreamPlayerPageState extends State<StreamPlayerPage> {
  late VideoPlayerController _videoPlayerController;
  bool isPlayed = true;
  bool showControllersVideo = true;
  bool isRandomImageBannerVisible = true;

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {
          _videoPlayerController.play();
        });
      });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    Wakelock.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Ink(
      color: Colors.black,
      width: getSize(context).width,
      height: getSize(context).height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (isRandomImageBannerVisible)
            RandomImageBanner(
              onClose: () {
                setState(() {
                  isRandomImageBannerVisible = false;
                });
              },
            ), 
          Center(
            child: _videoPlayerController.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _videoPlayerController.value.aspectRatio,
                    child: VideoPlayer(_videoPlayerController),
                  )
                : const CircularProgressIndicator(),
          ),
          GestureDetector(
            onTap: () {
              debugPrint("click");
              setState(() {
                showControllersVideo = !showControllersVideo;
              });
            },
            child: Container(
              width: getSize(context).width,
              height: getSize(context).height,
              color: Colors.transparent,
            ),
          ),

          ///Controllers
          BlocBuilder<VideoCubit, VideoState1>(
            builder: (context, state) {
              if (!state.isFull) {
                return const SizedBox();
              }

              return SizedBox(
                width: getSize(context).width,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: !showControllersVideo
                      ? const SizedBox()
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  child: IconButton(
                                    focusColor: kColorFocus,
                                    onPressed: () {
                                      context
                                          .read<VideoCubit>()
                                          .changeUrlVideo(false);
                                      //Get.back();
                                    },
                                    icon: const Icon(
                                        FontAwesomeIcons.chevronRight),
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              focusColor: kColorFocus,
                              onPressed: () {
                                setState(() {
                                  if (_videoPlayerController.value.isPlaying) {
                                    _videoPlayerController.pause();
                                    isPlayed = false;
                                  } else {
                                    _videoPlayerController.play();
                                    isPlayed = true;
                                  }
                                });
                              },
                              icon: Icon(
                                isPlayed
                                    ? FontAwesomeIcons.pause
                                    : FontAwesomeIcons.play,
                                size: 24.sp,
                              ),
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}