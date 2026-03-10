import 'dart:io';

export 'package:skolo/common/app_array.dart';
import 'package:skolo/common/app_fonts.dart';
import 'package:skolo/screens/app_pages/my_wallet_screen/layouts/home_screen_widget.dart';
export 'package:skolo/common/session.dart';
export 'package:skolo/routes/screen_list.dart';
export 'package:skolo/common/assets/index.dart';
export 'package:skolo/helper/navigation_class.dart';
export 'package:flutter/material.dart';
export 'package:skolo/package_list.dart';
export 'package:skolo/provider/index.dart';
export 'package:skolo/models/index.dart';
export 'package:skolo/common/index.dart';
export 'package:skolo/routes/index.dart';
export 'package:flutter/physics.dart';
export 'package:skolo/widgets/index.dart';
export 'package:flutter/gestures.dart';
import 'config.dart';

Session session = Session();
AppFonts appFonts = AppFonts();
NavigationClass route = NavigationClass();
AppArray appArray = AppArray();
AppCss appCss = AppCss();
AppTheme get appTheme => _appTheme;
AppTheme _appTheme = AppTheme.fromType(ThemeType.light);
HomeScreenWidget homeScreenWidget = HomeScreenWidget();
// RouteObserver to detect page navigation (used by screens to refresh on resume)
final RouteObserver<ModalRoute<void>> routeObserver =
  RouteObserver<ModalRoute<void>>();

ThemeService appColor(context) {
  final themeServices = Provider.of<ThemeService>(context, listen: false);
  return themeServices;
}

CurrencyProvider currency(context) {
  final currencyData = Provider.of<CurrencyProvider>(context, listen: false);
  return currencyData;
}

getSymbol(context) {
  final currencyData =
      Provider.of<CurrencyProvider>(context, listen: false).priceSymbol;

  return currencyData;
}

showLoading(context) async {
  Provider.of<LoadingProvider>(context, listen: false).showLoading();
}

hideLoading(context) async {
  Provider.of<LoadingProvider>(context, listen: false).hideLoading();
}

String language(context, text) {
  return AppLocalizations.of(context)!.translate(text);
}

Future<bool> isNetworkConnection() async {
  var connectivityResult = await Connectivity()
      .checkConnectivity(); //Check For Wifi or Mobile data is ON/OFF
  if (connectivityResult == ConnectivityResult.none) {
    return false;
  } else {
    final result = await InternetAddress.lookup(
        'google.com'); //Check For Internet Connection
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
