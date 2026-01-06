import '../../../../config.dart';

class AddTextFormField extends StatefulWidget {
  final int? index;
  final String? text;
  final Widget? suffix;
  final Widget? prefixIcon;

  const AddTextFormField(
      {super.key, this.index, this.text, this.suffix, this.prefixIcon});

  @override
  State<AddTextFormField> createState() => _AddTextFormFieldState();
}

class _AddTextFormFieldState extends State<AddTextFormField> {
  TextEditingController? _nameController;
  int index = 0;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    if (widget.text != null) {
      _nameController!.text = widget.text!;
    }
    index = widget.index!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var searchCtrl = Provider.of<SearchLocationProvider>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _nameController!.text = searchCtrl.textFieldList[widget.index!];
    });

    return TextField(
        onChanged: (value) => searchCtrl.textFieldList[widget.index!] = value,
        controller: _nameController,
        focusNode: focusNode,
        decoration: InputDecoration(
            hintStyle: AppCss.lexendLight14.textColor(appTheme.hintTextClr),
            prefixIcon: widget.prefixIcon,
            contentPadding: EdgeInsets.only(top: Sizes.s10),
            border: InputBorder.none,
            hintText: appFonts.enterDestination,
            suffixIcon: widget.suffix));
  }
}
