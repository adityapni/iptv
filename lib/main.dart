import 'package:OOHLIVETV_iptv/logic/cubits/ads/ads_cubit.dart';
import 'package:OOHLIVETV_iptv/logic/cubits/free_channels/free_channels_cubit.dart';
import 'package:OOHLIVETV_iptv/repository/api/ads.dart';
import 'package:OOHLIVETV_iptv/repository/locale/ads.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:media_kit/media_kit.dart';  // Import the media_kit library
import 'package:OOHLIVETV_iptv/pages/home%20pages/channellistpage.dart';
import 'package:OOHLIVETV_iptv/repository/api/api.dart';
import 'package:OOHLIVETV_iptv/services/storage.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:video_player_media_kit/video_player_media_kit.dart';
import 'package:video_player_win/video_player_win_method_channel.dart';
import 'package:video_player_win/video_player_win_platform_interface.dart';
import 'package:win32/win32.dart';
import 'helpers/helpers.dart';
import 'logic/blocs/auth/auth_bloc.dart';
import 'logic/blocs/categories/channels/channels_bloc.dart';
import 'logic/blocs/categories/live_caty/live_caty_bloc.dart';
import 'logic/blocs/categories/movie_caty/movie_caty_bloc.dart';
import 'logic/blocs/categories/series_caty/series_caty_bloc.dart';
import 'logic/cubits/favorites/favorites_cubit.dart';
import 'logic/cubits/settings/settings_cubit.dart';
import 'logic/cubits/video/video_cubit.dart';
import 'logic/cubits/watch/watching_cubit.dart';
import 'presentation/screens/screens.dart';
import 'services/Formatting.dart';
import 'package:video_player_win/video_player_win_plugin.dart';
import 'package:video_player_win/video_player_win.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  // WindowsVideoPlayer.registerWith();
  VideoPlayerMediaKit.ensureInitialized();
  WindowInteractionState;
  WIN32_FIND_DATA;
  MethodChannelVideoPlayerWin;
  VideoPlayerWinPlatform.instance;// Ensure that media_kit is initialized
  VideoPlayerMediaKit.ensureInitialized(
    macOS: true,
    windows: true,
    linux: true,
  );
  await GetStorage.init();
  await GetStorage.init("favorites");
  if (showAds) {
    await MobileAds.instance.initialize();
    var devices = ['9498EAE76AA6F6876B6C15851F29A38D'];
    RequestConfiguration requestConfiguration = RequestConfiguration(
      testDeviceIds: devices
    );
    MobileAds.instance.updateRequestConfiguration(requestConfiguration);
  }

  runApp(MyApp(
    iptv: IpTvApi(),
    authApi: AuthApi(),
    watchingLocale: WatchingLocale(),
    favoriteLocale: FavoriteLocale(),
    adsLocale: AdsLocale(AdsApi()),
  ));
}

class MyApp extends StatefulWidget {
  final IpTvApi iptv;
  final AuthApi authApi;
  final WatchingLocale watchingLocale;
  final FavoriteLocale favoriteLocale;
  final AdsLocale adsLocale;

  const MyApp({
    super.key,
    required this.iptv,
    required this.authApi,
    required this.watchingLocale,
    required this.favoriteLocale,
    required this.adsLocale,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    //Enable FullScreen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }


  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent()
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (BuildContext context) => AuthBloc(widget.authApi),
          ),
          BlocProvider<LiveCatyBloc>(
            create: (BuildContext context) => LiveCatyBloc(widget.iptv),
          ),
          BlocProvider<ChannelsBloc>(
            create: (BuildContext context) => ChannelsBloc(widget.iptv),
          ),
          BlocProvider<MovieCatyBloc>(
            create: (BuildContext context) => MovieCatyBloc(widget.iptv),
          ),
          BlocProvider<SeriesCatyBloc>(
            create: (BuildContext context) => SeriesCatyBloc(widget.iptv),
          ),
          BlocProvider<VideoCubit>(
            create: (BuildContext context) => VideoCubit(),
          ),
          BlocProvider<SettingsCubit>(
            create: (BuildContext context) => SettingsCubit(),
          ),
          BlocProvider<WatchingCubit>(
            create: (BuildContext context) =>
                WatchingCubit(widget.watchingLocale),
          ),
          BlocProvider<FavoritesCubit>(
            create: (BuildContext context) =>
                FavoritesCubit(widget.favoriteLocale),
          ),
          BlocProvider<AdsCubit>(
            create: (BuildContext context) => AdsCubit(widget.adsLocale),
          ),
          BlocProvider<FreeChannelsCubit>(
            create: (BuildContext context) => FreeChannelsCubit(),
          ),
        ],
        child: ResponsiveSizer(
          builder: (context, orient, type) {
            return GetMaterialApp(
              title: 'OOH LIVE TV',
              theme: MyThemApp.themeData(context),
              debugShowCheckedModeBanner: false,
              initialRoute: "/",
              getPages: [
                GetPage(name: screenSplash, page: () => const SplashScreen()),
                GetPage(name: screenWelcome, page: () => const WelcomeScreen()),
                GetPage(name: screenIntro, page: () => const IntroScreen()),
                GetPage(
                  name: screenLiveCategories,
                  page: () => const LiveCategoriesScreen(),
                ),
                GetPage(name: screenRegister, page: () => const RegisterScreen()),
                GetPage(
                  name: screenRegisterTv,
                  page: () => const RegisterUserTv(),
                ),
                GetPage(name: screenMovieCategories, page: () => const MovieCategoriesScreen()),
                GetPage(
                  name: screenSeriesCategories,
                  page: () => const SeriesCategoriesScreen(),
                ),
                GetPage(name: screenSettings, page: () => const SettingsScreen()),
                GetPage(name: screenFavourite, page: () => const FavouriteScreen()),
                GetPage(name: screenCatchUp, page: () => const CatchUpScreen()),
                GetPage(
                  name: '/channel-list',
                  page: () => ChannelListPage(
                    storage: StorageProvider(),
                    formattingProvider: FormattingProvider(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
