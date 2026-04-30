import 'package:flutter_animate/flutter_animate.dart';
import '../../config.dart';

class NotificationItemSkeleton extends StatelessWidget {
  const NotificationItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            height: Sizes.s12,
            width: Sizes.s140,
            decoration: BoxDecoration(
                color: appColor(context).appTheme.bgBox,
                borderRadius: BorderRadius.circular(Sizes.s4))),
        VSpace(Sizes.s8),
        Container(
            height: Sizes.s10,
            width: double.infinity,
            decoration: BoxDecoration(
                color: appColor(context).appTheme.bgBox,
                borderRadius: BorderRadius.circular(Sizes.s4))),
        VSpace(Sizes.s5),
        Container(
            height: Sizes.s10,
            width: Sizes.s100,
            decoration: BoxDecoration(
                color: appColor(context).appTheme.bgBox,
                borderRadius: BorderRadius.circular(Sizes.s4))),
      ])),
      HSpace(Sizes.s6),
      Container(
          height: Sizes.s32,
          width: Sizes.s32,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: appColor(context).appTheme.bgBox)),
    ])
        .padding(vertical: Sizes.s15, horizontal: Sizes.s15)
        .decorated(
            allRadius: Sizes.s10,
            color: appColor(context).appTheme.white,
            sideColor: appColor(context).appTheme.bgBox,
            boxShadow: [
              BoxShadow(
                  color: appColor(context)
                      .appTheme
                      .primary
                      .withValues(alpha: 0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                  spreadRadius: 0)
            ])
        .padding(bottom: Sizes.s15, horizontal: Sizes.s15);
  }
}

class NotificationListSkeleton extends StatelessWidget {
  final int itemCount;

  const NotificationListSkeleton({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return const NotificationItemSkeleton()
              .animate(onPlay: (controller) => controller.repeat())
              .shimmer(
                  duration: const Duration(milliseconds: 1200),
                  color:
                      appColor(context).appTheme.white.withValues(alpha: 0.5));
        });
  }
}
