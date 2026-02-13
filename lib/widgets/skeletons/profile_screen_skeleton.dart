import 'package:flutter_animate/flutter_animate.dart';
import 'package:taxify_user_ui/config.dart';

class ProfileScreenSkeleton extends StatelessWidget {
  const ProfileScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: appColor(context).appTheme.white,
      appBar: AppBar(
        backgroundColor: appColor(context).appTheme.white,
        elevation: 0,
        title: Container(
          height: Sizes.s16,
          width: Sizes.s120,
          decoration: BoxDecoration(
            color: appColor(context).appTheme.bgBox,
            borderRadius: BorderRadius.circular(Sizes.s4),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile image skeleton
              Center(
                child: Container(
                  height: Sizes.s79,
                  width: Sizes.s79,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: appColor(context).appTheme.bgBox,
                  ),
                ),
              ),
              VSpace(Sizes.s25),
              Divider(
                color: appColor(context).appTheme.stroke,
                height: 0,
              ).padding(bottom: Sizes.s20),
              // Name field skeleton
              _buildTextFieldSkeleton(context),
              // Phone field skeleton
              _buildTextFieldSkeleton(context),
              // Email field skeleton
              _buildTextFieldSkeleton(context),
            ],
          ).padding(horizontal: Sizes.s20),
          // Button skeleton
          _buildButtonSkeleton(context).padding(
            horizontal: Sizes.s20,
            bottom: Sizes.s20,
          ),
        ],
      ),
    ).animate(onPlay: (controller) => controller.repeat()).shimmer(
          duration: const Duration(milliseconds: 1200),
          color: appColor(context).appTheme.white.withValues(alpha: 0.5),
        );
  }

  Widget _buildTextFieldSkeleton(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: Sizes.s14,
          width: Sizes.s80,
          decoration: BoxDecoration(
            color: appColor(context).appTheme.bgBox,
            borderRadius: BorderRadius.circular(Sizes.s4),
          ),
        ),
        VSpace(Sizes.s8),
        Container(
          height: Sizes.s46,
          width: double.infinity,
          decoration: BoxDecoration(
            color: appColor(context).appTheme.bgBox,
            borderRadius: BorderRadius.circular(Sizes.s9),
          ),
        ),
        VSpace(Sizes.s20),
      ],
    );
  }

  Widget _buildButtonSkeleton(BuildContext context) {
    return Container(
      height: Sizes.s46,
      width: double.infinity,
      decoration: BoxDecoration(
        color: appColor(context).appTheme.bgBox,
        borderRadius: BorderRadius.circular(Sizes.s9),
      ),
    );
  }
}
