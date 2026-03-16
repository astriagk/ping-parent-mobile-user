import '../../../api/models/driver_response.dart';
import '../../../config.dart';
import '../../../provider/app_pages_providers/driver_provider.dart';
import '../../../widgets/auto_refresh_mixin.dart';
import '../../../widgets/skeletons/driver_card_skeleton.dart';
import '../../../../widgets/common_confirmation_dialog.dart';
import 'driver_card.dart';

class AssignDriverScreen extends StatefulWidget {
  final String? studentId;

  const AssignDriverScreen({super.key, this.studentId});

  @override
  State<AssignDriverScreen> createState() => _AssignDriverScreenState();
}

class _AssignDriverScreenState extends State<AssignDriverScreen>
    with AutoRefreshMixin {
  final TextEditingController _searchController = TextEditingController();
  List<Driver> _filteredDrivers = [];
  bool _isInitialized = false;

  @override
  void refreshData() {
    context.read<DriverProvider>().fetchDrivers();
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterDrivers);
    // Trigger API call to fetch drivers
    WidgetsBinding.instance.addPostFrameCallback((_) {
      refreshData();
    });
  }

  void _initializeApprovedDrivers() {
    final driverCtrl = context.read<DriverProvider>();
    final approvedDrivers = driverCtrl.driverList
        .where((driver) => driver.approvalStatus?.toLowerCase() == 'approved')
        .toList();
    approvedDrivers.sort((a, b) =>
        (a.name ?? '').toLowerCase().compareTo((b.name ?? '').toLowerCase()));

    setState(() {
      _filteredDrivers = approvedDrivers;
      _isInitialized = true;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterDrivers() {
    final query = _searchController.text.toLowerCase();
    final driverCtrl = context.read<DriverProvider>();

    // Filter only approved drivers
    final approvedDrivers = driverCtrl.driverList
        .where((driver) => driver.approvalStatus?.toLowerCase() == 'approved')
        .toList();

    if (query.isEmpty) {
      // Sort alphabetically when search is empty
      approvedDrivers.sort((a, b) =>
          (a.name ?? '').toLowerCase().compareTo((b.name ?? '').toLowerCase()));
      setState(() {
        _filteredDrivers = approvedDrivers;
      });
      return;
    }

    setState(() {
      _filteredDrivers = approvedDrivers.where((driver) {
        final name = (driver.name ?? '').toLowerCase();
        final driverId = (driver.driverUniqueId ?? '').toLowerCase();
        final email = (driver.email ?? '').toLowerCase();

        return name.contains(query) ||
            driverId.contains(query) ||
            email.contains(query);
      }).toList();
    });
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

    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (dialogContext) {
        return CustomConfirmationDialog(
          message: appFonts.confirmAssignDriver,
          onCancel: () => Navigator.pop(dialogContext),
          onConfirm: () async {
            Navigator.pop(dialogContext);

            final driverCtrl = context.read<DriverProvider>();

            final success = await driverCtrl.assignDriverToStudent(
              studentId: widget.studentId!,
              driverId: driver.driverId!,
            );

            if (!mounted) return;

            if (success) {
              // Refresh student list
              context.read<AddStudentProvider>().fetchStudents();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: TextWidgetCommon(
                    text: appFonts.driverAssignedSuccessfully,
                  ),
                ),
              );
              // Navigate back to student list
              await Future.delayed(const Duration(milliseconds: 500));
              if (mounted) {
                Navigator.pop(context);
              }
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
    _filterDrivers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColor(context).appTheme.screenBg,
      body: Consumer<DriverProvider>(
        builder: (context, driverCtrl, child) {
          // Initialize drivers once loading is complete
          if (!driverCtrl.isLoading && !_isInitialized) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!_isInitialized && mounted) {
                _initializeApprovedDrivers();
              }
            });
          }

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
                                      color:
                                          appColor(context).appTheme.lightText,
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
                child: driverCtrl.isLoading || !_isInitialized
                    ? ListView.builder(
                        padding: EdgeInsets.only(top: Sizes.s20),
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return const DriverCardSkeleton();
                        },
                      )
                    : _filteredDrivers.isNotEmpty
                        ? ListView.builder(
                            padding: EdgeInsets.only(
                              top: Sizes.s20,
                            ),
                            itemCount: _filteredDrivers.length,
                            itemBuilder: (context, index) {
                              return DriverCard(
                                driver: _filteredDrivers[index],
                                onTap: () =>
                                    _selectDriver(_filteredDrivers[index]),
                                getStatusColor: _getStatusColor,
                              );
                            },
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.people_outline,
                                    size: Sizes.s60,
                                    color: appColor(context)
                                        .appTheme
                                        .lightText
                                        .withValues(alpha: 0.3)),
                                VSpace(Sizes.s16),
                                TextWidgetCommon(
                                  text: _searchController.text.isNotEmpty
                                      ? language(
                                          context,
                                          appFonts
                                              .searchForDriverByNameIdOrEmail)
                                      : language(
                                          context,
                                          appFonts
                                              .searchForDriverByNameIdOrEmail),
                                  style: AppCss.lexendRegular14.textColor(
                                      appColor(context).appTheme.lightText),
                                  textAlign: TextAlign.center,
                                ).padding(horizontal: Sizes.s40),
                              ],
                            ),
                          ),
              ),
            ],
          );
        },
      ),
    );
  }

  Color _getStatusColor(BuildContext context, String status) {
    switch (status.toLowerCase()) {
      case 'active':
      case 'approved':
        return appColor(context).appTheme.activeColor;
      case 'pending':
        return appColor(context).appTheme.yellowIcon;
      case 'rejected':
      case 'inactive':
        return appColor(context).appTheme.alertZone;
      default:
        return appColor(context).appTheme.lightText;
    }
  }
}
