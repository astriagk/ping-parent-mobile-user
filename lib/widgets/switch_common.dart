import 'package:taxify_user_ui/config.dart';

class SwitchCommon extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onToggle;

  const SwitchCommon({super.key, required this.value, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => onToggle(!value),
        child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 32.0,
            height: 20.0,
            decoration: BoxDecoration(
                border: Border.all(
                    color: value ? appTheme.primary : appTheme.stroke),
                borderRadius: BorderRadius.circular(20.0),
                color: value ? appTheme.primary : appTheme.white),
            child: AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                curve: Curves.easeInOut,
                child: Container(
                    width: 12.0,
                    height: 12.0,
                    margin: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            value ? appTheme.white : appTheme.hintTextClr)))));
  }
}
