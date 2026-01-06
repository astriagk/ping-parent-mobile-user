import '../../../config.dart';

class RentalInfoWidgets{
//common textField Info layout
  Widget commonTextInfoLayout(context,{dynamic data,String? title,String? subTitle}){
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidgetCommon(
              text: "• $title",
              fontSize: Sizes.s14)
              .padding(
              bottom: Sizes.s4,
              top: data.key == 0 ? Sizes.s0 : Sizes.s18),
          Row(
            children: [
              HSpace(Sizes.s10),
              Expanded(
                child: TextWidgetCommon(
                  text: subTitle,
                  color: appColor(context).appTheme.lightText,
                  fontSize: Sizes.s12,
                ),
              ),
            ],
          )
        ]);
  }

}