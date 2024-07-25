// ignore_for_file: depend_on_referenced_packages

import 'package:attendance/src/features/attendance/data/data_attendance_dummy.dart';
import 'package:attendance/src/features/attendance/domain/attendance.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'attendance_event.dart';
part 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  AttendanceBloc() : super(AttendanceInitial()) {
    on<OnAttendanceEventCalled>((event, emit) async {
      emit(AttendanceLoading());
      await Future.delayed(
        const Duration(seconds: 1),
      );
      emit(AttendanceLoaded(attendance: dataHistoryAttendance));
    });

    on<AddAttendance>((event, emit) {
      emit(AttendanceLoading());
      dataHistoryAttendance.add(event.attendance);
      emit(AttendanceLoaded(attendance: dataHistoryAttendance));
    });
  }
}
