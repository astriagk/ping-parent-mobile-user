import '../../config.dart';
import '../../widgets/text_field_common_layout.dart';

class AuthCommonWidgets {
  //title text and text filed layout
  Widget textAndTextField(String? title, String? hintText, context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidgetCommon(text: title),
          VSpace(Sizes.s9),
          TextFieldCommon(hintText: hintText)
        ]);
  }

  Widget textAndTextField1(String? title, String? hintText, context,
      {titleColor,
      fieldBgColor,
      prefixIcon,
      style,
      TextInputType? keyboardType,
      isPerFixIcon,
      inputFormat}) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidgetCommon(text: title, color: titleColor),
          VSpace(Sizes.s9),
          TextFieldCommon1(
              inputFormat: inputFormat,
              keyboardType: keyboardType,
              style: style,
              prefixIcon: prefixIcon,
              hintText: hintText,
              color: fieldBgColor ?? appColor(context).appTheme.screenBg)
        ]);
  }

// back button and taxify logo layout
  Widget backAndLogo(context, {GestureTapCallback? onTap}) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      //common back button
      CommonIconButton(
          onTap: onTap ?? () => route.pop(context), icon: svgAssets.back),
      SvgPicture.asset(svgAssets.logo, height: Sizes.s30, width: Sizes.s70)
          .center(),
      Container()
    ]).padding(top: Sizes.s60, bottom: Sizes.s5);
  }

//gif title and subtitle layout
  Widget gifTitleText(context, String? title, String? text) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Image.asset(gifAssets.successGif,
              height: Sizes.s10, width: Sizes.s50, fit: BoxFit.fill)
          .marginOnly(top: Sizes.s30, bottom: Sizes.s6),
      TextWidgetCommon(
          text: title,
          style: AppCss.lexendMedium22
              .textColor(appColor(context).appTheme.darkText)),
      TextWidgetCommon(
              text: text,
              style: AppCss.lexendRegular13
                  .textColor(appColor(context).appTheme.lightText))
          .padding(top: Sizes.s8, bottom: Sizes.s30)
    ]);
  }

//common Rich Text layout
  Widget commonRichText(context, String? text, String? darkText,
      {Function()? onTap}) {
    return RichText(
        text: TextSpan(children: [
      TextSpan(
          text: language(context, text),
          style: AppCss.lexendRegular12
              .textColor(appColor(context).appTheme.lightText)),
      TextSpan(
          recognizer: TapGestureRecognizer()..onTap = onTap,
          text: " ${language(context, darkText)}",
          style: AppCss.lexendRegular12
              .textColor(appColor(context).appTheme.darkText))
    ])).center();
  }

//common car image layout
  Widget commonImage() {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Image.asset(
          imageAssets.authLayoutBg,
          fit: BoxFit.cover,
        ));
  }
}
