part of '../screens.dart';

class StreamPlayerPage extends StatefulWidget {
  bool isRandomImageBannerVisible;

  StreamPlayerPage({
    super.key,
    this.isRandomImageBannerVisible = true,
    required this.videoPlayerController,
  });

  final VideoPlayerController videoPlayerController;

  @override
  _StreamPlayerPageState createState() => _StreamPlayerPageState();
}

class _StreamPlayerPageState extends State<StreamPlayerPage> {
  bool isPlayed = true;
  bool showControllersVideo = true;

  @override
  void initState() {
    Wakelock.enable();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('test when video play');
    return Ink(
      color: Colors.black,
      width: getSize(context).width,
      height: getSize(context).height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          VideoPlayer(widget.videoPlayerController),
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
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    if (widget.isRandomImageBannerVisible)
                      Container(
                        width: 400 > 80.w ? 80.w : 400,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: RandomImageBanner(
                          onClose: () {
                            setState(() {
                              widget.isRandomImageBannerVisible =
                              false; // Handle the banner closure as needed
                            });
                          },
                        ),
                      ),
                    AdmobWidget.getBanner(),
                  ],
                )),
          ),
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
                                if (isPlayed) {
                                  widget.videoPlayerController.pause();
                                  isPlayed = false;
                                } else {
                                  widget.videoPlayerController.play();
                                  isPlayed = true;
                                }
                                setState(() {});
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
