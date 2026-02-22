import 'package:intl/intl.dart';
import 'package:taxify_user_ui/config.dart';
import 'package:taxify_user_ui/api/models/subscription_recommendations_response.dart';

class SchoolCoverageCard extends StatelessWidget {
  final CurrentSubscription? currentSubscription;

  const SchoolCoverageCard({
    super.key,
    required this.currentSubscription,
  });

  @override
  Widget build(BuildContext context) {
    final currentSub = currentSubscription;
    String? formattedEndDate;
    if (currentSub != null && currentSub.endDate.isNotEmpty) {
      try {
        final endDate = DateTime.parse(currentSub.endDate).toLocal();
        formattedEndDate = DateFormat('dd MMM yyyy').format(endDate);
      } catch (_) {}
    }

    final accentColor = appColor(context).appTheme.success;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: Sizes.s20,
        vertical: Sizes.s20,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            margin: EdgeInsets.only(top: Sizes.s12),
            decoration: BoxDecoration(
              color: appColor(context).appTheme.bgBox,
              borderRadius: BorderRadius.circular(Sizes.s12),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withValues(alpha: 0.12),
                  blurRadius: 20,
                  spreadRadius: 0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Sizes.s12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          accentColor.withValues(alpha: 0.15),
                          accentColor.withValues(alpha: 0.05),
                        ],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: Sizes.s8,
                                  vertical: Sizes.s3,
                                ),
                                decoration: BoxDecoration(
                                  color: accentColor.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(Sizes.s4),
                                ),
                                child: TextWidgetCommon(
                                  text: 'SCHOOL',
                                  style: AppCss.lexendMedium10
                                      .textColor(accentColor),
                                ),
                              ),
                              VSpace(Sizes.s5),
                              TextWidgetCommon(
                                text: appFonts.schoolSponsoredPlan,
                                style: AppCss.lexendSemiBold16.textColor(
                                    appColor(context).appTheme.darkText),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(Sizes.s10),
                          decoration: BoxDecoration(
                            color: accentColor.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.school_rounded,
                            size: Sizes.s20,
                            color: accentColor,
                          ),
                        ),
                      ],
                    ).padding(all: Sizes.s12),
                  ),
                  // Body
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidgetCommon(
                        text: appFonts.coveredBySchoolDescription,
                        style: AppCss.lexendRegular12.textColor(
                            appColor(context).appTheme.lightText),
                      ),
                      DottedLine(
                        alignment: WrapAlignment.center,
                        dashLength: 5.0,
                        dashGapLength: 2.0,
                        lineThickness: 1,
                        dashColor: appColor(context).appTheme.stroke,
                        direction: Axis.horizontal,
                      ).padding(vertical: Sizes.s8),
                      if (currentSub != null) ...[
                        _DetailRow(
                          icon: Icons.calendar_today_rounded,
                          label: appFonts.remainingDays,
                          value: '${currentSub.remainingDays} days',
                        ),
                        if (formattedEndDate != null) ...[
                          VSpace(Sizes.s10),
                          _DetailRow(
                            icon: Icons.event_rounded,
                            label: appFonts.validUntil,
                            value: formattedEndDate,
                          ),
                        ],
                        VSpace(Sizes.s8),
                      ],
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Sizes.s10,
                          vertical: Sizes.s4,
                        ),
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(Sizes.s20),
                        ),
                        child: TextWidgetCommon(
                          text: appFonts.free,
                          style:
                              AppCss.lexendSemiBold12.textColor(accentColor),
                        ),
                      ),
                      const _SchoolActiveStatusRow(),
                    ],
                  ).padding(all: Sizes.s12),
                ],
              ),
            ),
          ),
          // Badge label at top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Sizes.s12,
                  vertical: Sizes.s6,
                ),
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(Sizes.s20),
                ),
                child: TextWidgetCommon(
                  text: appFonts.currentPlan,
                  style: AppCss.lexendMedium12
                      .textColor(appColor(context).appTheme.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: Sizes.s16,
          color: appColor(context).appTheme.lightText,
        ),
        HSpace(Sizes.s8),
        TextWidgetCommon(
          text: label,
          style: AppCss.lexendRegular12
              .textColor(appColor(context).appTheme.lightText),
        ),
        const Spacer(),
        TextWidgetCommon(
          text: value,
          style: AppCss.lexendMedium12
              .textColor(appColor(context).appTheme.darkText),
        ),
      ],
    );
  }
}

class _SchoolActiveStatusRow extends StatelessWidget {
  const _SchoolActiveStatusRow();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: Sizes.s12),
      padding: EdgeInsets.symmetric(
        horizontal: Sizes.s16,
        vertical: Sizes.s10,
      ),
      decoration: BoxDecoration(
        color: appColor(context).appTheme.success.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(Sizes.s20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(Sizes.s2),
            decoration: BoxDecoration(
              color:
                  appColor(context).appTheme.success.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check,
              size: Sizes.s14,
              color: appColor(context).appTheme.success,
            ),
          ),
          HSpace(Sizes.s8),
          TextWidgetCommon(
            text: appFonts.currentPlan,
            style: AppCss.lexendMedium12
                .textColor(appColor(context).appTheme.success),
          ),
        ],
      ),
    ).center();
  }
}
