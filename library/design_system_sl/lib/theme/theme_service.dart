import 'package:design_system_sl/theme/colors.dart';
import 'package:design_system_sl/typography/typography.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'foundation/app_colors_extension.dart';
import 'foundation/app_text_theme_extension.dart';

class AppTheme {
  AppTheme._();

  static TextTheme? appTextTheme = GoogleFonts.interTextTheme();

  static ThemeData? light(BuildContext context) {
    final defaultTheme = ThemeData(
      brightness: Brightness.light,
      fontFamily: GoogleFonts.inter().fontFamily,
      textTheme: GoogleFonts.interTextTheme(
        Theme.of(context).textTheme,
      ),
    );

    return defaultTheme.copyWith(
      extensions: [_lightAppColors, _textTheme],
      bottomSheetTheme: const BottomSheetThemeData(
        surfaceTintColor: Colors.white,
      ),
      textTheme: appTextTheme,
    );
  }

  static final _lightAppColors = AppColorsExtension(
    primary: SLColor.brand,
    onPrimary: SLColor.brand,
    red: SLColor.redLight,
    orange: SLColor.orangeLight,
    yello: SLColor.yelloLight,
    green: SLColor.greenLight,
    mint: SLColor.mintLight,
    teal: SLColor.tealLight,
    cyan: SLColor.cyanLight,
    blue: SLColor.blueLight,
    indigo: SLColor.indigoLight,
    purple: SLColor.purpleLight,
    pink: SLColor.pinkLight,
    brown: SLColor.brownLight,
    black: SLColor.blackLight,
    grey: SLColor.greyLight,
    grey2: SLColor.grey2Light,
    grey3: SLColor.grey3Light,
    grey4: SLColor.grey4Light,
    grey5: SLColor.grey5Light,
    grey6: SLColor.grey6Light,
    white: SLColor.whiteLight,
    brand: SLColor.brand,
    labelPrimary: SLColor.labelPrimaryLight,
    labelSecondary: SLColor.labelSecondaryLight,
    labelTertiary: SLColor.labelTertiaryLight,
    labelQuarternary: SLColor.labelQuarternaryLight,
    fillPrimary: SLColor.fillPrimaryLight,
    fillSecondary: SLColor.fillSecondaryLight,
    fillTertiary: SLColor.fillTertiaryLight,
    fillQuarternary: SLColor.fillQuarternaryLight,
    backgoundPrimary: SLColor.backgoundPrimaryLight,
    backgoundSecondary: SLColor.backgoundSecondaryLight,
    bggPrimary: SLColor.bggPrimaryLight,
    bggSecondary: SLColor.bggSecondaryLight,
  );

  static final _textTheme = AppTextThemeExtension(
    t48B: SLStyle.t48B,
    t48SB: SLStyle.t48SB,
    t48M: SLStyle.t48M,
    t48R: SLStyle.t48R,
    t32B: SLStyle.t32B,
    t32SB: SLStyle.t32SB,
    t32M: SLStyle.t32M,
    t32R: SLStyle.t32R,
    t28B: SLStyle.t28B,
    t28SB: SLStyle.t28SB,
    t28M: SLStyle.t28M,
    t28R: SLStyle.t28R,
    t24B: SLStyle.t24B,
    t24SB: SLStyle.t24SB,
    t24M: SLStyle.t24M,
    t24R: SLStyle.t24R,
    t20B: SLStyle.t20B,
    t20SB: SLStyle.t20SB,
    t20M: SLStyle.t20M,
    t20R: SLStyle.t20R,
    t18B: SLStyle.t18B,
    t18SB: SLStyle.t18SB,
    t18M: SLStyle.t18M,
    t18R: SLStyle.t18R,
    t16B: SLStyle.t16B,
    t16SB: SLStyle.t16SB,
    t16M: SLStyle.t16M,
    t16R: SLStyle.t16R,
    t14B: SLStyle.t14B,
    t14SB: SLStyle.t14SB,
    t14M: SLStyle.t14M,
    t14R: SLStyle.t14R,
    t14BTitleCase: SLStyle.t14BTitleCase,
    t14RUnderline: SLStyle.t14RUnderline,
    t14RStrikethrough: SLStyle.t14RStrikethrough,
    t12B: SLStyle.t12B,
    t12SB: SLStyle.t12SB,
    t12M: SLStyle.t12M,
    t12R: SLStyle.t12R,
    t12BTitleCase: SLStyle.t12BTitleCase,
    t12RUnderline: SLStyle.t12RUnderline,
    t12RStrikethrough: SLStyle.t12RStrikethrough,
    t10B: SLStyle.t10B,
    t10SB: SLStyle.t10SB,
    t10M: SLStyle.t10M,
    t10R: SLStyle.t10R,
    t10BALLCAPS: SLStyle.t10BALLCAPS,
    t10RUnderline: SLStyle.t10RUnderline,
    t10RStrikethrough: SLStyle.t10RStrikethrough,
  );

  //
  // Dark theme
  //

  static final dark = () {
    final defaultTheme = ThemeData(
      brightness: Brightness.dark,
      fontFamily: GoogleFonts.inter().fontFamily,
      textTheme: appTextTheme,
    );

    return defaultTheme.copyWith(
      extensions: [_darkAppColors, _textTheme],
      textTheme: appTextTheme,
      bottomSheetTheme: const BottomSheetThemeData(
        surfaceTintColor: Colors.white,
      ),
    );
  }();

  static final _darkAppColors = AppColorsExtension(
    primary: SLColor.brand,
    onPrimary: SLColor.brand,
    red: SLColor.redDark,
    orange: SLColor.orangeDark,
    yello: SLColor.yelloDark,
    green: SLColor.greenDark,
    mint: SLColor.mintDark,
    teal: SLColor.tealDark,
    cyan: SLColor.cyanDark,
    blue: SLColor.blueDark,
    indigo: SLColor.indigoDark,
    purple: SLColor.purpleDark,
    pink: SLColor.pinkDark,
    brown: SLColor.brownDark,
    black: SLColor.blackDark,
    grey: SLColor.greyDark,
    grey2: SLColor.grey2Dark,
    grey3: SLColor.grey3Dark,
    grey4: SLColor.grey4Dark,
    grey5: SLColor.grey5Dark,
    grey6: SLColor.grey6Dark,
    white: SLColor.whiteDark,
    brand: SLColor.brand,
    labelPrimary: SLColor.labelPrimaryDark,
    labelSecondary: SLColor.labelSecondaryDark,
    labelTertiary: SLColor.labelTertiaryDark,
    labelQuarternary: SLColor.labelQuarternaryDark,
    fillPrimary: SLColor.fillPrimaryDark,
    fillSecondary: SLColor.fillSecondaryDark,
    fillTertiary: SLColor.fillTertiaryDark,
    fillQuarternary: SLColor.fillQuarternaryDark,
    backgoundPrimary: SLColor.backgoundPrimaryDark,
    backgoundSecondary: SLColor.backgoundSecondaryDark,
    bggPrimary: SLColor.bggPrimaryDark,
    bggSecondary: SLColor.bggSecondaryDark,
  );
}

extension AppThemeExtension on ThemeData {
  AppColorsExtension get appColors =>
      extension<AppColorsExtension>() ?? AppTheme._lightAppColors;

  AppTextThemeExtension get appTextTheme =>
      extension<AppTextThemeExtension>() ?? AppTheme._textTheme;
}

extension ThemeGetter on BuildContext {
  ThemeData get theme => Theme.of(this);
}
