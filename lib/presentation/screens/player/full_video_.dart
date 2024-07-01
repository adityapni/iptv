// ... (previous imports)

// part of '../screens.dart';
//
// class FullVideoScreen extends StatefulWidget {
//   FullVideoScreen({
//     super.key,
//     required this.link,
//     required this.title,
//     this.isLive = false,
//     this.isRandomImageBannerVisible = true,
//   });
//
//   final String link;
//   final String title;
//   final bool isLive;
//   bool isRandomImageBannerVisible;
//
//   @override
//   State<FullVideoScreen> createState() => _FullVideoScreenState();
// }
//
// class _FullVideoScreenState extends State<FullVideoScreen> {
//   late VlcPlayerController _videoPlayerController;
//   bool isPlayed = true;
//   bool progress = true;
//   bool showControllersVideo = true;
//   String position = '';
//   String duration = '';
//   double sliderValue = 0.0;
//   bool validPosition = false;
//   late Timer timer;
//
//
//
//   @override
//   void initState() {
//     super.initState();
//     Wakelock.enable();
//
//     // Initialize the video player controller
//     _videoPlayerController = VlcPlayerController.network(
//       widget.link,
//       // hwAcc: HwAcc.full,
//       autoPlay: false,
//       options: VlcPlayerOptions(),
//     );
//   }
//
//   void listener() async {
//     if (!mounted) return;
//
//     if (progress) {
//       if (_videoPlayerController.value.isPlaying) {
//         setState(() {
//           progress = false;
//         });
//       }
//     }
//
//     if (_videoPlayerController.value.isInitialized) {
//       var oPosition = _videoPlayerController.value.position;
//       var oDuration = _videoPlayerController.value.duration;
//
//       if (oDuration.inHours == 0) {
//         var strPosition = oPosition.toString().split('.')[0];
//         var strDuration = oDuration.toString().split('.')[0];
//         position = "${strPosition.split(':')[1]}:${strPosition.split(':')[2]}";
//         duration = "${strDuration.split(':')[1]}:${strDuration.split(':')[2]}";
//       } else {
//         position = oPosition.toString().split('.')[0];
//         duration = oDuration.toString().split('.')[0];
//       }
//       validPosition = oDuration.compareTo(oPosition) >= 0;
//       sliderValue = validPosition ? oPosition.inSeconds.toDouble() : 0;
//       setState(() {});
//     }
//   }
//
//
//
//   @override
//   void dispose() async {
//     super.dispose();
//     await _videoPlayerController.stopRendererScanning();
//     await _videoPlayerController.dispose();
//     timer.cancel();
//     Wakelock.disable();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     debugPrint("SIZE: ${MediaQuery.of(context).size.width}");
//     debugPrint('test when video play');
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Stack(
//         alignment: Alignment.bottomCenter,
//         children: [
//           VlcPlayer(
//             controller: _videoPlayerController,
//             aspectRatio: 16 / 9,
//             placeholder: const Center(child: CircularProgressIndicator()),
//           ),
//           Stack(
//             alignment: Alignment.bottomCenter,
//             children: [
//               if (widget.isRandomImageBannerVisible)
//                 Container(
//                   width: 400 > 80.w ? 80.w : 400,
//                   padding: const EdgeInsets.symmetric(horizontal: 10),
//                   child: RandomImageBanner(
//                     onClose: () {
//                       setState(() {
//                         widget.isRandomImageBannerVisible =
//                         false; // Handle the banner closure as needed
//                       });
//                     },
//                   ),
//                 ),
//               AdmobWidget.getBanner(),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
