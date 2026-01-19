import '../../config.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SaveLocationCardSkeleton extends StatelessWidget {
  const SaveLocationCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // Header row (icon, title, phone number, edit button)
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(children: [
          // Icon skeleton
          Container(
              height: Sizes.s40,
              width: Sizes.s40,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: appColor(context).appTheme.stroke)),
          HSpace(Sizes.s10),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title skeleton (Home/Work)
                Container(
                    height: Sizes.s14,
                    width: Sizes.s60,
                    decoration: BoxDecoration(
                        color: appColor(context).appTheme.stroke,
                        borderRadius: BorderRadius.circular(Sizes.s4))),
                VSpace(Sizes.s6),
                // Phone number skeleton
                Container(
                    height: Sizes.s12,
                    width: Sizes.s100,
                    decoration: BoxDecoration(
                        color: appColor(context).appTheme.stroke,
                        borderRadius: BorderRadius.circular(Sizes.s4)))
              ])
        ]),
        // Edit button skeleton
        Container(
            height: Sizes.s24,
            width: Sizes.s24,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: appColor(context).appTheme.stroke))
      ]).padding(all: Sizes.s15),
      // Address row
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Location icon skeleton
        Container(
            height: Sizes.s15,
            width: Sizes.s15,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: appColor(context).appTheme.stroke)),
        HSpace(Sizes.s8),
        Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              // Address line 1 skeleton
              Container(
                  height: Sizes.s12,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: appColor(context).appTheme.stroke,
                      borderRadius: BorderRadius.circular(Sizes.s4))),
              VSpace(Sizes.s6),
              // Address line 2 skeleton
              Container(
                  height: Sizes.s12,
                  width: Sizes.s200,
                  decoration: BoxDecoration(
                      color: appColor(context).appTheme.stroke,
                      borderRadius: BorderRadius.circular(Sizes.s4)))
            ]))
      ]).padding(horizontal: Sizes.s15, vertical: Sizes.s12)
    ])
        .decorated(
            color: appColor(context).appTheme.bgBox, allRadius: Sizes.s10)
        .padding(bottom: Sizes.s20);
  }
}

class SaveLocationListSkeleton extends StatelessWidget {
  final int itemCount;

  const SaveLocationListSkeleton({super.key, this.itemCount = 2});

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(itemCount, (index) {
          return const SaveLocationCardSkeleton()
              .animate(onPlay: (controller) => controller.repeat())
              .shimmer(
                  duration: const Duration(milliseconds: 1200),
                  color:
                      appColor(context).appTheme.white.withValues(alpha: 0.5));
        })).padding(horizontal: Sizes.s20, top: Sizes.s25);
  }
}
