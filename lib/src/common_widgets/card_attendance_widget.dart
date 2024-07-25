import 'package:attendance/src/features/attendance/domain/attendance.dart';
import 'package:attendance/src/theme_manager/color_manager.dart';
import 'package:attendance/src/theme_manager/font_manager.dart';
import 'package:attendance/src/theme_manager/style_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class CardAttendanceWidget extends StatelessWidget {
  final Attendance attendance;
  const CardAttendanceWidget({
    super.key,
    required this.attendance,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 15,
            right: 15,
            top: 10,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                CupertinoIcons.person_crop_square_fill,
                color: ColorManager.primary,
                size: 70,
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 2),
                  Text(
                    '${attendance.latitude}, ${attendance.longitude}',
                    style: getBlackTextStyle(
                        fontWeight: FontWeighManager.semiBold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Checkin on: ${Jiffy.parse(attendance.checkinDate.toString()).format(pattern: 'hh:mm a')}',
                    style: getBlackTextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Distance: ${attendance.distance} Meter',
                    style: getBlackTextStyle(fontSize: 14),
                  ),
                ],
              )
            ],
          ),
        ),
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Divider(
            color: ColorManager.grey,
            thickness: 0.5,
          ),
        ),
      ],
    );
  }
}
