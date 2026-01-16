import 'package:taxify_user_ui/config.dart';

class InfoCard extends StatelessWidget {
  final String? image;
  final String? id;
  final String? status;
  final Color? statusColor;
  final String? price;
  final String? date;
  final String? time;
  final String? driverName;
  final String? rating;
  final String? userRatingNumber;
  final String? carName;
  final String? profileImage;
  final String? pickupLocation;
  final String? dropLocation;
  final VoidCallback? onTap;

  const InfoCard({
    super.key,
    this.image,
    this.id,
    this.status,
    this.statusColor,
    this.price,
    this.date,
    this.time,
    this.driverName,
    this.rating,
    this.userRatingNumber,
    this.carName,
    this.profileImage,
    this.pickupLocation,
    this.dropLocation,
    this.onTap,
  });

  bool _hasValue(String? value) => value != null && value.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                height: Sizes.s50,
                width: Sizes.s50,
                child: SvgPicture.asset(image ?? svgAssets.car)
                    .padding(horizontal: Sizes.s4)
                    .decorated(
                        color: appColor(context).appTheme.bgBox,
                        allRadius: Sizes.s7),
              ),
              HSpace(Sizes.s10),
              Expanded(
                child: Column(
                  children: [
                    if (_hasValue(id) || _hasValue(status))
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (_hasValue(id))
                            TextWidgetCommon(
                              text: "ID : $id",
                              fontSize: Sizes.s13,
                              fontWeight: FontWeight.w400,
                            ),
                          if (_hasValue(status))
                            TextWidgetCommon(
                              text: "• $status",
                              color: statusColor ??
                                  appColor(context).appTheme.lightText,
                              fontSize: Sizes.s12,
                              fontWeight: FontWeight.w500,
                            ),
                        ],
                      ),
                    if (_hasValue(price) ||
                        _hasValue(date) ||
                        _hasValue(time)) ...[
                      VSpace(Sizes.s7),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (_hasValue(price))
                            TextWidgetCommon(
                              text:
                                  '${getSymbol(context)}${(currency(context).currencyVal * double.parse(price!)).toStringAsFixed(2)}',
                              color: appColor(context).appTheme.success,
                              fontSize: Sizes.s13,
                              fontWeight: FontWeight.w500,
                            ),
                          if (_hasValue(date) || _hasValue(time))
                            TextWidgetCommon(
                              text: _hasValue(date) && _hasValue(time)
                                  ? "$date at $time"
                                  : _hasValue(date)
                                      ? date!
                                      : time!,
                              color: appColor(context).appTheme.lightText,
                              fontSize: Sizes.s12,
                              fontWeight: FontWeight.w300,
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (_hasValue(id) ||
              _hasValue(status) ||
              _hasValue(price) ||
              _hasValue(date) ||
              _hasValue(time) ||
              _hasValue(driverName) ||
              _hasValue(rating) ||
              _hasValue(carName))
            DottedLine(dashColor: appColor(context).appTheme.stroke)
                .padding(vertical: Sizes.s15),
          if (_hasValue(driverName) ||
              _hasValue(rating) ||
              _hasValue(carName) ||
              _hasValue(profileImage))
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_hasValue(driverName) ||
                    _hasValue(rating) ||
                    _hasValue(carName))
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_hasValue(driverName) || _hasValue(rating))
                        Row(
                          children: [
                            if (_hasValue(driverName))
                              TextWidgetCommon(
                                text: driverName!,
                                fontSize: Sizes.s12,
                                fontWeight: FontWeight.w400,
                              ),
                            if (_hasValue(rating)) ...[
                              HSpace(Sizes.s6),
                              SvgPicture.asset(svgAssets.star),
                              HSpace(Sizes.s4),
                              TextWidgetCommon(
                                text: rating!,
                                fontSize: Sizes.s12,
                                fontWeight: FontWeight.w400,
                              ),
                            ],
                            if (_hasValue(userRatingNumber))
                              TextWidgetCommon(
                                text: userRatingNumber!,
                                color: appColor(context).appTheme.lightText,
                                fontSize: Sizes.s12,
                                fontWeight: FontWeight.w400,
                              ),
                          ],
                        ),
                      if (_hasValue(carName)) ...[
                        VSpace(Sizes.s4),
                        TextWidgetCommon(
                          text: carName!,
                          color: appColor(context).appTheme.lightText,
                        ),
                      ],
                    ],
                  ),
                if (_hasValue(profileImage))
                  Container(
                    height: Insets.i32,
                    width: Insets.i32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: profileImage!.startsWith('http')
                            ? NetworkImage(profileImage!) as ImageProvider
                            : AssetImage(profileImage!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                else
                  Container(
                    height: Insets.i32,
                    width: Insets.i32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(imageAssets.profileImg),
                      ),
                    ),
                  ),
              ],
            ),
          if (_hasValue(pickupLocation) || _hasValue(dropLocation)) ...[
            VSpace(Sizes.s15),
            FindingLocationLayout(
              data: {
                'currentLocation': pickupLocation ?? '',
                'addLocation': dropLocation ?? '',
              },
              loc1Color: appColor(context).appTheme.darkText,
            ).padding(horizontal: Sizes.s10, vertical: Sizes.s10).decorated(
                color: appColor(context).appTheme.bgBox, allRadius: Sizes.s8),
          ],
        ],
      ).myRideListExtension(context),
    );
  }
}
