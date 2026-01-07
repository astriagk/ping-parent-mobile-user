import 'package:flutter/material.dart';
import '../api/services/storage_service.dart';

/// Widget to check authentication status and return the appropriate initial screen
class AuthCheckWidget extends StatefulWidget {
  final Widget authenticatedScreen;
  final Widget unauthenticatedScreen;

  const AuthCheckWidget({
    super.key,
    required this.authenticatedScreen,
    required this.unauthenticatedScreen,
  });

  @override
  State<AuthCheckWidget> createState() => _AuthCheckWidgetState();
}

class _AuthCheckWidgetState extends State<AuthCheckWidget> {
  final StorageService _storage = StorageService();
  bool _isLoading = true;
  bool _hasValidSession = false;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      // Debug: Check token
      final token = await _storage.getAuthToken();
      print('AuthCheckWidget: Token exists: ${token != null}');

      // Debug: Check login status
      final isLoggedIn = await _storage.isLoggedIn();
      print('AuthCheckWidget: Is logged in: $isLoggedIn');

      final hasValidSession = await _storage.hasValidSession();
      print('AuthCheckWidget: Has valid session: $hasValidSession');

      if (mounted) {
        setState(() {
          _hasValidSession = hasValidSession;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('AuthCheckWidget: Error checking auth status: $e');
      if (mounted) {
        setState(() {
          _hasValidSession = false;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return _hasValidSession
        ? widget.authenticatedScreen
        : widget.unauthenticatedScreen;
  }
}
