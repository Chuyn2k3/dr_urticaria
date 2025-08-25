import 'package:flutter/material.dart';

class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  AppColorsExtension({
    required this.primary,
    required this.onPrimary,
    required this.red,
    required this.orange,
    required this.yello,
    required this.green,
    required this.mint,
    required this.teal,
    required this.cyan,
    required this.blue,
    required this.indigo,
    required this.purple,
    required this.pink,
    required this.brown,
    required this.black,
    required this.grey,
    required this.grey2,
    required this.grey3,
    required this.grey4,
    required this.grey5,
    required this.grey6,
    required this.white,
    required this.brand,
    required this.labelPrimary,
    required this.labelSecondary,
    required this.labelTertiary,
    required this.labelQuarternary,
    required this.fillPrimary,
    required this.fillSecondary,
    required this.fillTertiary,
    required this.fillQuarternary,
    required this.backgoundPrimary,
    required this.backgoundSecondary,
    required this.bggPrimary,
    required this.bggSecondary,
  });

  final Color primary;
  final Color onPrimary;
  final Color red;
  final Color orange;
  final Color yello;
  final Color green;
  final Color mint;
  final Color teal;
  final Color cyan;
  final Color blue;
  final Color indigo;
  final Color purple;
  final Color pink;
  final Color brown;
  final Color black;
  final Color grey;
  final Color grey2;
  final Color grey3;
  final Color grey4;
  final Color grey5;
  final Color grey6;
  final Color white;
  final Color brand;
  final Color labelPrimary;
  final Color labelSecondary;
  final Color labelTertiary;
  final Color labelQuarternary;
  final Color fillPrimary;
  final Color fillSecondary;
  final Color fillTertiary;
  final Color fillQuarternary;
  final Color backgoundPrimary;
  final Color backgoundSecondary;
  final Color bggPrimary;
  final Color bggSecondary;

  @override
  ThemeExtension<AppColorsExtension> copyWith({
    Color? primary,
    Color? onPrimary,
    Color? secondary,
    Color? red,
    Color? orange,
    Color? yello,
    Color? green,
    Color? mint,
    Color? teal,
    Color? cyan,
    Color? blue,
    Color? indigo,
    Color? purple,
    Color? pink,
    Color? brown,
    Color? black,
    Color? grey,
    Color? grey2,
    Color? grey3,
    Color? grey4,
    Color? grey5,
    Color? grey6,
    Color? white,
    Color? brand,
    Color? labelPrimary,
    Color? labelSecondary,
    Color? labelTertiary,
    Color? labelQuarternary,
    Color? fillPrimary,
    Color? fillSecondary,
    Color? fillTertiary,
    Color? fillQuarternary,
    Color? backgoundPrimary,
    Color? backgoundSecondary,
    Color? bggPrimary,
    Color? bggSecondary,
  }) {
    return AppColorsExtension(
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      red: red ?? this.red,
      orange: orange ?? this.orange,
      yello: yello ?? this.yello,
      green: green ?? this.green,
      mint: mint ?? this.mint,
      teal: teal ?? this.teal,
      cyan: cyan ?? this.cyan,
      blue: blue ?? this.blue,
      indigo: indigo ?? this.indigo,
      purple: purple ?? this.purple,
      pink: pink ?? this.pink,
      brown: brown ?? this.brown,
      black: black ?? this.black,
      grey: grey ?? this.grey,
      grey2: grey2 ?? this.grey2,
      grey3: grey3 ?? this.grey3,
      grey4: grey4 ?? this.grey4,
      grey5: grey5 ?? this.grey5,
      grey6: grey6 ?? this.grey6,
      white: white ?? this.white,
      brand: brand ?? this.brand,
      labelPrimary: labelPrimary ?? this.labelPrimary,
      labelSecondary: labelSecondary ?? this.labelSecondary,
      labelTertiary: labelTertiary ?? this.labelTertiary,
      labelQuarternary: labelQuarternary ?? this.labelQuarternary,
      fillPrimary: fillPrimary ?? this.fillPrimary,
      fillSecondary: fillSecondary ?? this.fillSecondary,
      fillTertiary: fillTertiary ?? this.fillTertiary,
      fillQuarternary: fillQuarternary ?? this.fillQuarternary,
      backgoundPrimary: backgoundPrimary ?? this.backgoundPrimary,
      backgoundSecondary: backgoundSecondary ?? this.backgoundSecondary,
      bggPrimary: bggPrimary ?? this.bggPrimary,
      bggSecondary: bggSecondary ?? this.bggSecondary,
    );
  }

  @override
  ThemeExtension<AppColorsExtension> lerp(
    covariant ThemeExtension<AppColorsExtension>? other,
    double t,
  ) {
    if (other is! AppColorsExtension) {
      return this;
    }

    return AppColorsExtension(
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      red: Color.lerp(red, other.red, t)!,
      orange: Color.lerp(orange, other.orange, t)!,
      yello: Color.lerp(yello, other.yello, t)!,
      green: Color.lerp(green, other.green, t)!,
      mint: Color.lerp(mint, other.mint, t)!,
      teal: Color.lerp(teal, other.teal, t)!,
      cyan: Color.lerp(cyan, other.cyan, t)!,
      blue: Color.lerp(blue, other.blue, t)!,
      indigo: Color.lerp(indigo, other.indigo, t)!,
      purple: Color.lerp(purple, other.purple, t)!,
      pink: Color.lerp(pink, other.pink, t)!,
      brown: Color.lerp(brown, other.brown, t)!,
      black: Color.lerp(black, other.black, t)!,
      grey: Color.lerp(grey, other.grey, t)!,
      grey2: Color.lerp(grey2, other.grey2, t)!,
      grey3: Color.lerp(grey3, other.grey3, t)!,
      grey4: Color.lerp(grey4, other.grey4, t)!,
      grey5: Color.lerp(grey5, other.grey5, t)!,
      grey6: Color.lerp(grey6, other.grey6, t)!,
      white: Color.lerp(white, other.white, t)!,
      brand: Color.lerp(brand, other.brand, t)!,
      labelPrimary: Color.lerp(labelPrimary, other.labelPrimary, t)!,
      labelSecondary: Color.lerp(labelSecondary, other.labelSecondary, t)!,
      labelTertiary: Color.lerp(labelTertiary, other.labelTertiary, t)!,
      labelQuarternary:
          Color.lerp(labelQuarternary, other.labelQuarternary, t)!,
      fillPrimary: Color.lerp(fillPrimary, other.fillPrimary, t)!,
      fillSecondary: Color.lerp(fillSecondary, other.fillSecondary, t)!,
      fillTertiary: Color.lerp(fillTertiary, other.fillTertiary, t)!,
      fillQuarternary: Color.lerp(fillQuarternary, other.fillQuarternary, t)!,
      backgoundPrimary:
          Color.lerp(backgoundPrimary, other.backgoundPrimary, t)!,
      backgoundSecondary:
          Color.lerp(backgoundSecondary, other.backgoundSecondary, t)!,
      bggPrimary: Color.lerp(bggPrimary, other.bggPrimary, t)!,
      bggSecondary: Color.lerp(bggSecondary, other.bggSecondary, t)!,
    );
  }
}
