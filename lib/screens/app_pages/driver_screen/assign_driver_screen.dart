import '../../../api/models/driver_response.dart';
import '../../../config.dart';
import '../../../helper/date_formatter_helper.dart';
import '../../../provider/app_pages_providers/driver_provider.dart';
import '../../../widgets/ride_card/ride_card.dart';
import '../../../widgets/ride_card/layout/ride_data_model.dart';
import '../../../../widgets/common_confirmation_dialog.dart';

class AssignDriverScreen extends StatefulWidget {
  final String? studentId;

  const AssignDriverScreen({super.key, this.studentId});

  @override
  State<AssignDriverScreen> createState() => _AssignDriverScreenState();
}

class _AssignDriverScreenState extends State<AssignDriverScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Driver> _filteredDrivers = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DriverProvider>().onInit();
    });
    _searchController.addListener(_filterDrivers);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterDrivers() {
    final query = _searchController.text.toLowerCase();
    final driverCtrl = context.read<DriverProvider>();

    if (query.isEmpty) {
      setState(() {
        _filteredDrivers = [];
      });
      return;
    }

    setState(() {
      _filteredDrivers = driverCtrl.driverList.where((driver) {
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

    if (driver.driverUniqueId == null) {
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
          onCancel: () => route.pop(dialogContext),
          onConfirm: () async {
            route.pop(dialogContext);

            final driverCtrl = context.read<DriverProvider>();

            final success = await driverCtrl.assignDriverToStudent(
              studentId: widget.studentId!,
              driverUniqueId: driver.driverUniqueId!,
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
    setState(() {
      _searchController.clear();
      _filteredDrivers = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColor(context).appTheme.screenBg,
      body: Consumer<DriverProvider>(
        builder: (context, driverCtrl, child) {
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
                child: driverCtrl.isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: appColor(context).appTheme.primary,
                        ),
                      )
                    : _filteredDrivers.isNotEmpty
                        ? ListView.builder(
                            padding: EdgeInsets.only(
                              top: Sizes.s20,
                            ),
                            itemCount: _filteredDrivers.length,
                            itemBuilder: (context, index) {
                              return _buildDriverDetails(
                                  context, _filteredDrivers[index]);
                            },
                          )
                        : Center(
                            child: TextWidgetCommon(
                              text: language(context,
                                  appFonts.searchForDriverByNameIdOrEmail),
                              style: AppCss.lexendRegular14.textColor(
                                  appColor(context).appTheme.lightText),
                              textAlign: TextAlign.center,
                            ).padding(horizontal: Sizes.s40),
                          ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDriverDetails(BuildContext context, Driver driver) {
    return RideCard(
      rideData: RideDataModel(
        image: svgAssets.car,
        id: driver.driverUniqueId?.toUpperCase(),
        status: driver.isAvailable == true
            ? appFonts.available
            : appFonts.unavailable,
        statusColor: driver.isAvailable == true
            ? appColor(context).appTheme.activeColor
            : appColor(context).appTheme.alertZone,
        price: driver.currentStudentCount?.toString() ?? '0',
        date: DateFormatterHelper.formatToShortDate(driver.approvedAt),
        time: DateFormatterHelper.formatTo12HourTime(driver.approvedAt),
        driverName: driver.name,
        rating: (driver.rating != null && driver.rating! > 0)
            ? driver.rating!.toStringAsFixed(1)
            : null,
        userRatingNumber: ' (${driver.totalTrips ?? 0})',
        carName:
            '${driver.vehicleType?.toUpperCase() ?? ''} ${driver.vehicleNumber ?? ''} ${driver.vehicleCapacity != null ? '(${driver.vehicleCapacity} seats)' : ''}'
                .trim(),
        currentLocation: '123 Main Street, Downtown',
        addLocation: '',
      ),
      profileImageUrl: driver.photoUrl,
      index: 0,
      onTap: () => _selectDriver(driver),
    );
  }
}
