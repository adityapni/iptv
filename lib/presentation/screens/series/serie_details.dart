part of '../screens.dart';

class SerieContent extends StatefulWidget {
  const SerieContent(
      {super.key, required this.videoId, required this.channelSerie});
  final String videoId;
  final ChannelSerie channelSerie;

  @override
  State<SerieContent> createState() => _SerieContentState();
}

class _SerieContentState extends State<SerieContent> {
  late Future<SerieDetails?> future;
  bool isRandomImageBannerVisible = true;

  @override
  void initState() {
    future = IpTvApi.getSerieDetails(widget.videoId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Ink(
            decoration: kDecorBackground,
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthSuccess) {
                  //  final userAuth = state.user;
                  return Stack(
                    children: [
                      FutureBuilder<SerieDetails?>(
                        future: future,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (!snapshot.hasData) {
                            return const Center(
                              child: Text("Could not load data"),
                            );
                          }

                          final movie = snapshot.data;

                          return Stack(
                            children: [
                              CardMovieImagesBackground(
                                listImages: movie!.info!.backdropPath ?? [],
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 20.h,
                                  left: 10,
                                  right: 10,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CardMovieImageRate(
                                      image: movie.info!.cover ?? "",
                                      rate: movie.info!.rating ?? "0",
                                    ),
                                    SizedBox(width: 3.w),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        padding:
                                            const EdgeInsets.only(bottom: 15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              movie.info!.name ?? "",
                                              style: Get.textTheme.displaySmall,
                                            ),
                                            const SizedBox(height: 15),
                                            Wrap(
                                              // crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                CardInfoMovie(
                                                  icon: FontAwesomeIcons
                                                      .clapperboard,
                                                  hint: 'Director',
                                                  title: movie.info!.director ??
                                                      "",
                                                ),
                                                CardInfoMovie(
                                                  icon: FontAwesomeIcons
                                                      .calendarDay,
                                                  hint: 'Release Date',
                                                  title:
                                                      movie.info!.releaseDate ??
                                                          "N/a",
                                                ),
                                                CardInfoMovie(
                                                  icon: FontAwesomeIcons.users,
                                                  hint: 'Cast',
                                                  isShowMore: true,
                                                  title: movie.info!.cast ?? "",
                                                ),
                                                CardInfoMovie(
                                                  icon: FontAwesomeIcons.film,
                                                  hint: 'Genre:',
                                                  isShowMore: true,
                                                  title:
                                                      movie.info!.genre ?? "",
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 15),
                                            CardInfoMovie(
                                              icon: FontAwesomeIcons
                                                  .solidClosedCaptioning,
                                              hint: 'Plot:',
                                              title: movie.info!.plot ?? "",
                                              isShowMore: true,
                                            ),
                                            const SizedBox(height: 15),
                                            Row(
                                              children: [
                                                if (movie.info!
                                                            .youtubeTrailer !=
                                                        null &&
                                                    movie.info!.youtubeTrailer!
                                                        .isNotEmpty)
                                                  CardButtonWatchMovie(
                                                    title: "watch trailer",
                                                    onTap: () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (builder) =>
                                                              DialogTrailerYoutube(
                                                                  thumb: movie
                                                                          .info!
                                                                          .backdropPath!
                                                                          .isNotEmpty
                                                                      ? movie
                                                                          .info!
                                                                          .backdropPath!
                                                                          .first
                                                                      : null,
                                                                  trailer: movie
                                                                          .info!
                                                                          .youtubeTrailer ??
                                                                      ""));
                                                    },
                                                  ),
                                                if (movie.info!
                                                            .youtubeTrailer !=
                                                        null &&
                                                    movie.info!.youtubeTrailer!
                                                        .isNotEmpty)
                                                  SizedBox(width: 3.w),
                                                CardButtonWatchMovie(
                                                  title: "watch Now",
                                                  isFocused: true,
                                                  onTap: () {
                                                    Get.to(() => SerieSeasons(
                                                        serieDetails: movie));
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      BlocBuilder<FavoritesCubit, FavoritesState>(
                        builder: (context, state) {
                          final isLiked = state.series
                              .where((movie) =>
                                  movie.seriesId ==
                                  widget.channelSerie.seriesId)
                              .isNotEmpty;
                          return AppBarSeries(
                            isLiked: isLiked,
                            top: 3.h,
                            onFavorite: () {
                              context.read<FavoritesCubit>().addSerie(
                                  widget.channelSerie,
                                  isAdd: !isLiked);
                            },
                          );
                        },
                      ),
                    ],
                  );
                }

                return const SizedBox();
              },
            ),
          ),
          if (isRandomImageBannerVisible)
            Positioned(
              top: 10,
              width: 250 > 70.w ? 70.w : 250,
              child: RandomImageBanner(
                onClose: () {
                  setState(() {
                    isRandomImageBannerVisible = false;// Handle the banner closure as needed
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
