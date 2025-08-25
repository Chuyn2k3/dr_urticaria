import 'package:dr_urticaria/core/colors/app_colors.dart';
import 'package:flutter/material.dart';

class AppThemes extends InheritedWidget {
  final AppColors appColors;

  const AppThemes({
    super.key,
    required this.appColors,
    required Widget child,
  }) : super(child: child);

  static AppThemes of(BuildContext context) {
    final inheritedTheme =
        context.dependOnInheritedWidgetOfExactType<AppThemes>();
    if (inheritedTheme == null) {
      throw Exception("Theme not found in context");
    }
    return inheritedTheme;
  }

  @override
  bool updateShouldNotify(AppThemes oldWidget) {
    return appColors != oldWidget.appColors; // Rebuild only if color changes
  }
}
