import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _connectionStatusController =
      StreamController<bool>.broadcast();

  Stream<bool> get connectionStatusStream => _connectionStatusController.stream;

  ConnectivityService() {
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _connectionStatusController.add(_isConnected(result));
    } as void Function(List<ConnectivityResult> event)?);
  }

  _isConnected(ConnectivityResult result) {
    return result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi;
  }

  checkConnection() async {
    var result = await _connectivity.checkConnectivity();
    return _isConnected(result as ConnectivityResult);
  }

  dispose() {
    _connectionStatusController.close();
  }
}
