import 'package:taxify_user_ui/config.dart';
import 'ride_data_model.dart';

class RideDriverInfoSection extends StatelessWidget {
  final RideDataModel rideData;
  final String? profileImageUrl;

  const RideDriverInfoSection({
    super.key,
    required this.rideData,
    this.profileImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          TextWidgetCommon(
              text: '${rideData.driverName}',
              fontSize: Sizes.s12,
              fontWeight: FontWeight.w400),
          HSpace(Sizes.s6),
          SvgPicture.asset(svgAssets.star),
          HSpace(Sizes.s4),
          TextWidgetCommon(
              text: '${rideData.rating}',
              fontSize: Sizes.s12,
              fontWeight: FontWeight.w400),
          TextWidgetCommon(
              text: rideData.userRatingNumber,
              color: appColor(context).appTheme.lightText,
              fontSize: Sizes.s12,
              fontWeight: FontWeight.w400),
        ]),
        VSpace(Sizes.s4),
        TextWidgetCommon(
            text: '${rideData.carName}',
            color: appColor(context).appTheme.lightText)
      ]),
      Container(
          height: Insets.i32,
          width: Insets.i32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: appColor(context).appTheme.bgBox,
            image: profileImageUrl != null && profileImageUrl!.isNotEmpty
                ? DecorationImage(
                    image: NetworkImage(profileImageUrl!),
                    fit: BoxFit.cover,
                    onError: (exception, stackTrace) {},
                  )
                : DecorationImage(image: AssetImage(imageAssets.profileImg)),
          ),
          child: profileImageUrl != null && profileImageUrl!.isNotEmpty
              ? null
              : null)
    ]);
  }
}
