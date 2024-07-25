part of 'attendance_bloc.dart';

@immutable
abstract class AttendanceEvent {}

class OnAttendanceEventCalled extends AttendanceEvent {}

class AddAttendance extends AttendanceEvent {
  final Attendance attendance;
  AddAttendance({
    required this.attendance,
  });
}
