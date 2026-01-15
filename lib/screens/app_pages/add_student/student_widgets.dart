import '../../../config.dart';

class StudentWidgets {
  //common title and text-field layout
  Widget commonTextField(context,
      {String? title,
      String? hintText,
      TextEditingController? controller,
      TextInputType? textInputType,
      bool readOnly = false,
      int? minLines,
      int? maxLines}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      TextWidgetCommon(
        text: title,
        style: AppCss.lexendMedium14
            .textColor(appColor(context).appTheme.darkText),
      ),
      TextFieldCommon(
        controller: controller,
        hintText: hintText,
        keyboardType: textInputType,
        readOnly: readOnly,
        minLines: minLines,
        maxLines: maxLines,
      ).padding(top: Sizes.s8, bottom: Sizes.s20)
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
      CommonDropDownMenu(
        value: value,
        hintText: hintText,
        bgColor: appColor(context).appTheme.bgBox,
        itemsList: itemsList,
        onChanged: onChanged,
      ).padding(top: Sizes.s8, bottom: Sizes.s20)
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
