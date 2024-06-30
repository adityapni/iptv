part of 'screens.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  bool isRandomImageBannerVisible = true;

  @override
  void initState() {
    context.read<FavoritesCubit>().initialData();
    context.read<WatchingCubit>().initialData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double bannerHeight = MediaQuery.of(context).size.height * 0.1;
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Ink(
            width: 100.w,
            height: 100.h,
            decoration: kDecorBackground,
            padding: const EdgeInsets.only(left: 10, right: 10, top: 13),
            child: Column(
              children: [
                const AppBarWelcome(),
                const SizedBox(height: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: BlocBuilder<LiveCatyBloc, LiveCatyState>(
                            builder: (context, state) {
                              if (state is LiveCatyLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (state is LiveCatySuccess) {
                                return CardWelcomeTv(
                                  title: "LIVE TV",
                                  autoFocus: true,
                                  subTitle: "${state.categories.length} Channels",
                                  icon: kIconLive,
                                  onTap: () async {
                                    Get.toNamed(screenLiveCategories);
                                  },
                                );
                              }

                              return const Text('error live caty');
                            },
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: BlocBuilder<MovieCatyBloc, MovieCatyState>(
                            builder: (context, state) {
                              if (state is MovieCatyLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (state is MovieCatySuccess) {
                                return CardWelcomeTv(
                                  title: "Movies",
                                  subTitle: "${state.categories.length} Channels",
                                  icon: kIconMovies,
                                  onTap: () async {
                                    Get.toNamed(screenMovieCategories);
                                  },
                                );
                              }

                              return const Text('error movie caty');
                            },
                          ),
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        Expanded(
                          child: BlocBuilder<SeriesCatyBloc, SeriesCatyState>(
                            builder: (context, state) {
                              if (state is SeriesCatyLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (state is SeriesCatySuccess) {
                                return CardWelcomeTv(
                                  title: "Series",
                                  subTitle: "${state.categories.length} Channels",
                                  icon: kIconSeries,
                                  onTap: () async {
                                    Get.toNamed(screenSeriesCategories);
                                  },
                                );
                              }

                              return const Text('could not load series');
                            },
                          ),
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        // Removed unused SizedBox widgets

                        SizedBox(
                          width: 30.w,
                          // Removed height property
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CardWelcomeSetting(
                                title: 'Catch up',
                                icon: FontAwesomeIcons.rotate,
                                onTap: () {
                                  Get.toNamed(screenCatchUp);
                                },
                              ),
                              CardWelcomeSetting(
                                title: 'FREE CHANNELS',
                                icon: FontAwesomeIcons.heart,
                                onTap: () {
                                  Get.toNamed("/channel-list");
                                },
                              ),
                              CardWelcomeSetting(
                                title: 'Settings',
                                icon: FontAwesomeIcons.gear,
                                onTap: () {
                                  Get.toNamed(screenSettings);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'By using this application, you agree to the',
                      style: Get.textTheme.titleSmall!.copyWith(
                        fontSize: 12.sp,
                        color: Colors.grey,
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        await launchUrlString(kPrivacy);
                      },
                      child: Text(
                        ' Terms of Services.',
                        style: Get.textTheme.titleSmall!.copyWith(
                          fontSize: 12.sp,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isRandomImageBannerVisible)
            Positioned(
              top: 0,
              width: 250 > 70.w ? 70.w : 250,
              child: RandomImageBanner(
                onClose: () {
                  setState(() {
                    isRandomImageBannerVisible =
                    false; // Handle the banner closure as needed
                  });
                },
              ),
            ),
          AdmobWidget.getBanner(),
        ],
      ),
    );
  }
}
