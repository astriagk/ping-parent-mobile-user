import 'package:taxify_user_ui/config.dart';

class ErrorMessageWidget extends StatelessWidget {
  final String errorMessage;
  final EdgeInsets margin;

  const ErrorMessageWidget({
    super.key,
    required this.errorMessage,
    this.margin = const EdgeInsets.only(bottom: 15),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Sizes.s12),
      margin: margin,
      decoration: BoxDecoration(
        color: appColor(context).appTheme.alertZone.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(Sizes.s8),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline,
              color: appColor(context).appTheme.alertZone),
          HSpace(Sizes.s10),
          Expanded(
            child: TextWidgetCommon(
                text: errorMessage,
                color: appColor(context).appTheme.alertZone),
          ),
        ],
      ),
    );
  }
}
