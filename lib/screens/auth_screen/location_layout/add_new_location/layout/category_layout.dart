import '../../../../../config.dart';

class CategoryLayout extends StatelessWidget {
  const CategoryLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NewLocationProvider>(builder: (context, newCtrl, child) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        TextWidgetCommon(
                text: appFonts.selectCategory, style: AppCss.lexendMedium14)
            .padding(top: Sizes.s25, bottom: Sizes.s8),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: newCtrl.selectCategory
                .asMap()
                .entries
                .map((e) => CustomRadioButton(
                        value: e.value,
                        groupValue: newCtrl.selectedOption,
                        onChanged: (value) {
                          newCtrl.radioValueChange(value, context);
                        },
                        label: e.value['title'],
                        e: e)
                    .paddingSymmetric(vertical: 8, horizontal: 12)
                    .width(Sizes.s95)
                    .selectCategoryExtension(e, context)
                    .inkWell(
                        onTap: () =>
                            newCtrl.radioValueChange(e.value, context)))
                .toList())
      ]).padding(horizontal: Sizes.s20, bottom: Sizes.s25);
    });
  }
}

class CustomRadioButton extends StatelessWidget {
  final dynamic value;
  final dynamic groupValue;
  final ValueChanged<dynamic> onChanged;
  final String label;

  final MapEntry<int, dynamic> e;

  const CustomRadioButton(
      {super.key,
      required this.value,
      required this.groupValue,
      required this.onChanged,
      required this.label,
      required this.e});

  @override
  Widget build(BuildContext context) {
    bool isSelected = value == groupValue;

    return Consumer<SettingProvider>(builder: (context, settingCtrl, child) {
      return GestureDetector(
          onTap: () => onChanged(value),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            isSelected
                ? Container(
                    width: Sizes.s20,
                    height: Sizes.s20,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: appColor(context)
                            .appTheme
                            .primary
                            .withValues(alpha: 0.12)),
                    child: Icon(Icons.circle,
                        color: appColor(context).appTheme.primary,
                        size: Sizes.s13))
                : Container(
                    width: Sizes.s20,
                    height: Sizes.s20,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: appColor(context).appTheme.stroke))),
            SizedBox(width: 8),
            TextWidgetCommon(
                text: label,
                style: AppCss.lexendRegular14.textColor(
                    e.key == settingCtrl.selectIndex
                        ? appColor(context).appTheme.primary
                        : appColor(context).appTheme.hintText))
          ]));
    });
  }
}
