import 'package:taxify_user_ui/config.dart';
import 'ride_data_model.dart';

class RideHeaderSection extends StatelessWidget {
  final RideDataModel rideData;

  const RideHeaderSection({
    super.key,
    required this.rideData,
  });

  @override
  Widget build(BuildContext context) {
    final isNetworkImage = rideData.image?.startsWith('http') ?? false;

    return Row(children: [
      Container(
          height: Sizes.s50,
          width: Sizes.s50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Sizes.s7),
              color: appColor(context).appTheme.bgBox,
              image: isNetworkImage && rideData.image!.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(rideData.image!),
                      fit: BoxFit.cover,
                      onError: (exception, stackTrace) {})
                  : null),
          child: isNetworkImage
              ? (rideData.image == null || rideData.image!.isEmpty
                  ? Icon(Icons.person,
                      size: Sizes.s30,
                      color: appColor(context).appTheme.lightText)
                  : null)
              : SvgPicture.asset(rideData.image ?? '')
                  .padding(horizontal: Sizes.s4)),
      HSpace(Sizes.s10),
      Expanded(
          child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          TextWidgetCommon(
              text: "ID : ${rideData.id ?? ''}",
              fontSize: Sizes.s13,
              fontWeight: FontWeight.w400),
          TextWidgetCommon(
              text: "• ${rideData.status ?? ''}",
              color:
                  rideData.statusColor ?? appColor(context).appTheme.lightText,
              fontSize: Sizes.s12,
              fontWeight: FontWeight.w500)
        ]),
        VSpace(Sizes.s7),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          TextWidgetCommon(
              text: rideData.price ?? '',
              color: appColor(context).appTheme.success,
              fontSize: Sizes.s13,
              fontWeight: FontWeight.w500),
          TextWidgetCommon(
              text: "${rideData.date ?? ''} at ${rideData.time ?? ''}",
              color: appColor(context).appTheme.lightText,
              fontSize: Sizes.s12,
              fontWeight: FontWeight.w300)
        ])
      ]))
    ]);
  }
}
