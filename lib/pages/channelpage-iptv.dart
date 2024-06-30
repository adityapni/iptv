import 'package:OOHLIVETV_iptv/repository/models/channel_free.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:OOHLIVETV_iptv/services/storage.dart';
import 'package:OOHLIVETV_iptv/GlobalWidgets/RandomImageBanner.dart';

class ChannelPageIPTV extends StatefulWidget {
  const ChannelPageIPTV({
    super.key, required this.freeChannel,
  });

  final ChannelFree freeChannel;

  @override
  State<ChannelPageIPTV> createState() => _ChannelPageIPTVState();
}

class _ChannelPageIPTVState extends State<ChannelPageIPTV> {
  late Player _player;
  late VideoController _videoController;

  bool _appBarVisibility = true;

  _setupVideoController() {
    final channelLink = widget.freeChannel.link;
    debugPrint('channelLink');
    debugPrint(channelLink);
    _player = Player();
    _videoController = VideoController(_player);
    _player.open(Media(channelLink!));
  }

  _hideUnhideAppBar() {
    setState(() {
      _appBarVisibility = !_appBarVisibility;
      if (!_appBarVisibility) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      } else {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
            overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      }
    });
  }

  bool isRandomImageBannerVisible = true;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    _setupVideoController();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    _videoController.player.dispose();
    _player.dispose();
    debugPrint('22222');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarVisibility
          ? AppBar(
        title: Text(widget.freeChannel.channelName!),
        centerTitle: true,
        backgroundColor: Colors.red,
      )
          : null,
      backgroundColor: const Color.fromARGB(255, 10, 10, 10),
      body: GestureDetector(
        onTap: () => _hideUnhideAppBar(),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                _buildVideoPlayer(),
                Visibility(
                  visible: isRandomImageBannerVisible,
                  child: RandomImageBanner(
                    onClose: () {
                      setState(() {
                        isRandomImageBannerVisible = false;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: (MediaQuery.of(context).orientation ==
          Orientation.portrait)
          ? Padding(
        padding: const EdgeInsets.all(27.0),
        child: Text(
          'Tap the video for full-screen viewing. \n \n To get in touch with this news channel, visit their website at: ${widget.freeChannel.contactpage}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color.fromARGB(255, 248, 245, 245),
          ),
        ),
      )
          : null,
    );
  }

  Widget _buildVideoPlayer() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width * 9.0 / 16.0,
      child: Video(controller: _videoController),
    );
  }
}
