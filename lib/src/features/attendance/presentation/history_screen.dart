import 'package:attendance/src/common_widgets/app_bar_widget.dart';
import 'package:attendance/src/common_widgets/card_attendance_widget.dart';
import 'package:attendance/src/theme_manager/style_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:attendance/src/features/attendance/presentation/bloc/attendance/attendance_bloc.dart';
import 'package:attendance/src/theme_manager/color_manager.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  static const String routeName = './history';
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    context.read<AttendanceBloc>().add(OnAttendanceEventCalled());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: Stack(
        children: [
          Column(
            children: [
              const AppBarWidget(title: 'Data Attendance'),
              BlocBuilder<AttendanceBloc, AttendanceState>(
                builder: (context, state) {
                  if (state is AttendanceLoading) {
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: ColorManager.primary,
                        ),
                      ),
                    );
                  }
                  if (state is AttendanceLoaded) {
                    final data = state.attendance;
                    return data.isEmpty
                        ? Center(
                            child: Column(
                              children: [
                                const SizedBox(height: 10),
                                Text(
                                  'No Data Attendance',
                                  style: getBlackTextStyle(),
                                ),
                              ],
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                return CardAttendanceWidget(
                                  attendance: data[index],
                                );
                              },
                              itemCount: data.length,
                            ),
                          );
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
