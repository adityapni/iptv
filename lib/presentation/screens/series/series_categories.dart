part of '../screens.dart';

class SeriesCategoriesScreen extends StatefulWidget {
  const SeriesCategoriesScreen({super.key});

  @override
  State<SeriesCategoriesScreen> createState() =>
      _SeriesCategoriesScreenState();
}

class _SeriesCategoriesScreenState extends State<SeriesCategoriesScreen> {
  final ScrollController _hideButtonController = ScrollController();
  bool _hideButton = true;
  String keySearch = "";

  late InterstitialAd _interstitialAd;

  _loadIntel() async {
    if (!showAds) {
      return false;
    }
    InterstitialAd.load(
        adUnitId: interstitialUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            debugPrint("Ads is Loaded");
            _interstitialAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error');
          },
        ));
  }

  bool isRandomImageBannerVisible = true;

  @override
  void initState() {
    _loadIntel();
    _hideButtonController.addListener(() {
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_hideButton == true) {
          setState(() {
            _hideButton = false;
          });
        }
      } else {
        if (_hideButtonController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (_hideButton == false) {
            setState(() {
              _hideButton = true;
            });
          }
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Visibility(
        visible: !_hideButton,
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              _hideButtonController.animateTo(0,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.ease);
              _hideButton = true;
            });
          },
          backgroundColor: kColorPrimaryDark,
          child: const Icon(
            FontAwesomeIcons.chevronUp,
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Ink(
            width: 100.w,
            height: 100.h,
            decoration: kDecorBackground,
            child: NestedScrollView(
              controller: _hideButtonController,
              headerSliverBuilder: (_, ch) {
                return [
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    expandedHeight: 70, // Adjust as needed
                    flexibleSpace: FlexibleSpaceBar(
                      background: Column(
                        children: [
                          AppBarSeries(
                            top: MediaQuery.of(context).size.height * 0.02, // Adjust as needed
                            onSearch: (String value) {
                              setState(() {
                                keySearch = value.toLowerCase();
                              });
                            },
                          ),
                          // Add RandomImageBanner here
                        ],
                      ),
                    ),
                  ),
                ];
              },
              body: BlocBuilder<SeriesCatyBloc, SeriesCatyState>(
                builder: (context, state) {
                  if (state is SeriesCatyLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is SeriesCatySuccess) {
                    final categories = state.categories;
                    final searchList = categories
                        .where((element) =>
                        element.categoryName!
                            .toLowerCase()
                            .contains(keySearch))
                        .toList();

                    return GridView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.05, // Adjust as needed
                        vertical: 15,
                      ),
                      itemCount: keySearch.isEmpty
                          ? categories.length
                          : searchList.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 4.9,
                      ),
                      itemBuilder: (_, i) {
                        final model =
                        keySearch.isEmpty ? categories[i] : searchList[i];

                        return CardLiveItem(
                          title: model.categoryName ?? "",
                          onTap: () {
                            // OPEN Channels
                            Get.to(() => SeriesChannels(
                              catyId: model.categoryId ?? '',
                            ))!
                                .then((value) async {
                              _interstitialAd.show();
                              _loadIntel();
                            });
                          },
                        );
                      },
                    );
                  }

                  return const Center(
                    child: Text("Failed to load data..."),
                  );
                },
              ),
            ),
          ),
          if (isRandomImageBannerVisible)
            Positioned(
              top: 10,
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
