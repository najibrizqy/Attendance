// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'attendance_bloc.dart';

@immutable
abstract class AttendanceState {}

class AttendanceInitial extends AttendanceState {}

class AttendanceLoading extends AttendanceState {}

class AttendanceLoaded extends AttendanceState {
  final List<Attendance> attendance;
  AttendanceLoaded({
    required this.attendance,
  });
}
