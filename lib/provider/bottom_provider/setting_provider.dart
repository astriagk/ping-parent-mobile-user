import 'dart:developer';

import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:taxify_user_ui/config.dart';
import '../../widgets/common_confirmation_dialog.dart';

class SettingProvider extends ChangeNotifier {
  List setting = [];
  List currencyList = [];
  List languageList = [];
  String? selectedCurrencyOption;
  String? selectedLanguageOption;
  int selectIndex = 0;
  int selectedIndex = 0;

  // list initialization
  init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setting = appArray.setting;
    currencyList = appArray.currencyList;
    languageList = appArray.languageList;
    selectedCurrencyOption =
        prefs.getString('selectedCurrency') ?? currencyList[0]['title'];
    selectedCurrencyOption =
        prefs.getString('selectedLanguage') ?? currencyList[0]['title'];
    notifyListeners();
  }

//app setting screen onTap
  appSettingOnTap(e, context) {
    switch (e) {
      case 1:
        //COMMON DraggableSheet layout
        CommonDraggableSheet().settingModelLayout(context,
            index: e, arrayList: currencyList, isSvg: true);
        break;
      case 2:
        //COMMON DraggableSheet layout
        CommonDraggableSheet()
            .settingModelLayout(context, index: e, arrayList: languageList);
    }
  }

  // showNoInternetDialog(context, VoidCallback onRetry) {
  //   showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (BuildContext context) {
  //         return CommonDialog(
  //             onTap: onRetry,
  //             title: appFonts.noInternet,
  //             image: imageAssets.noInternet);
  //       });
  // }
  //
  // showDeleteAddressSuccess(context, VoidCallback onRetry) {
  //   showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (BuildContext context) {
  //         return CommonDialog(
  //             onTap: onRetry,
  //             title: appFonts.noInternet,
  //             image: imageAssets.noInternet);
  //       });
  // }
  //
  // showBookingCancel(context, VoidCallback onRetry) {
  //   showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (BuildContext context) {
  //         return CommonDialog(
  //             onTap: onRetry,
  //             title: appFonts.noInternet,
  //             image: imageAssets.noInternet);
  //       });
  // }

  // void showBookingSuccessfully(BuildContext context, VoidCallback onRetry) {
  //   showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (BuildContext context) {
  //         return CommonDialog(
  //             onTap: () {},
  //             title: appFonts.bookSuccessfully,
  //             image: imageAssets.bookingSuccess);
  //       });
  // }

//setting screen onTap
  settingsOnTap(e, a, context) {
    var chatCtrl = Provider.of<ChatProvider>(context, listen: false);
    if (a['subTitle'] == appFonts.profileSettings) {
      route.pushNamed(context, routeName.profileScreen);
    }
    if (a['subTitle'] == appFonts.savedLocation) {
      route.pushNamed(context, routeName.saveLocationScreen);
    }
    if (a['subTitle'] == appFonts.bankDetails) {
      route.pushNamed(context, routeName.bankDetailsScreen);
    }
    if (a['subTitle'] == appFonts.promoCodeList) {
      route.pushNamed(context, routeName.promoScreen);
    }

    if (a['subTitle'] == appFonts.appSettings) {
      route.pushNamed(context, routeName.appSettingScreen);
    }
    if (a['subTitle'] == appFonts.shareApp) {
      handleShare(context);
    }

    if (a['subTitle'] == appFonts.chatSupport) {
      route.pushNamed(context, routeName.chatScreen);
      chatCtrl.homeChat = false;
    }
    if (language(context, a['subTitle']) ==
        language(context, appFonts.deleteAccount)) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomConfirmationDialog(
                message: "Are you sure you want to delete account ?",
                onConfirm: () {
                  route.pop(context);
                  route.pushReplacementNamed(context, routeName.signInScreen);
                },
                onCancel: () {
                  route.pop(context);
                });
          });
    }
    if (language(context, a['subTitle']) ==
        language(context, appFonts.logout)) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomConfirmationDialog(
                message: "Are you sure you want to Logout ?",
                onConfirm: () {
                  route.pop(context);
                  route.pushReplacementNamed(context, routeName.signInScreen);
                },
                onCancel: () {
                  route.pop(context);
                });
          });

      // route.pushNamed(context, routeName.noInternetScreen);
    }
  }

  String text = '';
  String link = '';

  void onShare(BuildContext context, String text, String? subject) async {
    final box = context.findRenderObject() as RenderBox?;
    await Share.share(
      text,
      subject: subject,
      sharePositionOrigin:
          box != null ? box.localToGlobal(Offset.zero) & box.size : Rect.zero,
    );
  }

// Example usage:
  void handleShare(context) {
    String textToShare = 'Check out this amazing app!';
    String? subject = 'Amazing App';

    onShare(context, textToShare, subject);
  }

  // Method to save selected currency to shared preferences
  Future<void> saveSelectedCurrency(String currency) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedCurrency', currency);
  }

// Method to save selected language to shared preferences
  Future<void> saveSelectedLanguage(String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', language);
  }

  //currency change value
  currencyChangeValue(context) {
    selectedCurrencyOption =
        appArray.currencyList[selectIndex]['title'].toString();
    saveSelectedCurrency(selectedCurrencyOption!);
    currency(context).priceSymbol =
        appArray.currencyList[selectIndex]['symbol'].toString();
    final currencyData = Provider.of<CurrencyProvider>(context, listen: false);
    currencyData.currency =
        CurrencyModel.fromJson(appArray.currencyList[selectIndex]);
    currencyData.currencyVal =
        double.parse(currencyData.currency!.exchangeRate!);

    currencyData.notifyListeners();
    notifyListeners();
  }

  //language change value
  languageChangeValue(context) {
    var lan = Provider.of<LanguageProvider>(context, listen: false);
    if (appArray.languageList[selectIndex]['title'] == null ||
        appArray.languageList[selectIndex]['title'] == '') {
      // If no language is selected, default to English
      appArray.languageList[selectIndex]['title'] = 'english';
    } else {
      switch (appArray.languageList[selectIndex]['title']) {
        case 'english':
        case 'arabic':
        case 'french':
        case 'spanish':
          lan.changeLocale(
              appArray.languageList[selectIndex]['title'].toString());
          selectedLanguageOption =
              appArray.languageList[selectIndex]['title'].toString();
          // Save the selected language to shared preferences
          saveSelectedLanguage(
              appArray.languageList[selectIndex]['title'].toString());
          break;
        default:
          log("Invalid language: ${appArray.languageList[selectIndex]['title']}");
          selectedLanguageOption =
              appArray.languageList[selectIndex]['title'].toString();
      }
    }

    notifyListeners();
  }

//Radio button onTap
  commonOnTap(index, e, context) {
    if (index == 1) {
      onChangeButton(e.key);
    }
    if (index == 2) {
      onLanguageChangeButton(e.key);
    }
    notifyListeners();
  }

//common draggableSheet model update button Layout
  commonModelUpdateOnTap(index, context) {
    if (index == 1) {
      currencyChangeValue(context);
    }
    if (index == 2) {
      languageChangeValue(context);
    }
    notifyListeners();
  }

//change currency button
  onChangeButton(index) async {
    selectIndex = index;
    notifyListeners();
  } //change currency button

  //Change language button
  onLanguageChangeButton(index) async {
    selectIndex = index;
    notifyListeners();
  }
}
