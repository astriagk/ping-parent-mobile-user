import '../../config.dart';

class DriverCardSkeleton extends StatelessWidget {
  const DriverCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          // Header: Photo, name, and status
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Driver photo skeleton
              Container(
                width: Sizes.s60,
                height: Sizes.s60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: appColor(context).appTheme.bgBox,
                ),
              ),
              HSpace(Sizes.s16),
              // Driver info skeleton
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Name skeleton
                        Expanded(
                          child: Container(
                            height: Sizes.s14,
                            width: Sizes.s120,
                            decoration: BoxDecoration(
                              color: appColor(context).appTheme.bgBox,
                              borderRadius: BorderRadius.circular(Sizes.s4),
                            ),
                          ),
                        ),
                        HSpace(Sizes.s8),
                        // Status skeleton
                        Container(
                          height: Sizes.s20,
                          width: Sizes.s50,
                          decoration: BoxDecoration(
                            color: appColor(context).appTheme.bgBox,
                            borderRadius: BorderRadius.circular(Sizes.s12),
                          ),
                        ),
                      ],
                    ),
                    VSpace(Sizes.s8),
                    // ID skeleton
                    Container(
                      height: Sizes.s12,
                      width: Sizes.s100,
                      decoration: BoxDecoration(
                        color: appColor(context).appTheme.bgBox,
                        borderRadius: BorderRadius.circular(Sizes.s4),
                      ),
                    ),
                    VSpace(Sizes.s8),
                    // Vehicle info skeleton
                    Container(
                      height: Sizes.s12,
                      width: Sizes.s150,
                      decoration: BoxDecoration(
                        color: appColor(context).appTheme.bgBox,
                        borderRadius: BorderRadius.circular(Sizes.s4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          VSpace(Sizes.s12),
          Divider(
            color: appColor(context).appTheme.stroke,
            height: 0,
          ),
          VSpace(Sizes.s12),
          // Students count skeleton
          Row(
            children: [
              Container(
                width: Sizes.s16,
                height: Sizes.s16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: appColor(context).appTheme.bgBox,
                ),
              ),
              HSpace(Sizes.s8),
              Container(
                height: Sizes.s12,
                width: Sizes.s100,
                decoration: BoxDecoration(
                  color: appColor(context).appTheme.bgBox,
                  borderRadius: BorderRadius.circular(Sizes.s4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
