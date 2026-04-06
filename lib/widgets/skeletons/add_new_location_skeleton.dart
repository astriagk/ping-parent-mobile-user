import '../../config.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Skeleton shown while the map is loading GPS position in AddLocationScreen.
class AddLocationMapSkeleton extends StatelessWidget {
  const AddLocationMapSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final shimmer = appColor(context).appTheme.stroke;

    return Stack(
      children: [
        // ── Full-screen map placeholder ──
        Container(
          width: double.infinity,
          height: double.infinity,
          color: appColor(context).appTheme.bgBox,
        ),

        // ── Back button (top-left) ──
        Positioned(
          left: Insets.i20,
          top: Insets.i50,
          child: Container(
            height: Sizes.s40,
            width: Sizes.s40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: shimmer,
            ),
          ),
        ),

        // ── Bottom panel ──
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: appColor(context).appTheme.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Sizes.s20),
                topRight: Radius.circular(Sizes.s20),
              ),
            ),
            padding: EdgeInsets.all(Sizes.s20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Address row (pin icon + text lines)
                Container(
                  padding: EdgeInsets.all(Sizes.s15),
                  decoration: BoxDecoration(
                    color: appColor(context).appTheme.bgBox,
                    borderRadius: BorderRadius.circular(Sizes.s8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: Sizes.s20,
                        width: Sizes.s20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: shimmer,
                        ),
                      ),
                      SizedBox(width: Sizes.s10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: Sizes.s14,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: shimmer,
                                borderRadius: BorderRadius.circular(Sizes.s4),
                              ),
                            ),
                            SizedBox(height: Sizes.s8),
                            Container(
                              height: Sizes.s12,
                              width: Sizes.s180,
                              decoration: BoxDecoration(
                                color: shimmer,
                                borderRadius: BorderRadius.circular(Sizes.s4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: Sizes.s20),

                // Confirm button placeholder
                Container(
                  height: Sizes.s50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: shimmer,
                    borderRadius: BorderRadius.circular(Sizes.s10),
                  ),
                ),

                SizedBox(height: Sizes.s20),
              ],
            ),
          ),
        ),
      ],
    )
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(
          duration: const Duration(milliseconds: 1200),
          color: appColor(context).appTheme.white.withValues(alpha: 0.6),
        );
  }
}
