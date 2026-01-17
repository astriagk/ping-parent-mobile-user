import 'package:flutter/material.dart';
import '../config.dart';

class StatusHelper {
  /// Get status color based on assignment status
  static Color getAssignmentStatusColor(BuildContext context, String? status) {
    switch (status) {
      case 'active':
        return appColor(context).appTheme.success;
      case 'parent_requested':
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
