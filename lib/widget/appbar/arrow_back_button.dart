import 'package:flutter/material.dart';

import 'app_bar_setting.dart';

class ArrowBackButton extends StatelessWidget {
  final VoidCallback? onTap;
  const ArrowBackButton({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        Icons.arrow_back_ios,
        color: AppBarSetting.iconAndTextColor,
        size: 26,
      ),
    );
  }
}
