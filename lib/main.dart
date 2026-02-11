import 'package:flutter/services.dart';
import 'package:taxify_user_ui/provider/app_pages_providers/driver_provider.dart';
import 'package:taxify_user_ui/provider/app_pages_providers/my_wallet_provider.dart';
import 'package:taxify_user_ui/provider/app_pages_providers/subscriptions_provider.dart';
import 'package:taxify_user_ui/provider/app_pages_providers/user_provider.dart';
import 'package:taxify_user_ui/api/services/trip_tracking_service.dart';
import 'package:taxify_user_ui/api/api_client.dart';
import 'config.dart';

/// Global key for showing snackbars from anywhere (providers, services)
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, AsyncSnapshot<SharedPreferences> snapData) {
          if (snapData.hasData) {
            return MultiProvider(
                providers: [
                  ChangeNotifierProvider(
                      create: (_) => ThemeService(snapData.data!)),
                  ChangeNotifierProvider(
                      create: (_) => LanguageProvider(snapData.data!)),
                  ChangeNotifierProvider(create: (_) => CurrencyProvider()),
                  ChangeNotifierProvider(create: (_) => UserProvider()),
                  ChangeNotifierProvider(create: (_) => SplashProvider()),
                  ChangeNotifierProvider(create: (_) => SignInProvider()),
                  ChangeNotifierProvider(create: (_) => OtpProvider()),
                  ChangeNotifierProvider(create: (_) => DashBoardProvider()),
                  ChangeNotifierProvider(create: (_) => HomeScreenProvider()),
                  ChangeNotifierProvider(
                      create: (_) => TripTrackingProvider(
                          TripTrackingService(ApiClient()))),
                  ChangeNotifierProvider(create: (_) => NotificationProvider()),
                  ChangeNotifierProvider(create: (_) => NewLocationProvider()),
                  ChangeNotifierProvider(create: (_) => AddLocationProvider()),
                  ChangeNotifierProvider(create: (_) => SettingProvider()),
                  ChangeNotifierProvider(create: (_) => BankDetailsProvider()),
                  ChangeNotifierProvider(create: (_) => PromoProvider()),
                  ChangeNotifierProvider(create: (_) => MyWalletProvider()),
                  ChangeNotifierProvider(create: (_) => SaveLocationProvider()),
                  ChangeNotifierProvider(create: (_) => AppSettingProvider()),
                  ChangeNotifierProvider(create: (_) => ChatProvider()),
                  ChangeNotifierProvider(create: (_) => DateTimeProvider()),
                  ChangeNotifierProvider(
                      create: (_) => SearchLocationProvider()),
                  ChangeNotifierProvider(create: (_) => SwitchRiderProvider()),
                  ChangeNotifierProvider(create: (_) => ChooseRiderProvider()),
                  ChangeNotifierProvider(create: (_) => SelectRiderProvider()),
                  ChangeNotifierProvider(
                      create: (_) => LoadingScreenProvider()),
                  ChangeNotifierProvider(create: (_) => CancelRideProvider()),
                  ChangeNotifierProvider(create: (_) => CategoryProvider()),
                  ChangeNotifierProvider(create: (_) => OutStationProvider()),
                  ChangeNotifierProvider(
                      create: (_) => FindingDriverProvider()),
                  ChangeNotifierProvider(create: (_) => RentalProvider()),
                  ChangeNotifierProvider(create: (_) => MyRideScreenProvider()),
                  ChangeNotifierProvider(
                      create: (_) => CompletedRideProvider()),
                  ChangeNotifierProvider(create: (_) => AcceptRideProvider()),
                  ChangeNotifierProvider(create: (_) => AddStudentProvider()),
                  ChangeNotifierProvider(create: (_) => DriverProvider()),
                  ChangeNotifierProvider(create: (_) => SubscriptionsProvider())
                ],
                child: Consumer<ThemeService>(builder: (context, theme, child) {
                  return Consumer<LanguageProvider>(
                      builder: (context, lang, child) {
                    return Consumer<CurrencyProvider>(
                        builder: (context, currency, child) {
                      return ScreenUtilInit(
                          child: MaterialApp(
                              scaffoldMessengerKey: scaffoldMessengerKey,
                              title: appFonts.taxify,
                              debugShowCheckedModeBanner: false,
                              theme:
                                  AppTheme.fromType(ThemeType.light).themeData,
                              darkTheme:
                                  AppTheme.fromType(ThemeType.dark).themeData,
                              locale: lang.locale,
                              localizationsDelegates: const [
                                AppLocalizations.delegate,
                                AppLocalizationDelagate(),
                                GlobalMaterialLocalizations.delegate,
                                GlobalWidgetsLocalizations.delegate,
                                GlobalCupertinoLocalizations.delegate
                              ],
                              supportedLocales: appArray.localList,
                              themeMode: theme.theme,
                              initialRoute: "/",
                              routes: appRoute.route));
                    });
                  });
                }));
          } else {
            return ScreenUtilInit(
                child: MaterialApp(
                    theme: AppTheme.fromType(ThemeType.light).themeData,
                    darkTheme: AppTheme.fromType(ThemeType.dark).themeData,
                    themeMode: ThemeMode.light,
                    debugShowCheckedModeBanner: false,
                    home: const SplashLayout()));
          }
        });
  }
}
