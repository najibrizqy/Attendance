import 'package:attendance/src/features/attendance/presentation/history_screen.dart';
import 'package:attendance/src/features/attendance/presentation/live_attendance_screen.dart';
import 'package:attendance/src/features/attendance/presentation/set_master_location_screen.dart';
import 'package:attendance/src/theme_manager/theme_data_manager.dart';
import 'package:flutter/material.dart';

class AppScreen extends StatelessWidget {
  const AppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: getApplicationThemeData(),
      home: const LiveAttendanceScreen(),
      routes: {
        LiveAttendanceScreen.routeName: (context) =>
            const LiveAttendanceScreen(),
        HistoryScreen.routeName: (context) => const HistoryScreen(),
        SetMasterLocationScreen.routeName: (context) =>
            const SetMasterLocationScreen(),
      },
    );
  }
}
