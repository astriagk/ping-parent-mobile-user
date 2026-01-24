import '../../../config.dart';

class StudentWidgets {
  //common title and text-field layout
  Widget commonTextField(context,
      {String? title,
      String? hintText,
      TextEditingController? controller,
      TextInputType? textInputType,
      bool readOnly = false,
      FocusNode? focusNode,
      int? minLines,
      int? maxLines}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      TextWidgetCommon(
        text: title,
        style: AppCss.lexendMedium14
            .textColor(appColor(context).appTheme.darkText),
      ),
      VSpace(Sizes.s8),
      TextFormField(
        controller: controller,
        keyboardType: textInputType,
        readOnly: readOnly,
        focusNode: focusNode,
        minLines: minLines ?? 1,
        maxLines: maxLines ?? 1,
        style: AppCss.lexendRegular14,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          contentPadding:
              EdgeInsets.symmetric(horizontal: Sizes.s15, vertical: Sizes.s16),
          fillColor: appColor(context).appTheme.screenBg,
          hintText: language(context, hintText),
          hintStyle: AppCss.lexendRegular13
              .textColor(appColor(context).appTheme.hintText),
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
          border: OutlineInputBorder(
            borderRadius:
                SmoothBorderRadius(cornerRadius: Sizes.s8, cornerSmoothing: 2),
            borderSide:
                BorderSide(width: 1, color: appColor(context).appTheme.stroke),
          ),
        ),
      ).decorated(boxShadow: [
        BoxShadow(
            color: appColor(context).appTheme.primary.withValues(alpha: 0.04),
            blurRadius: 12,
            spreadRadius: 4)
      ]),
      VSpace(Sizes.s16),
    ]);
  }

  //common dropdown layout with title
  Widget commonDropdown(context,
      {String? title,
      String? hintText,
      dynamic value,
      required List<DropdownMenuItem<dynamic>> itemsList,
      required ValueChanged onChanged}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      TextWidgetCommon(
        text: title,
        style: AppCss.lexendMedium14
            .textColor(appColor(context).appTheme.darkText),
      ),
      VSpace(Sizes.s8),
      DropdownButtonFormField(
        dropdownColor: appColor(context).appTheme.white,
        isExpanded: true,
        icon: Icon(Icons.keyboard_arrow_down_outlined,
            color: appColor(context).appTheme.primary.withValues(alpha: 0.5)),
        value: value,
        items: itemsList,
        onChanged: onChanged,
        hint: TextWidgetCommon(
            text: language(context, hintText),
            style: AppCss.lexendRegular13
                .textColor(appColor(context).appTheme.hintText)),
        decoration: InputDecoration(
          filled: true,
          fillColor: appColor(context).appTheme.screenBg,
          contentPadding:
              EdgeInsets.symmetric(horizontal: Sizes.s15, vertical: Sizes.s16),
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
      ).decorated(boxShadow: [
        BoxShadow(
            color: appColor(context).appTheme.primary.withValues(alpha: 0.04),
            blurRadius: 12,
            spreadRadius: 4)
      ]),
      VSpace(Sizes.s16),
    ]);
  }

  //student photo upload layout
  Widget studentPhotoLayout(context,
      {String? photoUrl, required VoidCallback onTap}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Stack(children: [
        photoUrl != null && photoUrl.isNotEmpty
            ? Image.network(
                photoUrl,
                height: Insets.i79,
                width: Insets.i79,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _defaultPhotoWidget(context);
                },
              ).clipRRect(all: Insets.i39).center()
            : _defaultPhotoWidget(context).center(),
        CommonIconButton(
                height: Insets.i30,
                bgColor: Colors.white,
                icon: svgAssets.profileEdit,
                onTap: onTap)
            .center()
            .padding(top: Insets.i53, left: Insets.i60)
      ]),
    ]).padding(bottom: Sizes.s20);
  }

  //default photo widget
  Widget _defaultPhotoWidget(context) {
    return Container(
      height: Insets.i79,
      width: Insets.i79,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: appColor(context).appTheme.bgBox,
        border: Border.all(
          color: appColor(context).appTheme.stroke,
          width: 2,
        ),
      ),
      child: Icon(
        Icons.person,
        size: Insets.i40,
        color: appColor(context).appTheme.lightText,
      ),
    );
  }

  //photo selection dialog
  void showPhotoSelectionDialog(context,
      {required VoidCallback onGalleryTap, required VoidCallback onCameraTap}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(appFonts.selectPhoto,
                          style: AppCss.lexendMedium16
                              .textColor(appColor(context).appTheme.primary)),
                      CommonIconButton(
                          icon: svgAssets.close,
                          onTap: () => route.pop(context))
                    ]),
                SizedBox(height: Insets.i20),
                ListTile(
                    contentPadding: EdgeInsets.all(0),
                    leading: CommonIconButton(
                        bgColor: appColor(context).appTheme.stroke,
                        iconWidth: 10,
                        iconHeight: 10,
                        icon: "assets/svg/setting/gallery.svg"),
                    title: Text(appFonts.selectFromGallery,
                        style: AppCss.lexendMedium14
                            .textColor(appColor(context).appTheme.primary)),
                    onTap: () {
                      route.pop(context);
                      onGalleryTap();
                    }),
                ListTile(
                    contentPadding: EdgeInsets.all(0),
                    leading: CommonIconButton(
                        bgColor: appColor(context).appTheme.stroke,
                        iconWidth: 10,
                        iconHeight: 10,
                        icon: "assets/svg/setting/camera.svg"),
                    title: Text(appFonts.openCamera,
                        style: AppCss.lexendMedium14
                            .textColor(appColor(context).appTheme.primary)),
                    onTap: () {
                      route.pop(context);
                      onCameraTap();
                    })
              ],
            ),
          ),
        );
      },
    );
  }
}
