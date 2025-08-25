import 'dart:core';
import 'package:flutter/cupertino.dart';

enum CompareType { Bigger, Smaller }

class PackageCategoryGroup {
  static const int KHAM_SUC_KHOE = 1;
  static const int TAM_SOAT_UNG_THU = 2;
  static const int KHAM_COVID = 3;
  static const int TU_VAN = 4;
  static const int RANG_HAM_MAT = 5;
  static const int TU_VAN_TAI_CO_SO_Y_TE = 6;
  static const int XET_NGHIEM_TAN_NHA = 7;
  static const int DAT_KHAM_THUONG_QUY = 9;
}

class Constants {
  static String urlPrivacy = "https://onenet.vn/chinh-sach-bao-mat-thong-tin";
  static String activate = "Activate";
  static const String codeVDUH = "VDUH";
  static const String codeNAYH = "NAYH";
  static const String codeNursing = "codeNursing";
  static const String nameNursing = "nameNursing";
  static const String idNursing = "idNursing";
  static String versionApp = '';
  static bool testing = true;
  static String defaultImage = '';
  static String user = "user";
  static String enableNotification = "enableNotification";
  static String signedIn = "signedIn";
  static String isStaff = "isStaff";
  static String isActiveFinger = "isActiveFinger";
  static int pageSize = 10;
  static String language = "language";
  static String keyGooglePlaces = "AIzaSyBYa07fhNcIDv-kUQDmKzDcWV3vkhGqG6g";
  static const String questionHYH = "Hỏi đáp cùng Bệnh Viện Hữu Nghị Việt Đức";
  static const String informationPublic = "Thông tin cộng đồng";
  static const String keyPhoneNumber = 'phoneNumber';
  static const String keywordPackage = 'keywordPackage';
  static const String keyUNSign = 'keyUNSign';
  static const String keyPASign = 'keyPASign';
  static const String keyEMSign = 'keyEMSign';
  static const String keyPinSign = 'keyPinSign';
  static const Map<int, String> signingStatus = {
    1: 'Chưa ký',
    2: "Đang ký",
    3: 'Đã ký',
    4: "Thu hồi"
  };
  static const List<String> listTitlePersonalScreen = [
    'Thông tin cá nhân',
    'Thiết lập',
    //'Về chúng tôi',
    'Cài đặt mật khẩu',
    'Mã QR cá nhân',
    'Hotline',
    // 'Đo bước chân',
  ];

  static const List<String> listStatusSignature = [
    'Chưa ký số',
    "Đang ký",
    'Đã ký số',
    "Thu hồi",
  ];

  static const List<String> therapy = [
    'Y lệnh',
    'Chăm sóc',
  ];
  static List<String> ehrConstants = [
    'Cận lâm sàng',
    'Đơn thuốc',
    'Tài liệu kí số'
  ];
  static Map<String, int?> listStatusSpecific = {
    'Tất cả': null,
    'Đang thực hiện': 2,
    'Chờ thực hiện': 1,
    'Chờ thanh toán': 3,
  };

  /// http headers
  static Map<String, String> apiHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static String convertPhone(String phone) {
    if (phone[0] == '0') {
      return '+84' + phone.substring(1);
    } else {
      return phone;
    }
  }

  /// e.t.c.
  static double commonPadding = 15.0;
  static String firstTimeLoadApp = "FIRST_TIME_LOAD_APP";
  static String isNotification = 'isNotification';
  static double buttonHeight = 48.0;
  static double appInputHeight = 40.0;
  static double buttonHeightSmall = 40.0;
  static String contactPhone = '0346688996';
  static String vietnameseCurrencyUnit = "VNĐ";
  static String weightUnit = "kg";
  static String heightUnit = "cm";
  static String bloodUnit = "Rh+";
  static String bloodPressureUnit = "mm\nHg";
  static double iconBackSize = 16.0;
  static double viewHeaderHeight = 550;
  static String landingUnit = "landingUnit";
  static String nameUnit = "nameUnit";
  static String idUnit = "idUnit";
  static String avatarUnit = "avatarUnit";
  static String addressUnit = "addressUnit";
}

class DateTimeFormatPattern {
  static const String dateFlowServer = 'yyyy-MM-dd';
  static const String mmyy = 'MM/YY';
  static const String mmyyyyy = 'MM/yyyy';
  static const String dd = 'dd';
  static const String formatDefault = 'dd-MM-yyyy HH:mm:ss';
  static const String formatddMMyyyy = 'dd-MM-yyyy';
  static const String formatyyyyMMdd = 'yyyy-MM-dd';
  static const String dobddMMyyyy = 'dd/MM/yyyy';
  static const String formatddMM = 'dd/MM';
  static const String formatHHmm = 'HH:mm';
  static const String commonDateFormat = "dd/MMM/yyyy";
  static const String dateFormatPayment = "HH:mm 'ngày' MM/dd";
  static const String hh_mm_NGAY_dd_MM = "HH:mm 'ngày' dd/MM";
  static const String hh_mm_NGAY_dd_MM_yyyy = "HH:mm 'ngày' dd/MM/yyyy";
  static const String backendTimeFormat = "dd/MM/yyyy HH:mm";

  // if (DateTime(date.year, date.month, date.day)
  //         .compareTo(DateTime(now.year, now.month, now.day)) ==
  //     0) {
  //   return l10n(context)!.tomorrow;
  // } else {
  //   switch (date.weekday) {
  //     case 1:
  //       return l10n(context)!.mon;
  //     case 2:
  //       return l10n(context)!.tue;
  //     case 3:
  //       return l10n(context)!.wed;
  //     case 4:
  //       return l10n(context)!.thu;
  //     case 5:
  //       return l10n(context)!.fri;
  //     case 6:
  //       return l10n(context)!.sat;
  //     case 7:
  //       return l10n(context)!.sun;
  //     default:
  //       return "";
  //   }
  // }
}

class Reges {
  /// Regex
  static RegExp regIsEmail = RegExp(
      r'^[A-Za-z\s][A-Za-z0-9_\.\s]{2,32}@[A-Za-z0-9]{2,}(\.[A-Za-z0-9\s]{2,4}){1,2}$',
      caseSensitive: false,
      multiLine: false);
  static RegExp regIsPhone = RegExp(r'^([0|\+[1-9]{1,2})?([0-9]{10})$',
      caseSensitive: false, multiLine: false);
  static RegExp regIsPassword2 = RegExp(
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$'); // more than 8 characters, and has 1 lowercase, 1 uppercase, 1 number ,1 special character
  static RegExp regIsPassword = RegExp(
      r'^(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?& ]{8,}$'); // more than 8 characters, and has special character
  static RegExp regIsNumber =
      RegExp(r'^(\d+\.\d+)$|^(\d+)$'); // float number, and >0
  static RegExp name = RegExp(r'[^A-Za-z\s]+');
}

class ViewConstants {
  static const double defaultBorderRadiusBtn = 8;
  static const double defaultBorderRadiusTextInput = 8;
  static const double defaultBorderRadiusHeader = 0;
  static const Color defaultBorderColor = Color(0xFAC7C5C5);
  static final BorderRadius defaultBorderRadius = BorderRadius.circular(16.0);
}
