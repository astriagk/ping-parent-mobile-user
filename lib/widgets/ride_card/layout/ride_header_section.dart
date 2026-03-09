import 'package:skolo/config.dart';
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
    final hasImage = rideData.image != null && rideData.image!.isNotEmpty;
    final showSvgAsset = hasImage && !isNetworkImage;
    final avatarImageProvider = isNetworkImage && hasImage
        ? NetworkImage(rideData.image!) as ImageProvider
        : AssetImage(imageAssets.profileImg);

    return Row(children: [
      Container(
          height: Sizes.s50,
          width: Sizes.s50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Sizes.s7),
              color: appColor(context).appTheme.bgBox,
              image: showSvgAsset
                  ? null
                  : DecorationImage(
                      image: avatarImageProvider,
                      fit: BoxFit.cover,
                      onError: (exception, stackTrace) {})),
          child: showSvgAsset
              ? SvgPicture.asset(rideData.image ?? '')
                  .padding(horizontal: Sizes.s4)
              : null),
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
