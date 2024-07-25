import 'package:attendance/src/theme_manager/color_manager.dart';
import 'package:attendance/src/theme_manager/font_manager.dart';
import 'package:attendance/src/theme_manager/style_manager.dart';
import 'package:flutter/cupertino.dart';

class AppBarWidget extends StatelessWidget {
  final String title;
  const AppBarWidget({
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
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Icon(
                CupertinoIcons.back,
                color: ColorManager.white,
              ),
            ),
          ),
          Text(
            title,
            style: getWhiteTextStyle(fontWeight: FontWeighManager.semiBold)
                .copyWith(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
