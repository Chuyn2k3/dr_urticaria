import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constant/color.dart';
import '../../utils/common_app.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar(
      {super.key,
      this.title,
      this.actions,
      this.flexibleSpace,
      this.automaticallyImplyLeading,
      this.widgetTitle,
      this.leading,
      this.leadingWidth,
      this.styleTitle,
      this.backgroundColor = Colors.transparent});
  final String? title;
  final List<Widget>? actions;
  final Widget? flexibleSpace;
  final bool? automaticallyImplyLeading;
  final Widget? widgetTitle;
  final Widget? leading;
  final double? leadingWidth;
  final TextStyle? styleTitle;
  final Color backgroundColor;
  CustomAppbar.basic({
    super.key,
    this.title,
    this.actions,
    this.flexibleSpace,
    this.automaticallyImplyLeading,
    this.widgetTitle,
    this.leadingWidth,
    this.styleTitle,
    VoidCallback? onTap,
    bool isLeading = true,
    this.backgroundColor = Colors.transparent,
  }) : leading = isLeading ? _previousButton(onTap) : const SizedBox();

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: widgetTitle ??
            Text(title ?? "",
                style: styleTitle ??
                    textTheme.t20B.copyWith(color: colorApp.labelPrimary)),
        centerTitle: true,
        backgroundColor: backgroundColor,
        elevation: 0.0,
        actions: actions,
        flexibleSpace: flexibleSpace,
        iconTheme: IconThemeData(color: colorApp.black),
        leading: leading,
        leadingWidth: leadingWidth,
        systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
            statusBarIconBrightness: Brightness.dark,
            statusBarColor: Colors.transparent),
        automaticallyImplyLeading: automaticallyImplyLeading ?? true);
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}

Widget _previousButton(VoidCallback? onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(99),
      ),
      child: const Icon(
        Icons.arrow_back_ios_new,
        color: Colors.black,
        size: 16,
      ),
    ),
  );
}
