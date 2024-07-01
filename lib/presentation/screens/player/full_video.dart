// ... (previous imports)

part of '../screens.dart';

class FullVideoScreen extends StatefulWidget {
  FullVideoScreen({
    super.key,
    required this.link,
    required this.title,
    this.isLive = false,
    this.isRandomImageBannerVisible = true,
  });

  final String link;
  final String title;
  final bool isLive;
  bool isRandomImageBannerVisible;

  @override
  State<FullVideoScreen> createState() => _FullVideoScreenState();
}

class _FullVideoScreenState extends State<FullVideoScreen> {
  late VideoPlayerController _videoPlayerController;
  bool isPlayed = true;
  bool progress = true;
  bool showControllersVideo = true;
  String position = '';
  String duration = '';
  double sliderValue = 0.0;
  bool validPosition = false;
  double _currentVolume = 0.0;
  late Timer timer;

  _settingPage() async {
    try {
      // Default volume is half
      _currentVolume = await PerfectVolumeControl.volume;
      setState(() {});
    } catch (e) {
      debugPrint("Error: setting: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    Wakelock.enable();

    // Initialize the video player controller
    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.http(widget.link),
      // Use this option to enable looping if needed
      // looping: true,
    );

    // Set up the listener for the video player controller
    _videoPlayerController.addListener(listener);

    // Set up the page settings
    _settingPage();

    // Set up a timer to hide controls after a certain duration
    timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (showControllersVideo) {
        setState(() {
          showControllersVideo = false;
        });
      }
    });

    // Initialize the video player controller and handle completion
    _videoPlayerController.initialize().then((_) {
      // Ensure the widget is still mounted before calling setState
      if (mounted) {
        setState(() {});
      }

      // Play the video when initialized
      _videoPlayerController.play();
    });
  }

  void listener() async {
    if (!mounted) return;

    if (progress) {
      if (_videoPlayerController.value.isPlaying) {
        setState(() {
          progress = false;
        });
      }
    }

    if (_videoPlayerController.value.isInitialized) {
      var oPosition = _videoPlayerController.value.position;
      var oDuration = _videoPlayerController.value.duration;

      if (oDuration.inHours == 0) {
        var strPosition = oPosition.toString().split('.')[0];
        var strDuration = oDuration.toString().split('.')[0];
        position = "${strPosition.split(':')[1]}:${strPosition.split(':')[2]}";
        duration = "${strDuration.split(':')[1]}:${strDuration.split(':')[2]}";
      } else {
        position = oPosition.toString().split('.')[0];
        duration = oDuration.toString().split('.')[0];
      }
      validPosition = oDuration.compareTo(oPosition) >= 0;
      sliderValue = validPosition ? oPosition.inSeconds.toDouble() : 0;
      setState(() {});
    }
  }

  void _onSliderPositionChanged(double progress) {
    setState(() {
      sliderValue = progress.floor().toDouble();
    });
    // Convert to Milliseconds since the video player requires MS to set time
    _videoPlayerController.seekTo(Duration(milliseconds: sliderValue.toInt() * 1000));
  }

  @override
  void dispose() async {
    super.dispose();
    await _videoPlayerController.dispose();
    timer.cancel();
    Wakelock.disable();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("SIZE: ${MediaQuery.of(context).size.width}");
    debugPrint('test when video play');
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: getSize(context).width,
            height: getSize(context).height,
            color: Colors.black,
            child: _videoPlayerController.value.isInitialized
                ? VideoPlayer(_videoPlayerController)
                : const SizedBox(),
          ),
          if (progress)
            const Center(
              child: CircularProgressIndicator(
                color: kColorPrimary,
              ),
            ),
          GestureDetector(
            onTap: () {
              setState(() {
                showControllersVideo = !showControllersVideo;
              });
            },
            child: Container(
              width: getSize(context).width,
              height: getSize(context).height,
              color: Colors.transparent,
              child: AnimatedSize(
                duration: const Duration(milliseconds: 200),
                child: !showControllersVideo
                    ? const SizedBox()
                    : SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            focusColor: kColorFocus,
                            onPressed: () async {
                              await Future.delayed(
                                const Duration(milliseconds: 1000),
                              ).then((value) {
                                Get.back(
                                  result: progress
                                      ? null
                                      : [
                                    sliderValue,
                                    _videoPlayerController
                                        .value.duration.inSeconds
                                        .toDouble()
                                  ],
                                );
                              });
                            },
                            icon: Icon(
                              FontAwesomeIcons.chevronLeft,
                              size: 19.sp,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              widget.title,
                              maxLines: 1,
                              style: Get.textTheme.labelLarge!.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.sp,
                              ),
                            ),
                          ),
                        ],
                      ),

                      if (!progress && !widget.isLive)
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 40),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Slider(
                                    activeColor: kColorPrimary,
                                    inactiveColor: Colors.white,
                                    value: sliderValue,
                                    min: 0.0,
                                    max: (!validPosition)
                                        ? 1.0
                                        : _videoPlayerController
                                        .value.duration.inSeconds
                                        .toDouble(),
                                    onChanged: validPosition
                                        ? _onSliderPositionChanged
                                        : null,
                                  ),
                                ),
                                Text(
                                  "$position / $duration",
                                  style: Get.textTheme.titleSmall!.copyWith(
                                    fontSize: 15.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          if (!progress && showControllersVideo)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (!isTv(context))
                  FillingSlider(
                    direction: FillingSliderDirection.vertical,
                    initialValue: _currentVolume,
                    onFinish: (value) async {
                      PerfectVolumeControl.hideUI = true;
                      await PerfectVolumeControl.setVolume(value);
                      setState(() {
                        _currentVolume = value;
                      });
                    },
                    fillColor: Colors.white54,
                    height: 40.h,
                    width: 30,
                    child: Icon(
                      _currentVolume < .1
                          ? FontAwesomeIcons.volumeXmark
                          : _currentVolume < .7
                          ? FontAwesomeIcons.volumeLow
                          : FontAwesomeIcons.volumeHigh,
                      color: Colors.black,
                      size: 13,
                    ),
                  ),
                Center(
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        if (isPlayed) {
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
                ),
              ],
            ),
          Stack(
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
          ),
        ],
      ),
    );
  }
}
