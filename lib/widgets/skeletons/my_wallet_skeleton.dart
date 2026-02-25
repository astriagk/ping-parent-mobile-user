import 'package:flutter_animate/flutter_animate.dart';
import 'package:taxify_user_ui/config.dart';

class MyWalletSkeleton extends StatelessWidget {
  const MyWalletSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        // list skeleton
        Expanded(
          child: ListView.separated(
            itemCount: 6,
            separatorBuilder: (_, __) => VSpace(Insets.i6),
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.all(Insets.i12),
                decoration: BoxDecoration(
                  color: appColor(context).appTheme.white,
                  borderRadius: BorderRadius.circular(AppRadius.r6),
                  boxShadow: [
                    BoxShadow(
                        color: appColor(context).appTheme.stroke,
                        blurRadius: 4,
                        offset: Offset(0, 1)),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      Container(
                        height: Insets.i36,
                        width: Insets.i36,
                        decoration: BoxDecoration(
                          color: appColor(context).appTheme.bgBox,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      HSpace(Insets.i10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: Insets.i12,
                            width: Sizes.s100,
                            decoration: BoxDecoration(
                              color: appColor(context).appTheme.bgBox,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          VSpace(Insets.i6),
                          Container(
                            height: Insets.i12,
                            width: Sizes.s60,
                            decoration: BoxDecoration(
                              color: appColor(context).appTheme.bgBox,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      )
                    ]),
                    Container(
                      height: Insets.i16,
                      width: Insets.i60,
                      decoration: BoxDecoration(
                        color: appColor(context).appTheme.bgBox,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        )
      ],
    ).animate(onPlay: (c) => c.repeat()).shimmer(
          duration: const Duration(milliseconds: 1200),
          color: appColor(context).appTheme.white.withValues(alpha: 0.5),
        );
  }
}
