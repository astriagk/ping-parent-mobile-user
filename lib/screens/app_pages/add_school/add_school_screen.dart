import '../../../config.dart';
import '../../../widgets/common_app_bar_layout1.dart';

class AddSchoolScreen extends StatelessWidget {
  const AddSchoolScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBarLayout1(
          title: language(context, appFonts.addSchool),
          titleWidth: MediaQuery.of(context).size.width * 0.01),
      body: Center(
        child: TextWidgetCommon(
          text: appFonts.addSchool,
          style: AppCss.lexendMedium18
              .textColor(appColor(context).appTheme.darkText),
        ),
      ),
    );
  }
}
