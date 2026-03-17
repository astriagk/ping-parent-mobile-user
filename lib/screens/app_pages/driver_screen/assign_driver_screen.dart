import '../../../api/models/driver_response.dart';
import '../../../config.dart';
import '../../../provider/app_pages_providers/driver_provider.dart';
import '../../../widgets/driver_card/driver_card.dart';
import '../../../widgets/skeletons/driver_card_skeleton.dart';
import '../../../../widgets/common_confirmation_dialog.dart';

class AssignDriverScreen extends StatefulWidget {
  final String? studentId;

  const AssignDriverScreen({super.key, this.studentId});

  @override
  State<AssignDriverScreen> createState() => _AssignDriverScreenState();
}

class _AssignDriverScreenState extends State<AssignDriverScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<DriverProvider>().fetchDrivers();
    });
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Driver> _getDisplayedDrivers(List<Driver> all) {
    // Only show approved drivers, sorted alphabetically
    final approved = all
        .where((d) => d.approvalStatus?.toLowerCase() == 'approved')
        .toList()
      ..sort((a, b) =>
          (a.name ?? '').toLowerCase().compareTo((b.name ?? '').toLowerCase()));

    if (_searchQuery.isEmpty) return approved;

    return approved.where((driver) {
      final name = (driver.name ?? '').toLowerCase();
      final driverId = (driver.driverUniqueId ?? '').toLowerCase();
      final phone = (driver.user?.phoneNumber ?? '').toLowerCase();
      return name.contains(_searchQuery) ||
          driverId.contains(_searchQuery) ||
          phone.contains(_searchQuery);
    }).toList();
  }

  Future<void> _selectDriver(Driver driver) async {
    if (widget.studentId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: TextWidgetCommon(text: appFonts.pleaseSelectStudentFirst)),
      );
      return;
    }

    if (driver.driverId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: TextWidgetCommon(text: appFonts.driverIdNotAvailable),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) {
        return CustomConfirmationDialog(
          message: appFonts.confirmAssignDriver,
          onCancel: () => route.pop(dialogContext),
          onConfirm: () async {
            route.pop(dialogContext);

            final driverCtrl = context.read<DriverProvider>();

            final success = await driverCtrl.assignDriverToStudent(
              studentId: widget.studentId!,
              driverId: driver.driverId!,
            );

            if (!mounted) return;

            if (success) {
              context.read<AddStudentProvider>().fetchStudents();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: TextWidgetCommon(
                    text: appFonts.driverAssignedSuccessfully,
                  ),
                ),
              );
              await Future.delayed(const Duration(milliseconds: 500));
              if (mounted) Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: TextWidgetCommon(
                    text: driverCtrl.errorMessage ??
                        appFonts.failedToAssignDriver,
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }

  void _clearSearch() {
    _searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColor(context).appTheme.screenBg,
      body: Consumer<DriverProvider>(
        builder: (context, driverCtrl, child) {
          final drivers = _getDisplayedDrivers(driverCtrl.driverList);

          return CustomScrollView(
            slivers: <Widget>[
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
                  background: StatefulBuilder(
                    builder: (context, setLocalState) {
                      return TextFieldCommon(
                        controller: _searchController,
                        prefixIcon: SvgPicture.asset(svgAssets.search).padding(
                            vertical: Sizes.s12,
                            left: Sizes.s12,
                            right: Sizes.s8),
                        hintText: appFonts.searchForDriverByNameIdOrEmail,
                        contentPadding: EdgeInsets.zero,
                        suffixIcon: _searchController.text.isNotEmpty
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: Sizes.s1,
                                    color: appColor(context).appTheme.bgBox,
                                    height: Sizes.s24,
                                  ),
                                  Container(
                                    height: Sizes.s36,
                                    padding: EdgeInsets.all(Sizes.s8),
                                    width: Sizes.s36,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: appColor(context).appTheme.bgBox,
                                    ),
                                    child: Icon(
                                      Icons.clear,
                                      color: appColor(context)
                                          .appTheme
                                          .lightText,
                                      size: Sizes.s20,
                                    ),
                                  ).inkWell(onTap: _clearSearch).paddingOnly(
                                        top: Sizes.s5,
                                        bottom: Sizes.s5,
                                        right: Sizes.s5,
                                        left: Sizes.s10,
                                      ),
                                ],
                              )
                            : null,
                        borderRadius: SmoothBorderRadius(
                            cornerRadius: Sizes.s23, cornerSmoothing: 1),
                        enabledBorder: SmoothBorderRadius(
                            cornerRadius: Sizes.s23, cornerSmoothing: 1),
                      ).padding(horizontal: Sizes.s20, top: Sizes.s95);
                    },
                  ),
                ),
                backgroundColor: appColor(context).appTheme.bgBox,
                leading: Padding(
                  padding: EdgeInsets.only(left: Sizes.s10),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios,
                        color: appColor(context).appTheme.darkText),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                leadingWidth: Sizes.s60,
                title: TextWidgetCommon(
                  text: language(context, appFonts.assignDriver),
                  style: AppCss.lexendBold18
                      .textColor(appColor(context).appTheme.darkText),
                ),
                centerTitle: true,
              ),
              SliverFillRemaining(
                child: driverCtrl.isLoading
                    ? const DriverListSkeleton()
                    : drivers.isEmpty
                        ? _buildEmptyState(context)
                        : ListView.builder(
                            padding: EdgeInsets.only(
                                top: Sizes.s20, bottom: Sizes.s20),
                            itemCount: drivers.length,
                            itemBuilder: (context, index) {
                              return DriverCard(
                                driver: drivers[index],
                                onTap: () => _selectDriver(drivers[index]),
                              );
                            },
                          ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.person_search_outlined,
            size: Sizes.s56,
            color: appColor(context).appTheme.lightText,
          ),
          VSpace(Sizes.s12),
          TextWidgetCommon(
            text: _searchQuery.isEmpty
                ? language(context, appFonts.noDriverAssigned)
                : language(context, appFonts.searchForDriverByNameIdOrEmail),
            style: AppCss.lexendRegular14
                .textColor(appColor(context).appTheme.lightText),
            textAlign: TextAlign.center,
          ),
        ],
      ).padding(horizontal: Sizes.s40),
    );
  }
}
