import 'package:url_launcher/url_launcher.dart';
import '../../api/models/driver_response.dart';
import '../../config.dart';

class DriverCard extends StatelessWidget {
  final Driver driver;
  final VoidCallback onTap;

  const DriverCard({
    super.key,
    required this.driver,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasPhoto = driver.photoUrl != null && driver.photoUrl!.isNotEmpty;
    final phoneNumber = driver.user?.phoneNumber;
    final vehicleInfo = _buildVehicleInfo();

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: photo + name/id + approved badge
          Row(
            children: [
              // Driver photo
              Container(
                height: Sizes.s56,
                width: Sizes.s56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: appColor(context).appTheme.bgBox,
                  image: hasPhoto
                      ? DecorationImage(
                          image: NetworkImage(driver.photoUrl!),
                          fit: BoxFit.cover,
                          onError: (_, __) {},
                        )
                      : DecorationImage(
                          image: AssetImage(imageAssets.profileImg),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              HSpace(Sizes.s12),
              // Name + ID
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidgetCommon(
                      text: driver.name ?? '—',
                      style: AppCss.lexendMedium14
                          .textColor(appColor(context).appTheme.darkText),
                    ),
                    VSpace(Sizes.s4),
                    TextWidgetCommon(
                      text: 'ID: ${driver.driverUniqueId?.toUpperCase() ?? '—'}',
                      style: AppCss.lexendRegular12
                          .textColor(appColor(context).appTheme.lightText),
                    ),
                  ],
                ),
              ),
              // Approved badge
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Sizes.s10,
                  vertical: Sizes.s4,
                ),
                decoration: BoxDecoration(
                  color: appColor(context)
                      .appTheme
                      .activeColor
                      .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(Sizes.s20),
                ),
                child: TextWidgetCommon(
                  text: 'Approved',
                  style: AppCss.lexendMedium12
                      .textColor(appColor(context).appTheme.activeColor),
                ),
              ),
            ],
          ),

          DottedLine(dashColor: appColor(context).appTheme.stroke)
              .padding(vertical: Sizes.s12),

          // Vehicle info row
          if (vehicleInfo.isNotEmpty)
            Row(
              children: [
                Icon(
                  Icons.directions_car_outlined,
                  size: Sizes.s16,
                  color: appColor(context).appTheme.lightText,
                ),
                HSpace(Sizes.s8),
                Expanded(
                  child: TextWidgetCommon(
                    text: vehicleInfo,
                    style: AppCss.lexendRegular13
                        .textColor(appColor(context).appTheme.darkText),
                  ),
                ),
              ],
            ).padding(bottom: Sizes.s8),

          // Phone number row with call button
          if (phoneNumber != null && phoneNumber.isNotEmpty)
            Row(
              children: [
                Icon(
                  Icons.phone_outlined,
                  size: Sizes.s16,
                  color: appColor(context).appTheme.lightText,
                ),
                HSpace(Sizes.s8),
                Expanded(
                  child: TextWidgetCommon(
                    text: phoneNumber,
                    style: AppCss.lexendRegular13
                        .textColor(appColor(context).appTheme.darkText),
                  ),
                ),
                GestureDetector(
                  onTap: () => _launchCall(phoneNumber),
                  child: Container(
                    padding: EdgeInsets.all(Sizes.s6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: appColor(context)
                          .appTheme
                          .activeColor
                          .withValues(alpha: 0.12),
                    ),
                    child: Icon(
                      Icons.call_outlined,
                      size: Sizes.s16,
                      color: appColor(context).appTheme.activeColor,
                    ),
                  ),
                ),
              ],
            ).padding(bottom: Sizes.s8),

          // Trip type + student count row
          Row(
            children: [
              Icon(
                Icons.swap_horiz_rounded,
                size: Sizes.s16,
                color: appColor(context).appTheme.lightText,
              ),
              HSpace(Sizes.s8),
              TextWidgetCommon(
                text: _buildTripInfo(),
                style: AppCss.lexendRegular13
                    .textColor(appColor(context).appTheme.darkText),
              ),
            ],
          ),
        ],
      ).myRideListExtension(context),
    );
  }

  Future<void> _launchCall(String phoneNumber) async {
    final uri = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  String _buildVehicleInfo() {
    final parts = <String>[];
    parts.add(driver.vehicleType.toDisplayString());
    if (driver.vehicleNumber != null && driver.vehicleNumber!.isNotEmpty) {
      parts.add(driver.vehicleNumber!.toUpperCase());
    }
    if (driver.vehicleCapacity != null) {
      parts.add('${driver.vehicleCapacity} seats');
    }
    return parts.join('  •  ');
  }

  String _buildTripInfo() {
    final parts = <String>[];
    if (driver.tripType != null) {
      parts.add(driver.tripType!.toDisplayString());
    }
    final count = driver.currentStudentCount ?? 0;
    parts.add('$count ${count == 1 ? 'student' : 'students'} assigned');
    return parts.join('  •  ');
  }
}
