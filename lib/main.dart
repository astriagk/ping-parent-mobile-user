import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as old_provider;
import 'package:skolo/provider/app_pages_providers/driver_provider.dart';
import 'package:skolo/provider/app_pages_providers/my_wallet_provider.dart';
import 'package:skolo/provider/app_pages_providers/subscriptions_provider.dart';
import 'package:skolo/provider/app_pages_providers/user_provider.dart';
import 'package:skolo/api/services/trip_tracking_service.dart';
import 'package:skolo/api/api_client.dart';
import 'package:skolo/api/services/push_notification_service.dart';
import 'firebase_options.dart';
import 'config.dart';

/// Global key for showing snackbars from anywhere (providers, services)
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with platform-specific options
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  } catch (e) {
    // Firebase initialization failed (likely iOS with missing GoogleService-Info.plist)
    print('Firebase initialization error: $e');
  }

  await ScreenUtil.ensureScreenSize();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(
    ProviderScope(
      child: const MyApp(),
    ),
  );
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
                  old_provider.ChangeNotifierProvider(
                      create: (_) => ThemeService(snapData.data!)),
                  old_provider.ChangeNotifierProvider(
                      create: (_) => LanguageProvider(snapData.data!)),
                  old_provider.ChangeNotifierProvider(create: (_) => CurrencyProvider()),
                  old_provider.ChangeNotifierProvider(create: (_) => UserProvider()),
                  old_provider.ChangeNotifierProvider(create: (_) => SplashProvider()),
                  old_provider.ChangeNotifierProvider(create: (_) => SignInProvider()),
                  old_provider.ChangeNotifierProvider(create: (_) => SignUpProvider()),
                  old_provider.ChangeNotifierProvider(create: (_) => OtpProvider()),
                  old_provider.ChangeNotifierProvider(create: (_) => DashBoardProvider()),
                  old_provider.ChangeNotifierProvider(create: (_) => HomeScreenProvider()),
                  old_provider.ChangeNotifierProvider(
                      create: (_) => TripTrackingProvider(
                          TripTrackingService(ApiClient()))),
                  old_provider.ChangeNotifierProvider(create: (_) => NotificationProvider()),
                  old_provider.ChangeNotifierProvider(create: (_) => NewLocationProvider()),
                  old_provider.ChangeNotifierProvider(create: (_) => AddLocationProvider()),
                  old_provider.ChangeNotifierProvider(create: (_) => SettingProvider()),
                  old_provider.ChangeNotifierProvider(create: (_) => BankDetailsProvider()),
                  old_provider.ChangeNotifierProvider(create: (_) => PromoProvider()),
                  old_provider.ChangeNotifierProvider(create: (_) => MyWalletProvider()),
                  old_provider.ChangeNotifierProvider(create: (_) => SaveLocationProvider()),
                  old_provider.ChangeNotifierProvider(create: (_) => AppSettingProvider()),
                  old_provider.ChangeNotifierProvider(create: (_) => ChatProvider()),
                  old_provider.ChangeNotifierProvider(create: (_) => DateTimeProvider()),
                  old_provider.ChangeNotifierProvider(
                      create: (_) => SearchLocationProvider()),
                  old_provider.ChangeNotifierProvider(create: (_) => SwitchRiderProvider()),
                  old_provider.ChangeNotifierProvider(create: (_) => ChooseRiderProvider()),
                  old_provider.ChangeNotifierProvider(create: (_) => SelectRiderProvider()),
                  old_provider.ChangeNotifierProvider(
                      create: (_) => LoadingScreenProvider()),
                  old_provider.ChangeNotifierProvider(create: (_) => CancelRideProvider()),
                  old_provider.ChangeNotifierProvider(create: (_) => CategoryProvider()),
                  old_provider.ChangeNotifierProvider(create: (_) => OutStationProvider()),
                  old_provider.ChangeNotifierProvider(
                      create: (_) => FindingDriverProvider()),
                  old_provider.ChangeNotifierProvider(create: (_) => RentalProvider()),
                  old_provider.ChangeNotifierProvider(create: (_) => MyRideScreenProvider()),
                  old_provider.ChangeNotifierProvider(
                      create: (_) => CompletedRideProvider()),
                  old_provider.ChangeNotifierProvider(create: (_) => AcceptRideProvider()),
                  old_provider.ChangeNotifierProvider(create: (_) => AddStudentProvider()),
                  old_provider.ChangeNotifierProvider(create: (_) => DriverProvider()),
                  old_provider.ChangeNotifierProvider(
                      create: (_) => SubscriptionsProvider()),
                  old_provider.ChangeNotifierProvider(create: (_) => RazorpayProvider())
                ],
                child: old_provider.Consumer<ThemeService>(builder: (context, theme, child) {
                  return old_provider.Consumer<LanguageProvider>(
                      builder: (context, lang, child) {
                    return old_provider.Consumer<CurrencyProvider>(
                        builder: (context, currency, child) {
                      return ScreenUtilInit(
                          child: MaterialApp(
                              scaffoldMessengerKey: scaffoldMessengerKey,
                              title: appFonts.taxify,
                              debugShowCheckedModeBanner: false,
                              navigatorObservers: [routeObserver],
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
