/// Socket events used by the parent app
///
/// Events the parent app emits to the server
enum ParentSocketEvent {
  /// Subscribe to receive updates for a trip - USED
  subscribeTrip('parent:subscribe_trip'),

  /// Unsubscribe from trip updates - USED
  unsubscribeTrip('parent:unsubscribe_trip');

  final String value;
  const ParentSocketEvent(this.value);
}

/// Parent-specific notification events (Server → Specific Parent)
/// These are sent only to the specific parent of a student via their personal room.
/// Auto-triggered when driver records pickup/drop via REST API.
enum ParentNotificationEvent {
  /// Notifies parent their child was picked up from home
  myStudentPicked('parent:my_student_picked'),

  /// Notifies parent their child was dropped off at home
  myStudentDropped('parent:my_student_dropped'),

  /// Notifies parent driver is approaching their child's location
  myStudentApproaching('parent:my_student_approaching');

  final String value;
  const ParentNotificationEvent(this.value);
}

/// Broadcast events the parent app listens for from the server
enum BroadcastSocketEvent {
  /// Real-time driver position updates - USED
  positionUpdate('trip:position_update'),

  /// Trip has started - USED
  tripStarted('trip:started'),

  /// Trip has been completed - USED
  tripCompleted('trip:completed'),

  /// Route has been calculated/recalculated - USED
  routeCalculated('trip:route_calculated'),

  /// Driver is approaching a waypoint - USED
  approaching('trip:approaching'),

  /// Student has been picked up - USED
  studentPicked('trip:student_picked'),

  /// Student has been dropped off - USED
  studentDropped('trip:student_dropped'),

  /// Socket error (authorization/validation) - USED
  error('socket:error');

  final String value;
  const BroadcastSocketEvent(this.value);
}
