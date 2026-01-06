import '../../../../../config.dart';

class HomeScreenWidget {
  dottedLineCommon({double vertical = 0, dashColor}) {
    return DottedLine(
            dashLength: 4.0,
            dashColor: dashColor ?? appTheme.borderColor,
            lineThickness: 1.0,
            dashGapLength: 4.0)
        .marginSymmetric(vertical: vertical);
  }
}
