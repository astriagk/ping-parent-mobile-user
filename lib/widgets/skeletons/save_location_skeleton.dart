import '../../config.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SaveLocationCardSkeleton extends StatelessWidget {
  const SaveLocationCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final shimmer = appColor(context).appTheme.stroke;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header: rounded-square icon + title/subtitle + change pill ──
        Padding(
          padding: EdgeInsets.all(Sizes.s15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                // Rounded-square icon
                Container(
                  height: Sizes.s40,
                  width: Sizes.s40,
                  decoration: BoxDecoration(
                    color: shimmer,
                    borderRadius: BorderRadius.circular(Sizes.s10),
                  ),
                ),
                SizedBox(width: Sizes.s12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Title (e.g. "Home")
                    Container(
                      height: Sizes.s14,
                      width: Sizes.s60,
                      decoration: BoxDecoration(
                        color: shimmer,
                        borderRadius: BorderRadius.circular(Sizes.s4),
                      ),
                    ),
                    SizedBox(height: Sizes.s6),
                    // Subtitle ("Primary address")
                    Container(
                      height: Sizes.s12,
                      width: Sizes.s100,
                      decoration: BoxDecoration(
                        color: shimmer,
                        borderRadius: BorderRadius.circular(Sizes.s4),
                      ),
                    ),
                  ],
                ),
              ]),
              // Change pill button
              Container(
                height: Sizes.s28,
                width: Sizes.s75,
                decoration: BoxDecoration(
                  color: shimmer,
                  borderRadius: BorderRadius.circular(Sizes.s20),
                ),
              ),
            ],
          ),
        ),

        // ── Divider ──
        Divider(
          color: appColor(context).appTheme.stroke,
          height: 1,
          thickness: 1,
        ),

        // ── Address section ──
        Padding(
          padding: EdgeInsets.all(Sizes.s15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Location pin circle icon
              Container(
                height: Sizes.s30,
                width: Sizes.s30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: shimmer,
                ),
              ),
              SizedBox(width: Sizes.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Address line 1
                    Container(
                      height: Sizes.s13,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: shimmer,
                        borderRadius: BorderRadius.circular(Sizes.s4),
                      ),
                    ),
                    SizedBox(height: Sizes.s5),
                    // Address line 2
                    Container(
                      height: Sizes.s12,
                      width: Sizes.s150,
                      decoration: BoxDecoration(
                        color: shimmer,
                        borderRadius: BorderRadius.circular(Sizes.s4),
                      ),
                    ),
                    SizedBox(height: Sizes.s5),
                    // City + pincode row
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: Sizes.s12,
                            decoration: BoxDecoration(
                              color: shimmer,
                              borderRadius: BorderRadius.circular(Sizes.s4),
                            ),
                          ),
                        ),
                        SizedBox(width: Sizes.s8),
                        Container(
                          height: Sizes.s20,
                          width: Sizes.s50,
                          decoration: BoxDecoration(
                            color: shimmer,
                            borderRadius: BorderRadius.circular(Sizes.s4),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    )
        .decorated(
          color: appColor(context).appTheme.white,
          sideColor: appColor(context).appTheme.bgBox,
          allRadius: Sizes.s10,
          boxShadow: [
            BoxShadow(
              color: appColor(context)
                  .appTheme
                  .primary
                  .withValues(alpha: 0.03),
              blurRadius: 12,
              spreadRadius: 4,
            ),
          ],
        )
        .padding(horizontal: Sizes.s20, bottom: Sizes.s15);
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
              color: appColor(context).appTheme.white.withValues(alpha: 0.5),
            );
      }),
    ).padding(top: Sizes.s20);
  }
}
