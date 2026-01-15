import 'package:dropdown_search/dropdown_search.dart';

import '../config.dart';

class SearchableDropdown<T> extends StatelessWidget {
  final List<T> items;
  final T? selectedItem;
  final String? hintText;
  final String Function(T) itemAsString;
  final Widget Function(BuildContext, T, bool, bool)? itemBuilder;
  final ValueChanged<T?>? onChanged;
  final bool Function(T, String)? filterFn;
  final Color? bgColor;
  final BorderRadiusGeometry? borderRadius;

  const SearchableDropdown({
    super.key,
    required this.items,
    this.selectedItem,
    this.hintText,
    required this.itemAsString,
    this.itemBuilder,
    this.onChanged,
    this.filterFn,
    this.bgColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<T>(
      items: (filter, loadProps) => items,
      selectedItem: selectedItem,
      onChanged: onChanged,
      itemAsString: itemAsString,
      filterFn: filterFn,
      compareFn: (item1, item2) => itemAsString(item1) == itemAsString(item2),
      popupProps: PopupProps.menu(
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            hintText: language(context, 'Search...'),
            hintStyle: AppCss.lexendRegular13
                .textColor(appColor(context).appTheme.hintText),
            prefixIcon: Icon(Icons.search,
                color: appColor(context).appTheme.lightText),
            filled: true,
            fillColor: appColor(context).appTheme.screenBg,
            contentPadding:
                EdgeInsets.symmetric(horizontal: Sizes.s15, vertical: Sizes.s12),
            border: OutlineInputBorder(
              borderRadius:
                  SmoothBorderRadius(cornerRadius: Sizes.s8, cornerSmoothing: 2),
              borderSide:
                  BorderSide(width: 1, color: appColor(context).appTheme.stroke),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius:
                  SmoothBorderRadius(cornerRadius: Sizes.s8, cornerSmoothing: 2),
              borderSide:
                  BorderSide(width: 1, color: appColor(context).appTheme.stroke),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius:
                  SmoothBorderRadius(cornerRadius: Sizes.s8, cornerSmoothing: 2),
              borderSide:
                  BorderSide(width: 2, color: appColor(context).appTheme.primary),
            ),
          ),
        ),
        menuProps: MenuProps(
          backgroundColor: appColor(context).appTheme.white,
          borderRadius: BorderRadius.circular(Sizes.s8),
          elevation: 4,
        ),
        itemBuilder: itemBuilder,
        constraints: BoxConstraints(maxHeight: 300),
      ),
      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          hintText: language(context, hintText),
          hintStyle: AppCss.lexendRegular13
              .textColor(appColor(context).appTheme.hintText),
          filled: true,
          fillColor: bgColor ?? appColor(context).appTheme.screenBg,
          contentPadding:
              EdgeInsets.symmetric(horizontal: Sizes.s15, vertical: Sizes.s16),
          border: OutlineInputBorder(
            borderRadius: borderRadius as BorderRadius? ??
                SmoothBorderRadius(cornerRadius: Sizes.s8, cornerSmoothing: 2),
            borderSide:
                BorderSide(width: 1, color: appColor(context).appTheme.stroke),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: borderRadius as BorderRadius? ??
                SmoothBorderRadius(cornerRadius: Sizes.s8, cornerSmoothing: 2),
            borderSide:
                BorderSide(width: 1, color: appColor(context).appTheme.stroke),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: borderRadius as BorderRadius? ??
                SmoothBorderRadius(cornerRadius: Sizes.s8, cornerSmoothing: 2),
            borderSide:
                BorderSide(width: 2, color: appColor(context).appTheme.primary),
          ),
        ),
      ),
      suffixProps: DropdownSuffixProps(
        dropdownButtonProps: DropdownButtonProps(
          iconOpened: Icon(Icons.keyboard_arrow_up_outlined,
              color: appColor(context).appTheme.primary.withValues(alpha: 0.5)),
          iconClosed: Icon(Icons.keyboard_arrow_down_outlined,
              color: appColor(context).appTheme.primary.withValues(alpha: 0.5)),
        ),
      ),
    ).decorated(boxShadow: [
      BoxShadow(
          color: appColor(context).appTheme.primary.withValues(alpha: 0.04),
          blurRadius: 12,
          spreadRadius: 4)
    ]);
  }
}
