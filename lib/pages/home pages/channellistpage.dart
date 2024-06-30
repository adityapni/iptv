import 'package:OOHLIVETV_iptv/GlobalWidgets/error_loaded.dart';
import 'package:OOHLIVETV_iptv/GlobalWidgets/loading_indicator.dart';
import 'package:OOHLIVETV_iptv/helpers/helpers.dart';
import 'package:OOHLIVETV_iptv/logic/cubits/free_channels/free_channels_cubit.dart';
import 'package:OOHLIVETV_iptv/pages/channelpage-iptv.dart';
import 'package:OOHLIVETV_iptv/repository/locale/admob.dart';
import 'package:OOHLIVETV_iptv/repository/models/channel_free.dart';
import 'package:flutter/material.dart';

// import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:OOHLIVETV_iptv/services/storage.dart';
import 'package:OOHLIVETV_iptv/services/Formatting.dart';
import 'package:OOHLIVETV_iptv/services/channels.dart';
import 'package:OOHLIVETV_iptv/services/routing.dart';
import 'package:OOHLIVETV_iptv/GlobalWidgets/RandomImageBanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ChannelListPage extends StatefulWidget {
  const ChannelListPage({
    super.key,
    required this.storage,
    required this.formattingProvider,
  });

  final StorageProvider storage;
  final FormattingProvider formattingProvider;

  @override  State<ChannelListPage> createState() => _ChannelListPageState();
}

class _ChannelListPageState extends State<ChannelListPage> {
  _ChannelListPageState();

  late StorageProvider storage;
  late FormattingProvider formattingProvider;
  late List<ChannelFree> freeChannels;
  late String msg;

  _favoriteIcon(String channelName) {
    if (!storage.favoritedChannels.contains(channelName)) {
      return const Icon(
        Icons.star_border,
        color: Colors.red,
      );
    } else {
      return const Icon(
        Icons.star,
        color: Colors.red,
      );
    }
  }

  _favoriteChange(int index) async {
    if (storage.favoritedChannels
        .contains(storage.channels.channelList[index].channelName)) {
      setState(() {
        storage.favoritedChannels
            .remove(storage.channels.channelList[index].channelName);
      });
    } else {
      setState(() {
        storage.favoritedChannels
            .add(storage.channels.channelList[index].channelName);
      });
    }
    await storage.saveChanges();
  }

  _goToChannel(ChannelFree freeChannel) {
    if (freeChannel.source == Source.iptv) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChannelPageIPTV(freeChannel: freeChannel)));
    }
  }

  bool isRandomImageBannerVisible = true;

  @override
  void initState() {
    super.initState();
    storage = widget.storage;
    formattingProvider = widget.formattingProvider;
    BlocProvider.of<FreeChannelsCubit>(context).getFreeChannels();
  }

  @override
  void dispose() async {
    // await _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Change the background color here:
    return Scaffold(
      appBar: AppBar(
        title: const Text("Free Channels"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Ink(
        width: 100.w,
        height: 100.h,
        decoration: kDecorBackground,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                children: [
                  if (isRandomImageBannerVisible)
                    RandomImageBanner(
                      onClose: () {
                        setState(() {
                          isRandomImageBannerVisible =
                              false; // Handle the banner closure as needed
                        });
                      },
                    ),
                  const SizedBox(
                    height: 3,
                  ),
                ],
              ),
              BlocBuilder<FreeChannelsCubit, FreeChannelsState>(
                builder: (context, state) {
                  if (state is FreeChannelsLoaded) {
                    debugPrint('Random Banner Loaded');
                    freeChannels = (state).freeChannels;
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: freeChannels.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: GestureDetector(
                              onTap: () => _goToChannel(freeChannels[index]),
                              child: Card(
                                  color: const Color(0xFFADADAD),
                                  child: Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 9.0),
                                          child: formattingProvider.formatIcon(
                                              freeChannels[index].source),
                                        ),
                                        Expanded(
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 9.0),
                                              child: Text(
                                                freeChannels[index].channelName!,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18.0,
                                                  color: Color(0xFF000000),
                                                ),
                                              )),
                                        ),
                                        GestureDetector(
                                          onTap: () => {},
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 9.0),
                                            child: _favoriteIcon(freeChannels[index].channelName!),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                          );
                        });
                    // return buildLoadedListWidgets();
                  } else if (state is FreeChannelsError) {
                    msg = (state).msg;
                    return ErrorLoaded(errorMsg: msg);
                  } else {
                    return const LoadingIndicator();
                  }
                },
              ),
              AdmobWidget.getBanner(),
            ],
          ),
        ),
      ),
    );
  }
}
