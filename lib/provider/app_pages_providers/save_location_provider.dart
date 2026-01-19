import '../../config.dart';
import '../../api/api_client.dart';
import '../../api/services/address_service.dart';

class SaveLocationProvider with ChangeNotifier {
  List saveLocationList = [];
  bool _isLoading = true; // Start as true to prevent empty state flash
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Reset method - sets isLoading back to false
  void reset() {
    _isLoading = false;
    notifyListeners();
  }

  // Fetch address from API
  Future<void> init() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final addressService = AddressService(ApiClient());
      final response = await addressService.getParentAddress();

      if (response != null && response.success) {
        final address = response.data;
        // Convert API response to format expected by existing UI
        saveLocationList = [
          {
            'icon':
                address.isPrimary ? svgAssets.home : svgAssets.briefcaseDark,
            'title': address.isPrimary ? 'Home' : 'Other',
            'address': address.displayAddress,
          }
        ];
      } else {
        saveLocationList = [];
      }
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to load address: $e';
      saveLocationList = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  // Refresh data
  Future<void> refresh() async {
    await init();
  }

  // Remove location method
  void removeLocation(location, BuildContext context) {
    route.pop(context);
    saveLocationList.remove(location);
    notifyListeners();
  }
}
