import 'package:attendance/src/theme_manager/font_manager.dart';
import 'package:attendance/src/theme_manager/style_manager.dart';
import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onOkPressed;

  const CustomAlertDialog({
    required this.title,
    required this.content,
    required this.onOkPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: getBlackTextStyle(
                fontSize: 18,
                fontWeight: FontWeighManager.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              content,
              style: getBlackTextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: btnPrimaryStyle,
                  onPressed: onOkPressed,
                  child: Text(
                    'OK',
                    style: getWhiteTextStyle(fontWeight: FontWeighManager.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
