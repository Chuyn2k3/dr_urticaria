import 'package:flutter/material.dart';

class AppColors {
  final MaterialColor primary;
  final MaterialColor neutral;
  final MaterialColor red;
  final MaterialColor orange;
  final MaterialColor green;
  final MaterialColor yellow;
  final MaterialColor blue;
  final MaterialColor mint;
  final MaterialColor teal;
  final MaterialColor cyan;
  final MaterialColor indigo;
  final MaterialColor magenta;
  final MaterialColor pink;
  final MaterialColor brown;

  factory AppColors.light() {
    return AppColors(
      primary: const MaterialColor(
        0xFF2B5BCC,
        <int, Color>{
          50: Color(0xFFEAEFFB),
          100: Color(0xFFD5DFF6),
          200: Color(0xFFABBFED),
          300: Color(0xFF819FE4),
          400: Color(0xFF567EDC),
          500: Color(0xFF2B5BCC),
          600: Color(0xFF234BA9),
          700: Color(0xFF1B397E),
          800: Color(0xFF122654),
          900: Color(0xFF09132A),
          950: Color(0xFF040915),
        },
      ),
      neutral: const MaterialColor(
        0xFF8D97B0,
        <int, Color>{
          0: Color(0xFFFFFFFF),
          1: Color(0xFFE1E3E5),
          50: Color(0xFFF4F5F7),
          100: Color(0xFFE9ECF1),
          200: Color(0xFFD8DDE4),
          300: Color(0xFFBFC8D4),
          400: Color(0xFFA4AFC1),
          500: Color(0xFF8D97B0),
          600: Color(0xFF717998),
          700: Color(0xFF62667F),
          800: Color(0xFF4A4E5E),
          900: Color(0xFF393C46),
          950: Color(0xFF17181C),
        },
      ),
      red: const MaterialColor(
        0xFFF43F5E,
        <int, Color>{
          50: Color(0xFFFFF1F3),
          100: Color(0xFFFFE4E6),
          200: Color(0xFFFECDD3),
          500: Color(0xFFF43F5E),
          600: Color(0xFFE11D48),
          700: Color(0xFFBE123C),
        },
      ),
      green: const MaterialColor(
        0xFF22C55E,
        <int, Color>{
          50: Color(0xFFF0FDF5),
          100: Color(0xFFDCFCE7),
          200: Color(0xFFBBF7D0),
          500: Color(0xFF22C55E),
          600: Color(0xFF16A34A),
          700: Color(0xFF15803D),
        },
      ),
      yellow: const MaterialColor(
        0xFFFACC15,
        <int, Color>{
          50: Color(0xFFFEFAE8),
          100: Color(0xFFFEF9C3),
          200: Color(0xFFFEF08A),
          500: Color(0xFFFACC15),
          600: Color(0xFFF59E0B),
          700: Color(0xFFB45309),
        },
      ),
      blue: const MaterialColor(
        0xFF007BFF,
        <int, Color>{
          50: Color(0xFFE5F2FF),
          100: Color(0xFFCCE5FF),
          200: Color(0xFF99CAFF),
          500: Color(0xFF007BFF),
          600: Color(0xFF0063CC),
          700: Color(0xFF004A99),
        },
      ),
      orange: const MaterialColor(
        0xFFFF9500,
        <int, Color>{
          100: Color(0xFFFFEACC),
          500: Color(0xFFFF9500),
        },
      ),
      mint: const MaterialColor(
        0xFF00C7BE,
        <int, Color>{
          100: Color(0xFFCCF4F2),
          500: Color(0xFF00C7BE),
        },
      ),
      teal: const MaterialColor(
        0xFF30B0C7,
        <int, Color>{
          100: Color(0xFFD6EFF4),
          500: Color(0xFF30B0C7),
        },
      ),
      cyan: const MaterialColor(
        0xFF32ADE6,
        <int, Color>{
          100: Color(0xFFD6EFFA),
          500: Color(0xFF32ADE6),
        },
      ),
      indigo: const MaterialColor(
        0xFF5856D6,
        <int, Color>{
          100: Color(0xFFDEDDF7),
          500: Color(0xFF5856D6),
        },
      ),
      magenta: const MaterialColor(
        0xFFAF52DE,
        <int, Color>{
          100: Color(0xFFEFDCF8),
          500: Color(0xFFAF52DE),
        },
      ),
      pink: const MaterialColor(
        0xFFFF2D55,
        <int, Color>{
          100: Color(0xFFFFD5DD),
          500: Color(0xFFFF2D55),
        },
      ),
      brown: const MaterialColor(
        0xFFA2845E,
        <int, Color>{
          100: Color(0xFFECE6DF),
          500: Color(0xFFA2845E),
        },
      ),
    );
  }

  AppColors({
    required this.primary,
    required this.neutral,
    required this.red,
    required this.green,
    required this.yellow,
    required this.blue,
    required this.orange,
    required this.mint,
    required this.teal,
    required this.cyan,
    required this.indigo,
    required this.magenta,
    required this.pink,
    required this.brown,
  });
}
