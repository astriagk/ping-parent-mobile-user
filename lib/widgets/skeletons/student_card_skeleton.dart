import '../../config.dart';
import 'package:flutter_animate/flutter_animate.dart';

class StudentCardSkeleton extends StatelessWidget {
  const StudentCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(children: [
        // Profile image skeleton
        Container(
            height: Sizes.s50,
            width: Sizes.s50,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: appColor(context).appTheme.bgBox)),
        HSpace(Sizes.s10),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            // Name skeleton
            Container(
                height: Sizes.s14,
                width: Sizes.s120,
                decoration: BoxDecoration(
                    color: appColor(context).appTheme.bgBox,
                    borderRadius: BorderRadius.circular(Sizes.s4))),
            // Status skeleton
            Container(
                height: Sizes.s12,
                width: Sizes.s50,
                decoration: BoxDecoration(
                    color: appColor(context).appTheme.bgBox,
                    borderRadius: BorderRadius.circular(Sizes.s4)))
          ]),
          VSpace(Sizes.s8),
          // School name skeleton
          Container(
              height: Sizes.s12,
              width: Sizes.s100,
              decoration: BoxDecoration(
                  color: appColor(context).appTheme.bgBox,
                  borderRadius: BorderRadius.circular(Sizes.s4)))
        ]))
      ]),
      DottedLine(dashColor: appColor(context).appTheme.stroke)
          .padding(vertical: Sizes.s12),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // ID and class skeleton
          Container(
              height: Sizes.s12,
              width: Sizes.s150,
              decoration: BoxDecoration(
                  color: appColor(context).appTheme.bgBox,
                  borderRadius: BorderRadius.circular(Sizes.s4))),
        ]),
        // Arrow button skeleton
        Container(
            height: Sizes.s32,
            width: Sizes.s32,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: appColor(context).appTheme.bgBox))
      ]),
      VSpace(Sizes.s12),
      // Address skeleton
      Container(
          height: Sizes.s40,
          decoration: BoxDecoration(
              color: appColor(context).appTheme.bgBox,
              borderRadius: BorderRadius.circular(Sizes.s8)))
    ]).myRideListExtension(context);
  }
}

class StudentListSkeleton extends StatelessWidget {
  final int itemCount;

  const StudentListSkeleton({super.key, this.itemCount = 3});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.only(top: Sizes.s20, bottom: Sizes.s20),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return const StudentCardSkeleton()
              .animate(onPlay: (controller) => controller.repeat())
              .shimmer(
                  duration: const Duration(milliseconds: 1200),
                  color:
                      appColor(context).appTheme.white.withValues(alpha: 0.5));
        });
  }
}
