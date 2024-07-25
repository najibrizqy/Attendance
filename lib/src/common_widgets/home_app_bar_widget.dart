import 'package:attendance/src/features/attendance/presentation/history_screen.dart';
import 'package:attendance/src/theme_manager/color_manager.dart';
import 'package:attendance/src/theme_manager/font_manager.dart';
import 'package:attendance/src/theme_manager/style_manager.dart';
import 'package:flutter/cupertino.dart';

class HomeAppBarWidget extends StatelessWidget {
  final String title;
  const HomeAppBarWidget({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: ColorManager.primary,
      padding: const EdgeInsets.only(
        top: 40,
        left: 20,
        right: 20,
        bottom: 15,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: getWhiteTextStyle(fontWeight: FontWeighManager.semiBold)
                .copyWith(fontSize: 18),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, HistoryScreen.routeName);
            },
            child: Icon(
              CupertinoIcons.book,
              color: ColorManager.white,
            ),
          ),
        ],
      ),
    );
  }
}
