enum ParentSocketEvent {
  subscribeTrip('parent:subscribe_trip'),
  unsubscribeTrip('parent:unsubscribe_trip');

  final String value;
  const ParentSocketEvent(this.value);
}

enum ParentNotificationEvent {
  myStudentPicked('parent:my_student_picked'),
  myStudentDropped('parent:my_student_dropped'),
  myStudentApproaching('parent:my_student_approaching'),
  myStudentAbsent('parent:my_student_absent');

  final String value;
  const ParentNotificationEvent(this.value);
}

enum BroadcastSocketEvent {
  positionUpdate('trip:position_update'),
  tripStarted('trip:started'),
  tripCompleted('trip:completed'),
  tripStatusUpdate('trip:status_update'),
  routeCalculated('trip:route_calculated'),
  approaching('trip:approaching'),
  studentPicked('trip:student_picked'),
  studentDropped('trip:student_dropped'),
  error('socket:error');

  final String value;
  const BroadcastSocketEvent(this.value);
}
