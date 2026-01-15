import '../../../config.dart';
import '../../../widgets/common_app_bar_layout1.dart';

class AssignDriverScreen extends StatelessWidget {
  const AssignDriverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColor(context).appTheme.white,
      appBar: CommonAppBarLayout1(
          title: language(context, appFonts.assignDriver),
          titleWidth: MediaQuery.of(context).size.width * 0.01),
      body: Center(
        child: TextWidgetCommon(
          text: appFonts.assignDriver,
          style: AppCss.lexendMedium18
              .textColor(appColor(context).appTheme.darkText),
        ),
      ),
    );
  }
}
