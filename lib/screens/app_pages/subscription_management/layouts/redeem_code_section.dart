import 'package:skolo/config.dart';
import 'package:skolo/screens/app_pages/student_screen/student_widgets.dart';

class RedeemCodeSection extends StatefulWidget {
  final Future<bool> Function(String code) onRedeem;
  final String? providerError;

  const RedeemCodeSection({
    super.key,
    required this.onRedeem,
    this.providerError,
  });

  @override
  State<RedeemCodeSection> createState() => _RedeemCodeSectionState();
}

class _RedeemCodeSectionState extends State<RedeemCodeSection> {
  bool _isExpanded = false;
  bool _isLoading = false;
  String? _error;
  bool _success = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleRedeem() async {
    if (_controller.text.trim().isEmpty) {
      setState(() => _error = appFonts.pleaseEnterCode);
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final success = await widget.onRedeem(_controller.text.trim());

    if (mounted) {
      if (success) {
        setState(() {
          _success = true;
          _isLoading = false;
        });
        await Future.delayed(const Duration(milliseconds: 1400));
        if (mounted) {
          setState(() {
            _isExpanded = false;
            _success = false;
            _controller.clear();
          });
        }
      } else {
        setState(() {
          _isLoading = false;
          _error = widget.providerError ??
              'Invalid or expired code. Please try again.';
        });
      }
    }
  }

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (!_isExpanded) {
        _error = null;
        _success = false;
        _controller.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: Sizes.s16),
      decoration: BoxDecoration(
        color: appColor(context).appTheme.white,
        borderRadius: BorderRadius.circular(Sizes.s12),
        border: Border.all(
          color: _isExpanded
              ? appColor(context).appTheme.primary.withValues(alpha: 0.35)
              : appColor(context).appTheme.stroke,
          width: _isExpanded ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: appColor(context).appTheme.primary.withValues(alpha: 0.04),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Sizes.s12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Header — always visible ──
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _toggle,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Sizes.s16, vertical: Sizes.s14),
                  child: Row(
                    children: [
                      Container(
                        width: Sizes.s34,
                        height: Sizes.s34,
                        decoration: BoxDecoration(
                          color: appColor(context)
                              .appTheme
                              .primary
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(Sizes.s8),
                        ),
                        child: Icon(
                          Icons.confirmation_number_outlined,
                          size: Sizes.s18,
                          color: appColor(context).appTheme.primary,
                        ),
                      ),
                      HSpace(Sizes.s12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidgetCommon(
                              text: appFonts.redeemCode,
                              style: AppCss.lexendMedium14.textColor(
                                  appColor(context).appTheme.darkText),
                            ),
                            TextWidgetCommon(
                              text: 'Have a promo or gift code?',
                              fontSize: Sizes.s12,
                              color: appColor(context).appTheme.lightText,
                            ),
                          ],
                        ),
                      ),
                      AnimatedRotation(
                        turns: _isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 260),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: appColor(context).appTheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Expandable body ──
            AnimatedCrossFade(
              firstChild: const SizedBox(width: double.infinity),
              secondChild: _buildBody(context),
              crossFadeState: _isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 260),
              sizeCurve: Curves.easeInOut,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(Sizes.s16, 0, Sizes.s16, Sizes.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(color: appColor(context).appTheme.stroke, height: 1),
          VSpace(Sizes.s14),
          if (_success)
            // ── Success banner ──
            Container(
              margin: EdgeInsets.only(top: Sizes.s10),
              padding: EdgeInsets.symmetric(
                  horizontal: Sizes.s16, vertical: Sizes.s12),
              decoration: BoxDecoration(
                color:
                    appColor(context).appTheme.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Sizes.s8),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle_rounded,
                      color: appColor(context).appTheme.success,
                      size: Sizes.s20),
                  HSpace(Sizes.s10),
                  TextWidgetCommon(
                    text: 'Code applied successfully!',
                    fontSize: Sizes.s13,
                    fontWeight: FontWeight.w500,
                    color: appColor(context).appTheme.success,
                  ),
                ],
              ),
            )
          else ...[
            // ── Code input ──
            StudentWidgets()
                .commonTextField(
                  context,
                  title: appFonts.code,
                  hintText: appFonts.enterCode,
                  controller: _controller,
                  textInputType: TextInputType.text,
                  readOnly: _isLoading,
                )
                .paddingSymmetric(horizontal: 0, vertical: 0),

            // ── Error message ──
            if (_error != null)
              ErrorMessageWidget(
                errorMessage: _error!,
                margin: EdgeInsets.only(bottom: Sizes.s12),
              )
            else
              VSpace(Sizes.s12),

            // ── Buttons ──
            Row(
              children: [
                Expanded(
                  child: CommonButton(
                    bgColor: appColor(context)
                        .appTheme
                        .primary
                        .withValues(alpha: 0.1),
                    onTap: _isLoading ? null : _toggle,
                    style: AppCss.lexendMedium14
                        .textColor(appColor(context).appTheme.primary),
                    text: appFonts.cancel,
                  ),
                ),
                HSpace(Sizes.s12),
                Expanded(
                  child: CommonButton(
                    onTap: _isLoading ? null : _handleRedeem,
                    isLoading: _isLoading,
                    style: AppCss.lexendMedium14
                        .textColor(appColor(context).appTheme.white),
                    text: _isLoading ? appFonts.redeeming : appFonts.redeem,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
