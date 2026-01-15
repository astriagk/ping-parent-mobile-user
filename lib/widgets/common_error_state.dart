import '../config.dart';

class CommonErrorState extends StatelessWidget {
  final String? image;
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onButtonTap;

  const CommonErrorState({
    super.key,
    this.image,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Image.asset(image ?? imageAssets.noInternet)
          .marginSymmetric(horizontal: Insets.i60),
      VSpace(Insets.i67),
      Text(title,
          style: AppCss.lexendLight14.textColor(appTheme.primary)),
      VSpace(Insets.i13),
      Text(description,
          style: AppCss.lexendLight14
              .textColor(appTheme.hintTextClr)
              .textHeight(1.3),
          textAlign: TextAlign.center),
      VSpace(Insets.i60),
      CommonButton(text: buttonText, onTap: onButtonTap),
    ]).padding(horizontal: Insets.i30);
  }
}
