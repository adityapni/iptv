
part of '../screens.dart';

class FullVideoScreen extends StatefulWidget {
  const FullVideoScreen({
    super.key,
    required this.link,
    required this.title,
    this.isLive = false,
  });
  final String link;
  final String title;
  final bool isLive;

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
  late Timer timer;
  bool isRandomImageBannerVisible = true;

  // Brightness and Volume
  double _currentVolume = 0.5; // Initial volume
  double _currentBright = 0.5; // Initial brightness

  @override
  void initState() {
    super.initState();
    Wakelock.enable();

    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.link))
      ..initialize().then((_) {
        setState(() {
          progress = false; // Video loaded
          _videoPlayerController.play();
        });
      });

    _videoPlayerController.addListener(_videoPlayerListener);

    _settingPage();

    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (showControllersVideo) {
        setState(() {
          showControllersVideo = false;
        });
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    _videoPlayerController.removeListener(_videoPlayerListener);
    _videoPlayerController.dispose();
    Wakelock.disable();
    super.dispose();
  }

  _settingPage() async {
    try {
      _currentBright = await ScreenBrightness().current;
      _currentVolume = await PerfectVolumeControl.volume;
      setState(() {});
    } catch (e) {
      debugPrint("Error: setting: $e");
    }
  }

  void _videoPlayerListener() {
    if (!mounted) return;
    if (_videoPlayerController.value.isInitialized) {
      setState(() {
        position = _formatDuration(_videoPlayerController.value.position);
        duration = _formatDuration(_videoPlayerController.value.duration);
        sliderValue = _videoPlayerController.value.position.inSeconds.toDouble();
      });
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  void _onSliderPositionChanged(double progress) {
    setState(() {
      sliderValue = progress.floor().toDouble();
    });
    _videoPlayerController.seekTo(Duration(seconds: sliderValue.toInt()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Banner
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Visibility(
              visible: isRandomImageBannerVisible,
              child: RandomImageBanner(
                onClose: () {
                  setState(() {
                    isRandomImageBannerVisible = false;
                  });
                },
              ),
            ),
          ),
          // Video Player
          Center(
            child: _videoPlayerController.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _videoPlayerController.value.aspectRatio,
                    child: VideoPlayer(_videoPlayerController),
                  )
                : const CircularProgressIndicator(),
          ),
          // Loading Indicator
          if (progress)
            const Center(
              child: CircularProgressIndicator(),
            ),
          // Controls Overlay
          GestureDetector(
            onTap: () {
              setState(() {
                showControllersVideo = !showControllersVideo;
              });
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
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
                          // Back Button and Title
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () => Navigator.pop(context),
                                  icon: const Icon(Icons.arrow_back,
                                      color: Colors.white),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  widget.title,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          // Slider and Duration
                          if (!progress && !widget.isLive)
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Slider(
                                      activeColor: Colors.red,
                                      inactiveColor: Colors.white,
                                      value: sliderValue,
                                      min: 0.0,
                                      max: _videoPlayerController
                                          .value.duration.inSeconds
                                          .toDouble(),
                                      onChanged: _onSliderPositionChanged,
                                    ),
                                  ),
                                  Text(
                                    "$position / $duration",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          // Play/Pause Button
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(
                              child: IconButton(
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
                                      ? Icons.pause_circle
                                      : Icons.play_circle,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
              ),
            ),
          ),
          // Brightness and Volume Controls (Example)
          if (!progress && showControllersVideo)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Volume Slider
                Slider(
                  value: _currentVolume,
                  onChanged: (value) {
                    setState(() {
                      _currentVolume = value;
                    });
                    // Implement volume control logic
                  },
                ),
                // Brightness Slider
                Slider(
                  value: _currentBright,
                  onChanged: (value) {
                    setState(() {
                      _currentBright = value;
                    });
                    // Implement brightness control logic
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }
}