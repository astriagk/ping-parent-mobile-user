import 'package:skolo/config.dart';
import 'package:skolo/screens/app_pages/student_screen/student_widgets.dart';
import 'error/error_message_widget.dart';

class RedeemCodeDialog extends StatefulWidget {
  final Future<bool> Function(String code) onRedeem;

  const RedeemCodeDialog({
    super.key,
    required this.onRedeem,
  });

  @override
  State<RedeemCodeDialog> createState() => _RedeemCodeDialogState();
}

class _RedeemCodeDialogState extends State<RedeemCodeDialog> {
  final TextEditingController _codeController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _handleRedeem() async {
    if (_codeController.text.trim().isEmpty) {
      setState(() => _errorMessage = appFonts.pleaseEnterCode);
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final success = await widget.onRedeem(_codeController.text.trim());
      if (mounted) {
        if (success) {
          Navigator.of(context).pop(true);
        } else {
          // Error message will be set by provider
          setState(() => _isLoading = false);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'An error occurred. Please try again.';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.s16),
      ),
      child: Container(
        padding: EdgeInsets.all(Sizes.s20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Sizes.s16),
          color: appColor(context).appTheme.white,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidgetCommon(
                    text: appFonts.redeemCode,
                    style: AppCss.lexendSemiBold16
                        .textColor(appColor(context).appTheme.darkText),
                  ),
                  CommonIconButton(
                    icon: svgAssets.close,
                    onTap: () => Navigator.of(context).pop(false),
                  ),
                ],
              ),
              VSpace(Sizes.s16),

              // Input Field
              StudentWidgets()
                  .commonTextField(
                    context,
                    title: appFonts.code,
                    hintText: appFonts.enterCode,
                    controller: _codeController,
                    textInputType: TextInputType.text,
                    readOnly: _isLoading,
                  )
                  .paddingSymmetric(horizontal: 0, vertical: 0),

              // Error Message
              if (_errorMessage != null)
                ErrorMessageWidget(
                  errorMessage: _errorMessage!,
                  margin: EdgeInsets.only(bottom: Sizes.s16),
                ),

              if (_errorMessage == null) VSpace(Sizes.s4),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: CommonButton(
                      bgColor: appColor(context)
                          .appTheme
                          .primary
                          .withValues(alpha: 0.1),
                      onTap: _isLoading
                          ? null
                          : () => Navigator.of(context).pop(false),
                      style: AppCss.lexendMedium14
                          .textColor(appColor(context).appTheme.primary),
                      text: appFonts.cancel,
                    ),
                  ),
                  HSpace(Sizes.s12),
                  Expanded(
                    child: CommonButton(
                      onTap: _isLoading ? null : _handleRedeem,
                      style: AppCss.lexendMedium14
                          .textColor(appColor(context).appTheme.white),
                      text: _isLoading ? appFonts.redeeming : appFonts.redeem,
                      isLoading: _isLoading,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
