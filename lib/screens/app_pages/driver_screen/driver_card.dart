import '../../../api/models/driver_response.dart';
import '../../../config.dart';

class DriverCard extends StatelessWidget {
  final Driver driver;
  final VoidCallback onTap;
  final Color Function(BuildContext, String) getStatusColor;

  const DriverCard({
    super.key,
    required this.driver,
    required this.onTap,
    required this.getStatusColor,
  });

  @override
  Widget build(BuildContext context) {
    final driverStatus = driver.approvalStatus ?? 'active';
    final statusColor = getStatusColor(context, driverStatus);
    final displayStatus = driverStatus.replaceAll('_', ' ').toUpperCase();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: Sizes.s15, vertical: Sizes.s8),
        padding: EdgeInsets.all(Sizes.s16),
        decoration: BoxDecoration(
          color: appColor(context).appTheme.white,
          borderRadius: BorderRadius.circular(Sizes.s12),
          boxShadow: [
            BoxShadow(
              color: appColor(context).appTheme.primary.withValues(alpha: 0.04),
              blurRadius: 12,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Driver photo, name, and status
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Driver photo
                Container(
                  width: Sizes.s60,
                  height: Sizes.s60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: appColor(context).appTheme.bgBox,
                  ),
                  child: driver.photoUrl != null && driver.photoUrl!.isNotEmpty
                      ? ClipOval(
                          child: Image.network(
                            driver.photoUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.person,
                                  color: appColor(context).appTheme.lightText);
                            },
                          ),
                        )
                      : Icon(Icons.person,
                          color: appColor(context).appTheme.lightText),
                ),
                HSpace(Sizes.s16),
                // Driver info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextWidgetCommon(
                              text: driver.name ?? 'Driver',
                              style: AppCss.lexendBold16.textColor(
                                  appColor(context).appTheme.darkText),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          HSpace(Sizes.s8),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: Sizes.s10, vertical: Sizes.s4),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(Sizes.s12),
                            ),
                            child: TextWidgetCommon(
                              text: displayStatus,
                              fontSize: Sizes.s10,
                              color: statusColor,
                              fontWeight: FontWeight.w500,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      VSpace(Sizes.s4),
                      TextWidgetCommon(
                        text: driver.driverUniqueId ?? 'N/A',
                        style: AppCss.lexendRegular12
                            .textColor(appColor(context).appTheme.lightText),
                      ),
                      VSpace(Sizes.s4),
                      TextWidgetCommon(
                        text:
                            '${driver.vehicleType.toDisplayString()} • ${driver.vehicleNumber ?? 'N/A'}${driver.vehicleCapacity != null ? ' • ${driver.vehicleCapacity} seats' : ''}',
                        style: AppCss.lexendRegular12
                            .textColor(appColor(context).appTheme.darkText),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (driver.currentStudentCount != null &&
                driver.currentStudentCount! > 0) ...[
              VSpace(Sizes.s12),
              Divider(color: appColor(context).appTheme.stroke, height: 0),
              VSpace(Sizes.s12),
              Row(
                children: [
                  Icon(Icons.people,
                      size: Sizes.s16,
                      color: appColor(context).appTheme.primary),
                  HSpace(Sizes.s8),
                  TextWidgetCommon(
                    text:
                        '${driver.currentStudentCount} student${driver.currentStudentCount! > 1 ? 's' : ''} assigned',
                    style: AppCss.lexendRegular13
                        .textColor(appColor(context).appTheme.darkText),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
