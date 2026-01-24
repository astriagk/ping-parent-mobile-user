import '../../../../config.dart';

class DashAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int? index;
  final String? title;

  const DashAppBar({super.key, this.index, this.title});

  @override
  Widget build(BuildContext context) {
    return Consumer3<DateTimeProvider, ChatProvider, DashBoardProvider>(
        builder: (context, dateCtrl, chatCtrl, dashCtrl, child) {
      return dashCtrl.currentTab == 0
          ? CustomScrollView(slivers: <Widget>[
              SliverAppBar(
                  excludeHeaderSemantics: true,
                  pinned: true,
                  floating: true,
                  snap: true,
                  expandedHeight: Sizes.s140,
                  automaticallyImplyLeading: false,
                  shape: SmoothRectangleBorder(
                      borderRadius: SmoothBorderRadius(
                          cornerRadius: Sizes.s20, cornerSmoothing: 1)),
                  flexibleSpace: FlexibleSpaceBar(
                      expandedTitleScale: 1,
                      background: TextFieldCommon(
                              readOnly: true,
                              onTap: () => route.pushNamed(
                                  context, routeName.searchLocationScreen),
                              prefixIcon: SvgPicture.asset(svgAssets.search)
                                  .padding(
                                      vertical: Sizes.s12,
                                      left: Sizes.s12,
                                      right: Sizes.s8),
                              hintText: appFonts.searchDestinations,
                              contentPadding: EdgeInsets.zero,
                              suffixIcon: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                        width: Sizes.s1,
                                        color: appColor(context).appTheme.bgBox,
                                        height: Sizes.s24),
                                    Container(
                                            height: Sizes.s36,
                                            padding: EdgeInsets.all(Sizes.s8),
                                            width: Sizes.s36,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: appColor(context)
                                                    .appTheme
                                                    .bgBox),
                                            child: SvgPicture.asset(
                                                svgAssets.calendar))
                                        .inkWell(onTap: () {
                                      route.pushNamed(
                                          context, routeName.dateTimePicker);
                                    }).paddingOnly(
                                            top: Sizes.s5,
                                            bottom: Sizes.s5,
                                            right: Sizes.s5,
                                            left: Sizes.s10)
                                  ]),
                              borderRadius: SmoothBorderRadius(
                                  cornerRadius: Sizes.s23, cornerSmoothing: 1),
                              enabledBorder: SmoothBorderRadius(
                                  cornerRadius: Sizes.s23, cornerSmoothing: 1))
                          .padding(horizontal: Sizes.s20, top: Sizes.s95)),
                  backgroundColor: appColor(context).appTheme.bgBox,
                  leading: SvgPicture.asset(svgAssets.logo,
                          width: Sizes.s80, height: Sizes.s28)
                      .padding(horizontal: Sizes.s20),
                  leadingWidth: Sizes.s130,
                  actions: [
                    CommonIconButton(
                        icon: svgAssets.messages,
                        onTap: () {
                          chatCtrl.homeChat = true;
                          route.pushNamed(context, routeName.noInternetScreen);
                        }),
                    CommonIconButton(
                            icon: svgAssets.bell,
                            onTap: () => route.pushNamed(
                                context, routeName.emptyNotification,
                                arg: appFonts.notification))
                        .padding(horizontal: Sizes.s10),
                    CommonIconButton(icon: svgAssets.wallet).inkWell(
                        // onTap: () =>
                        // route.pushNamed(context, routeName.myWalletScreen)
                        onTap: () => route.pushNamed(
                            context, routeName.emptyNotification,
                            arg: "My Wallet")),
                    HSpace(Sizes.s20)
                  ]),
              SliverFillRemaining(child: dashCtrl.screens[dashCtrl.currentTab])
            ])
          : Stack(children: [
              dashCtrl.currentTab == 3
                  ? AnimatedOpacity(
                      duration: const Duration(milliseconds: 100),
                      opacity: dashCtrl.isImage ? 1 : 0,
                      child: Image.asset(imageAssets.rectangle,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.fill))
                  : Container(),
              AppBar(
                  backgroundColor: appColor(context).appTheme.bgBox,
                  leading: const SizedBox.shrink(),
                  flexibleSpace: Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextWidgetCommon(
                                text: dashCtrl.currentTab == 1
                                    ? "Categories"
                                    : dashCtrl.currentTab == 2
                                        ? appFonts.mySubscriptions
                                        : "Settings",
                                style: AppCss.lexendBold20.textColor(
                                    appColor(context).appTheme.darkText)),
                            Row(children: [
                              if (dashCtrl.currentTab != 3)
                                CommonIconButton(
                                    icon: svgAssets.messages,
                                    onTap: () {
                                      chatCtrl.homeChat = true;
                                      route.pushNamed(
                                          context, routeName.chatScreen);
                                    }),
                              HSpace(Sizes.s10),
                              dashCtrl.currentTab == 1 ||
                                      dashCtrl.currentTab == 2
                                  ? CommonIconButton(
                                      icon: svgAssets.bell,
                                      onTap: () => route.pushNamed(
                                          context, routeName.appSettingScreen))
                                  : SizedBox(height: Insets.i40)
                            ])
                          ])).padding(bottom: Sizes.s25, horizontal: Sizes.s20),
                  shape: SmoothRectangleBorder(
                      borderRadius: SmoothBorderRadius.only(
                          bottomRight: SmoothRadius(
                              cornerRadius: Sizes.s20, cornerSmoothing: 1),
                          bottomLeft: SmoothRadius(
                              cornerRadius: Sizes.s20, cornerSmoothing: 1))))
            ]);
    });
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(index == 0 ? 150 : 80);
}
