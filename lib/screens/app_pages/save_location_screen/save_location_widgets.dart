import 'package:skolo/config.dart';

class SaveLocationWidgets {
  Widget saveAddressLayout(dynamic e, BuildContext context) {
    final addressLine1 = e['addressLine1'] as String? ?? '';
    final addressLine2 = e['addressLine2'] as String? ?? '';
    final city = e['city'] as String? ?? '';
    final state = e['state'] as String? ?? '';
    final pincode = e['pincode'] as String? ?? '';

    final cityStateLine = [
      if (city.isNotEmpty) city,
      if (state.isNotEmpty) state,
    ].join(', ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(
          color: appColor(context).appTheme.stroke,
          height: 1,
          thickness: 1,
        ),
        Padding(
          padding: EdgeInsets.all(Sizes.s15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: Sizes.s2),
                padding: EdgeInsets.all(Sizes.s7),
                decoration: BoxDecoration(
                  color: appColor(context)
                      .appTheme
                      .primary
                      .withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.location_on_outlined,
                  size: Sizes.s16,
                  color: appColor(context).appTheme.primary,
                ),
              ),
              HSpace(Sizes.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (addressLine1.isNotEmpty)
                      TextWidgetCommon(
                        text: addressLine1,
                        style: AppCss.lexendMedium13
                            .textColor(appColor(context).appTheme.darkText),
                      ),
                    if (addressLine2.isNotEmpty) ...[
                      VSpace(Sizes.s5),
                      TextWidgetCommon(
                        text: addressLine2,
                        style: AppCss.lexendRegular12
                            .textColor(appColor(context).appTheme.lightText),
                      ),
                    ],
                    if (cityStateLine.isNotEmpty) ...[
                      VSpace(Sizes.s5),
                      Row(
                        children: [
                          Expanded(
                            child: TextWidgetCommon(
                              text: cityStateLine,
                              style: AppCss.lexendRegular12
                                  .textColor(
                                      appColor(context).appTheme.lightText),
                            ),
                          ),
                          if (pincode.isNotEmpty) ...[
                            HSpace(Sizes.s8),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Sizes.s8, vertical: Sizes.s3),
                              decoration: BoxDecoration(
                                color: appColor(context)
                                    .appTheme
                                    .primary
                                    .withValues(alpha: 0.08),
                                borderRadius:
                                    BorderRadius.circular(Sizes.s4),
                              ),
                              child: TextWidgetCommon(
                                text: pincode,
                                style: AppCss.lexendMedium12.textColor(
                                    appColor(context).appTheme.primary),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
