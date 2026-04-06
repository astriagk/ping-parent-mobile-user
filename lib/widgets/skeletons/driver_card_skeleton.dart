import '../../config.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DriverCardSkeleton extends StatelessWidget {
  const DriverCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final shimmerColor = appColor(context).appTheme.bgBox;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top row: photo + name/id + badge
        Row(
          children: [
            // Photo skeleton
            Container(
              height: Sizes.s56,
              width: Sizes.s56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: shimmerColor,
              ),
            ),
            HSpace(Sizes.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: Sizes.s14,
                    width: Sizes.s130,
                    decoration: BoxDecoration(
                      color: shimmerColor,
                      borderRadius: BorderRadius.circular(Sizes.s4),
                    ),
                  ),
                  VSpace(Sizes.s6),
                  Container(
                    height: Sizes.s12,
                    width: Sizes.s80,
                    decoration: BoxDecoration(
                      color: shimmerColor,
                      borderRadius: BorderRadius.circular(Sizes.s4),
                    ),
                  ),
                ],
              ),
            ),
            // Badge skeleton
            Container(
              height: Sizes.s24,
              width: Sizes.s70,
              decoration: BoxDecoration(
                color: shimmerColor,
                borderRadius: BorderRadius.circular(Sizes.s20),
              ),
            ),
          ],
        ),

        DottedLine(dashColor: appColor(context).appTheme.stroke)
            .padding(vertical: Sizes.s12),

        // Vehicle row skeleton
        Row(
          children: [
            Container(
              height: Sizes.s16,
              width: Sizes.s16,
              color: shimmerColor,
            ),
            HSpace(Sizes.s8),
            Container(
              height: Sizes.s13,
              width: Sizes.s180,
              decoration: BoxDecoration(
                color: shimmerColor,
                borderRadius: BorderRadius.circular(Sizes.s4),
              ),
            ),
          ],
        ).padding(bottom: Sizes.s8),

        // Phone row skeleton
        Row(
          children: [
            Container(
              height: Sizes.s16,
              width: Sizes.s16,
              color: shimmerColor,
            ),
            HSpace(Sizes.s8),
            Container(
              height: Sizes.s13,
              width: Sizes.s120,
              decoration: BoxDecoration(
                color: shimmerColor,
                borderRadius: BorderRadius.circular(Sizes.s4),
              ),
            ),
          ],
        ).padding(bottom: Sizes.s8),

        // Trip info row skeleton
        Row(
          children: [
            Container(
              height: Sizes.s16,
              width: Sizes.s16,
              color: shimmerColor,
            ),
            HSpace(Sizes.s8),
            Container(
              height: Sizes.s13,
              width: Sizes.s150,
              decoration: BoxDecoration(
                color: shimmerColor,
                borderRadius: BorderRadius.circular(Sizes.s4),
              ),
            ),
          ],
        ),
      ],
    ).myRideListExtension(context).padding(bottom: Sizes.s12);
  }
}

class DriverListSkeleton extends StatelessWidget {
  final int itemCount;

  const DriverListSkeleton({super.key, this.itemCount = 4});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(top: Sizes.s20, bottom: Sizes.s20),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return const DriverCardSkeleton()
            .animate(onPlay: (controller) => controller.repeat())
            .shimmer(
              duration: const Duration(milliseconds: 1200),
              color: appColor(context).appTheme.white.withValues(alpha: 0.5),
            );
      },
    );
  }
}
