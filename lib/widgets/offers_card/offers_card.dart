import '../../config.dart';
import 'offer_header_section.dart';
import 'offer_details_section.dart';
import 'offer_validity_section.dart';
import 'offer_off_label.dart';

class OffersCard extends StatelessWidget {
  final Map<String, dynamic> offerData;
  final int index;
  final VoidCallback? onTap;

  const OffersCard({
    super.key,
    required this.offerData,
    required this.index,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: appColor(context).appTheme.white,
          borderRadius: BorderRadius.circular(Sizes.s8),
          boxShadow: [
            BoxShadow(
              color: appColor(context).appTheme.primary.withValues(alpha: 0.04),
              blurRadius: 12,
              spreadRadius: 4,
            )
          ],
        ),
        child: Row(
          children: [
            // OFF label section with padding all sides s8
            const OfferOffLabel().paddingDirectional(all: Sizes.s8),
            // Main content section with right padding s15
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OfferHeaderSection(offerData: offerData, index: index),
                  DottedLine(
                    alignment: WrapAlignment.center,
                    dashLength: 5.0,
                    dashGapLength: 2.0,
                    lineThickness: 1,
                    dashColor: appColor(context).appTheme.stroke,
                    direction: Axis.horizontal,
                  ).padding(vertical: Sizes.s8),
                  OfferDetailsSection(offerData: offerData),
                  OfferValiditySection(offerData: offerData),
                ],
              ).padding(right: Sizes.s15),
            ),
          ],
        ),
      ),
    );
  }
}
