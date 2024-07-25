import 'package:attendance/src/app.dart';
import 'package:attendance/src/features/attendance/presentation/bloc/attendance/attendance_bloc.dart';
import 'package:attendance/src/theme_manager/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarColor: ColorManager.primary,
      ),
    );
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AttendanceBloc(),
        ),
      ],
      child: const AppScreen(),
    );
  }
}
