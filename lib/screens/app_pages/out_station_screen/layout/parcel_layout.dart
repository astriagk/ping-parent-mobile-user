import 'package:flutter/material.dart';

import '../../../../config.dart';

class ParcelLayout extends StatelessWidget {
  const ParcelLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      //common text layout
      OutStationWidgets().commonTextLayout(context,
          title: appFonts.weight, hintText: appFonts.enterFareAmount),
      VSpace(Sizes.s8),
      TextWidgetCommon(text: appFonts.comments),
      VSpace(Sizes.s8),
      TextFormField(
          maxLines: 5,
          decoration: InputDecoration(
              fillColor: appColor(context).appTheme.bgBox,
              filled: true,
              border: OutlineInputBorder(
                  borderRadius: SmoothBorderRadius(
                      cornerRadius: Sizes.s8, cornerSmoothing: 2),
                  borderSide: BorderSide(
                      color: appColor(context).appTheme.trans,
                      width: Sizes.s2)),
              hintText: appFonts.forEx,
              hintStyle: AppCss.lexendLight12
                  .textColor(appColor(context).appTheme.lightText)))
    ]);
  }
}
