import 'package:skolo/config.dart';

enum SnackBarType { success, error, warning, info }

// Hardcoded fallbacks for use in providers (no BuildContext available).
const _kSuccess = Color(0xFF20B149);
const _kError = Color(0xFFFF4B4B);
const _kWarning = Color(0xFFFFB400);
const _kInfo = Color(0xFF622CFD);

class AppSnackBar {
  static SnackBar _build(
    String message,
    Color bg,
    IconData icon,
    Duration duration,
  ) {
    return SnackBar(
      backgroundColor: bg,
      behavior: SnackBarBehavior.floating,
      duration: duration,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(Sizes.s8)),
      content: Row(children: [
        Icon(icon, color: Colors.white, size: Sizes.s20),
        HSpace(Sizes.s8),
        Expanded(
          child: TextWidgetCommon(text: message, color: Colors.white),
        ),
      ]),
    );
  }

  static void show(
    BuildContext context,
    String message, {
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    final theme = appColor(context).appTheme;
    final Color bg;
    final IconData icon;

    switch (type) {
      case SnackBarType.success:
        bg = theme.success;
        icon = Icons.check_circle_outline;
        break;
      case SnackBarType.error:
        bg = theme.alertZone;
        icon = Icons.error_outline;
        break;
      case SnackBarType.warning:
        bg = theme.yellowIcon;
        icon = Icons.warning_amber_rounded;
        break;
      case SnackBarType.info:
        bg = theme.primary;
        icon = Icons.info_outline;
        break;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(_build(message, bg, icon, duration));
  }

  /// For use inside providers that hold a [ScaffoldMessengerState] via a
  /// global key (no BuildContext available).
  static void showOnMessenger(
    ScaffoldMessengerState messenger,
    String message, {
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    final Color bg;
    final IconData icon;

    switch (type) {
      case SnackBarType.success:
        bg = _kSuccess;
        icon = Icons.check_circle_outline;
        break;
      case SnackBarType.error:
        bg = _kError;
        icon = Icons.error_outline;
        break;
      case SnackBarType.warning:
        bg = _kWarning;
        icon = Icons.warning_amber_rounded;
        break;
      case SnackBarType.info:
        bg = _kInfo;
        icon = Icons.info_outline;
        break;
    }

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(_build(message, bg, icon, duration));
  }

  static void success(BuildContext context, String message,
          {Duration duration = const Duration(seconds: 3)}) =>
      show(context, message, type: SnackBarType.success, duration: duration);

  static void error(BuildContext context, String message,
          {Duration duration = const Duration(seconds: 3)}) =>
      show(context, message, type: SnackBarType.error, duration: duration);

  static void warning(BuildContext context, String message,
          {Duration duration = const Duration(seconds: 3)}) =>
      show(context, message, type: SnackBarType.warning, duration: duration);

  static void info(BuildContext context, String message,
          {Duration duration = const Duration(seconds: 3)}) =>
      show(context, message, type: SnackBarType.info, duration: duration);
}
