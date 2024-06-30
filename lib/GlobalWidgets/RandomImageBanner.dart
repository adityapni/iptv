import 'dart:math';

import 'package:OOHLIVETV_iptv/logic/cubits/ads/ads_cubit.dart';
import 'package:OOHLIVETV_iptv/repository/models/ads.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:OOHLIVETV_iptv/services/storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'error_loaded.dart';
import 'loading_indicator.dart'; // Update based on your file structure

final random = Random(); // Global random number generator

class RandomImageBanner extends StatefulWidget {
  final StorageProvider? storage; // Optional argument for future needs
  final void Function() onClose; // Required callback for closing the banner

  const RandomImageBanner({super.key, this.storage, required this.onClose});

  @override
  State<RandomImageBanner> createState() => _RandomImageBannerState();
}

class _RandomImageBannerState extends State<RandomImageBanner> {
  late Ads randomAd;
  late String msg;
  double initWidth = 0;
  void _launchURL({required String? url}) async {
    if(url == null) return;
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if(initWidth != width){
      initWidth = width;
      BlocProvider.of<AdsCubit>(context).getRandomAd(width: width);
    }
    return Container(
        margin: const EdgeInsets.only(top: 10),
        alignment: Alignment.topCenter,
        // Set width and height based on your desired banner size
        child: BlocBuilder<AdsCubit, AdsState>(
          builder: (context, state) {
            if (state is RandomAdLoaded) {
              debugPrint('Random Banner Loaded');
              randomAd = (state).ads;
              return Stack(
                children: [
                  GestureDetector(
                    child: Image.network(randomAd.image_path!),
                    onTap: (){
                      _launchURL(url: randomAd.url);
                    },
                  ),
                  Positioned(
                    top: 1, // Adjust position as needed
                    right: 0, // Adjust position as needed
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.blue),
                      onPressed: widget.onClose, // Call the provided onClose function
                    ),
                  ),
                ],
              );
              // return buildLoadedListWidgets();
            } else if (state is AdsError) {
              msg = (state).msg;
              return ErrorLoaded(errorMsg: msg);
            } else {
              return const LoadingIndicator();
            }
          },
        ));
  }
}
