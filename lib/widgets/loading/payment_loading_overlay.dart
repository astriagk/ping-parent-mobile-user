import 'package:taxify_user_ui/config.dart';
import 'loading_wave_animation.dart';

class PaymentLoadingOverlay extends StatelessWidget {
  final String message;

  const PaymentLoadingOverlay({
    super.key,
    this.message = 'Processing payment...',
  });

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context).appTheme;

    return Container(
      color: theme.darkText.withValues(alpha: 0.6),
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: Sizes.s32),
          padding: EdgeInsets.symmetric(
            horizontal: Sizes.s40,
            vertical: Sizes.s36,
          ),
          decoration: BoxDecoration(
            color: theme.white,
            borderRadius: BorderRadius.circular(Sizes.s16),
            boxShadow: [
              BoxShadow(
                color: theme.darkText.withValues(alpha: 0.1),
                blurRadius: Sizes.s20,
                offset: Offset(0, Sizes.s4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: Sizes.s40,
                child: LoadingWaveAnimation(
                  color: theme.primary,
                  barCount: 5,
                  barWidth: Sizes.s6,
                  maxHeight: Sizes.s40,
                  minHeight: Sizes.s10,
                  spacing: Sizes.s5,
                ),
              ),
              SizedBox(height: Sizes.s24),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: FontSizes.f15,
                  fontWeight: FontWeight.w500,
                  color: theme.darkText,
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
