import '../../../config.dart';

class ProfileWidgets {
  //common title and text-field layout
  Widget commonTextField(context,
      {String? title,
      String? hintText,
      String? icon,
      String? initialValue,
      TextEditingController? controller,
      TextInputType? textInputType,
      bool readOnly = false,
      FocusNode? focusNode,
      VoidCallback? onFieldSubmitted}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      TextWidgetCommon(
        text: title,
        style: AppCss.lexendMedium14
            .textColor(appColor(context).appTheme.darkText),
      ),
      TextFieldCommon(
        controller: controller ??
            (initialValue != null
                ? TextEditingController(text: initialValue)
                : null),
        hintText: hintText,
        keyboardType: textInputType,
        readOnly: readOnly,
        focusNode: focusNode,
      ).padding(top: Sizes.s8, bottom: Sizes.s20)
    ]);
  }

  //profile image and edit button layout
  Widget profileImageLayout(BuildContext context, {String? photoUrl}) {
    return Stack(children: [
      photoUrl != null && photoUrl.isNotEmpty
          ? Image.network(
              photoUrl,
              height: Insets.i79,
              width: Insets.i79,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(imageAssets.profileImg,
                    height: Insets.i79, width: Insets.i79);
              },
            ).clipRRect(all: Insets.i39).center()
          : Image.asset(imageAssets.profileImg,
                  height: Insets.i79, width: Insets.i79)
              .center(),
      CommonIconButton(
          height: Insets.i30,
          bgColor: Colors.white,
          icon: svgAssets.profileEdit,
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)),
                      child: Container(
                          padding: EdgeInsets.all(16.0),
                          child:
                              Column(mainAxisSize: MainAxisSize.min, children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(language(context, "Add Profile Photo"),
                                      style: AppCss.lexendMedium16
                                          .textColor(appTheme.primary)),
                                  CommonIconButton(
                                      icon: svgAssets.close,
                                      onTap: () => route.pop(context))
                                ]),
                            SizedBox(height: Insets.i20),
                            ListTile(
                                contentPadding: EdgeInsets.all(0),
                                leading: CommonIconButton(
                                    bgColor: appTheme.stroke,
                                    iconWidth: 10,
                                    iconHeight: 10,
                                    icon: "assets/svg/setting/gallery.svg"),
                                title: Text(
                                    language(context, "Select From Gallery"),
                                    style: AppCss.lexendMedium14
                                        .textColor(appTheme.primary)),
                                onTap: () => route.pop(context)),
                            ListTile(
                                contentPadding: EdgeInsets.all(0),
                                leading: CommonIconButton(
                                    bgColor: appTheme.stroke,
                                    iconWidth: 10,
                                    iconHeight: 10,
                                    icon: "assets/svg/setting/camera.svg"),
                                title: Text(language(context, "Open Camera"),
                                    style: AppCss.lexendMedium14
                                        .textColor(appTheme.primary)),
                                onTap: () => route.pop(context))
                          ])));
                });
          }).center().padding(top: Insets.i53, left: Insets.i60)
    ]);
  }
}
