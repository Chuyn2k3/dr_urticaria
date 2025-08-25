import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SLStyle {
  static TextStyle t48B = PrimaryFont.bold(48);
  static TextStyle t48SB = PrimaryFont.semiBold(48);
  static TextStyle t48M = PrimaryFont.medium(48);
  static TextStyle t48R = PrimaryFont.regular(48);

  static TextStyle t32B = PrimaryFont.bold(32);
  static TextStyle t32SB = PrimaryFont.semiBold(32);
  static TextStyle t32M = PrimaryFont.medium(32);
  static TextStyle t32R = PrimaryFont.regular(32);

  static TextStyle t28B = PrimaryFont.bold(28);
  static TextStyle t28SB = PrimaryFont.semiBold(28);
  static TextStyle t28M = PrimaryFont.medium(28);
  static TextStyle t28R = PrimaryFont.regular(28);

  static TextStyle t24B = PrimaryFont.bold(24);
  static TextStyle t24SB = PrimaryFont.semiBold(24);
  static TextStyle t24M = PrimaryFont.medium(24);
  static TextStyle t24R = PrimaryFont.regular(24);

  static TextStyle t20B = PrimaryFont.bold(20);
  static TextStyle t20SB = PrimaryFont.semiBold(20);
  static TextStyle t20M = PrimaryFont.medium(20);
  static TextStyle t20R = PrimaryFont.regular(20);

  static TextStyle t18B = PrimaryFont.bold(18);
  static TextStyle t18SB = PrimaryFont.semiBold(18);
  static TextStyle t18M = PrimaryFont.medium(18);
  static TextStyle t18R = PrimaryFont.regular(18);

  static TextStyle t16B = PrimaryFont.bold(16);
  static TextStyle t16SB = PrimaryFont.semiBold(16);
  static TextStyle t16M = PrimaryFont.medium(16);
  static TextStyle t16R = PrimaryFont.regular(16);

  static TextStyle t14B = PrimaryFont.bold(14);
  static TextStyle t14SB = PrimaryFont.semiBold(14);
  static TextStyle t14M = PrimaryFont.medium(14);
  static TextStyle t14R = PrimaryFont.regular(14);

  static TextStyle t14BTitleCase =
      PrimaryFont.bold(14).copyWith(decoration: TextDecoration.none);
  static TextStyle t14RUnderline =
      PrimaryFont.regular(14).copyWith(decoration: TextDecoration.underline);
  static TextStyle t14RStrikethrough =
      PrimaryFont.regular(14).copyWith(decoration: TextDecoration.lineThrough);

  static TextStyle t12B = PrimaryFont.bold(12);
  static TextStyle t12SB = PrimaryFont.semiBold(12);
  static TextStyle t12M = PrimaryFont.medium(12);
  static TextStyle t12R = PrimaryFont.regular(12);

  static TextStyle t12BTitleCase =
      PrimaryFont.bold(12).copyWith(decoration: TextDecoration.none);
  static TextStyle t12RUnderline =
      PrimaryFont.regular(12).copyWith(decoration: TextDecoration.underline);
  static TextStyle t12RStrikethrough =
      PrimaryFont.regular(12).copyWith(decoration: TextDecoration.lineThrough);

  static TextStyle t10B = PrimaryFont.bold(10);
  static TextStyle t10SB = PrimaryFont.semiBold(10);
  static TextStyle t10M = PrimaryFont.medium(10);
  static TextStyle t10R = PrimaryFont.regular(10);

  static TextStyle t10BALLCAPS =
      PrimaryFont.bold(10).copyWith(decoration: TextDecoration.none);
  static TextStyle t10RUnderline =
      PrimaryFont.regular(10).copyWith(decoration: TextDecoration.underline);
  static TextStyle t10RStrikethrough =
      PrimaryFont.regular(10).copyWith(decoration: TextDecoration.lineThrough);
}

class PrimaryFont {
  static TextStyle regular(double size) {
    return GoogleFonts.inter(
      fontWeight: FontWeight.w400,
      fontSize: size,
    );
  }

  static TextStyle medium(double size) {
    return GoogleFonts.inter(
      fontWeight: FontWeight.w500,
      fontSize: size,
    );
  }

  static TextStyle semiBold(double size) {
    return GoogleFonts.inter(
      fontWeight: FontWeight.w600,
      fontSize: size,
    );
  }

  static TextStyle bold(double size) {
    return GoogleFonts.inter(
      fontWeight: FontWeight.w700,
      fontSize: size,
    );
  }
}
