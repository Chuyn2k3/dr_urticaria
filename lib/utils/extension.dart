import 'package:intl/intl.dart';

extension CheckNullValue on int? {
  int orEmpty() {
    return this ?? 0;
  }
}

extension GetTime on String? {
  int get getOnlyNumber {
    if (this == null) {
      return 0;
    }
    RegExp regex = RegExp(r'\d+');
    Iterable<Match> matches = regex.allMatches(this!);
    String numbersOnly = matches.map((match) => match.group(0)).join();
    int result = int.parse(numbersOnly);
    return result;
  }

  bool checkVersion(String oldVersion) {
    if (this == null) {
      return false;
    }

    List<int> formatList(String value) {
      List<int> list = value.split('.').map((e) => e.getOnlyNumber).toList();
      if (list.length > 3) {
        return list.getRange(0, 3).toList();
      }
      if (list.length < 3) {
        list = [...list, ...List.filled(3 - list.length, 0)];
      }
      return list;
    }

    List<int> v = formatList(this!);
    List<int> vFix = formatList(oldVersion);

    for (int i = 0; i < v.length; i++) {
      if (v[i] == vFix[i]) {
        continue;
      } else {
        if (v[i] > vFix[i]) {
          return true;
        }
        if (v[i] < vFix[i]) {
          return false;
        }
      }
    }
    return false;
  }

  String get revert {
    return this?.split('').reversed.join('') ?? '';
  }

  String formatTime({String format = "HH:mm dd/MM/yyyy"}) {
    if (this == null) return "_";
    var dateValue =
        DateFormat("yyyy-MM-ddTHH:mm:ssZ").parseUTC(this!).toLocal();
    String formattedDate = DateFormat(format).format(dateValue);

    return formattedDate;
  }

  DateTime? toDateLocal({
    String dateStringFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ",
  }) {
    if (this == null) return null;
    var dateValue = DateFormat(dateStringFormat).parseUTC(this!).toLocal();
    return dateValue;
  }

  String formatDate(
      {String formatIn = "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
      String formatOut = "HH:mm dd/MM/yyyy"}) {
    if (this == null) return "_";
    var dateValue = DateFormat(formatIn).parseUTC(this!).toLocal();
    String formattedDate = DateFormat(formatOut).format(dateValue);
    return formattedDate;
  }

  String formatDateTime({String format = "yyyy-MM-dd"}) {
    if (this == null) return "";
    var dateValue =
        DateFormat("yyyy-MM-ddTHH:mm:ssZ").parseUTC(this!).toLocal();
    String formattedDate = DateFormat(format).format(dateValue);

    return formattedDate;
  }

  String formatTimeStamp() {
    if (this == null) return "";
    String dateTime = '$this' 'T00:00:00Z';
    return dateTime.toString();
  }
}

extension GetCurrency on double? {
  String formatCurrency() {
    return NumberFormat("#,##0", "en_US").format(this);
  }

  String? convertKUnit() {
    if (this == null) {
      return null;
    }
    double value = this! / 1000;
    return value.toStringAsFixed(1);
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$")
        .hasMatch(this);
  }
}

extension PhoneValidator on String {
  bool isValidPhone() {
    return RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)').hasMatch(this);
  }

  String? get getYoutubeThumbnail {
    final Uri? uri = Uri.tryParse(this..trim());
    if (uri == null) {
      return null;
    }

    return 'https://img.youtube.com/vi/${uri.queryParameters['v']}/0.jpg';
  }
}

extension ConvertLength on String {
  List<int> get convertLength {
    final length = this.length;

    return [length ~/ 255, length % 255];
  }
}

extension Hardcode on String {
  String get hardcode => this;
}

/// Đơn vị chuyển đổi sẵn là km
extension FormatOdoAsKm on double? {
  String get formatOdoAsKm {
    if (this == null || this == 0) {
      return 0.toString();
    }
    var odoAsKm = this!;
    return odoAsKm.formatDisplayDouble(
      minimumFractionDigits: 2,
      maximumFractionDigits: 2,
    );
  }

  String get formatOdoAsKmWithUnit {
    return "$formatOdoAsKm Km";
  }

  String get formatOdoAsKmRoundWithUnit {
    return "$formatOdoAsKmRound Km";
  }

  String get formatOdoAsKmRound {
    if (this == null || this == 0) {
      return 0.toString();
    }
    var odoAsKm = this!;
    return odoAsKm.formatDisplayDouble(
      minimumFractionDigits: 0,
      maximumFractionDigits: 0,
    );
  }
}

/// Đơn vị chuyển đổi từ meter sang km
extension FormatOdoAsMeter on double? {
  String get formatOdo {
    var result = (this ?? 0) / 1000;
    return result.formatOdoAsKm;
  }

  String get formatOdoMeterToKm {
    if (this == null || this == 0) {
      return 0.toString();
    }
    var odoAsKm = this! / 1000;
    return odoAsKm.formatDisplayDouble(
      minimumFractionDigits: 2,
      maximumFractionDigits: 2,
    );
  }

  // Đổi từ meter sang km
  String get formatOdoMeterToKmRound {
    if (this == null || this == 0) {
      return 0.toString();
    }
    var odoAsKm = this! / 1000;
    return odoAsKm.formatDisplayDouble(
      minimumFractionDigits: 0,
      maximumFractionDigits: 0,
    );
  }

  // Đổi tu meter sang km
  String get formatOdoMeterToKmWithUnit {
    return "$formatOdoMeterToKm Km";
  }

  String get formatOdoMeterToKmRoundWithUnit {
    return "$formatOdoMeterToKmRound Km";
  }
}

extension FormatOdoV2 on num? {
  String get formatOdoWithDisplayMeterOrKm {
    if (this == null) return "";
    if (this! < 1000) {
      return "${formatDisplayDouble(
        minimumFractionDigits: 2,
        maximumFractionDigits: 2,
      )} m";
    }
    return "${this?.toDouble().formatOdo} Km";
  }

  /// Đối với giá trị range trong reportedState thì nó đang là giá trị Km
  String get formatDistanceRemaining {
    if (this == null) {
      return "0 Km";
    }
    return "${this!.formatDisplayDouble(
      minimumFractionDigits: 0,
      maximumFractionDigits: 0,
    )} Km";
  }
}

extension FormatDisplayNum on num? {
  String formatDisplayDouble({
    int? minimumFractionDigits,
    int? maximumFractionDigits,
  }) {
    final formatter = NumberFormat.decimalPatternDigits();
    formatter.maximumFractionDigits = maximumFractionDigits ?? 2;
    formatter.minimumFractionDigits = minimumFractionDigits ?? 0;

    return formatter.format(this);
  }
}

extension FormatOdoMax on double? {
  String get formatOdoMax {
    String inString = this!.toStringAsFixed(0);
    String formattedNumber =
        NumberFormat("#,###", "en_US").format(int.parse(inString));
    return formattedNumber;
  }
}

extension DurationExtensions on Duration {
  /// Converts the duration into a readable string
  /// 05:15
  String toHoursMinutes() {
    String twoDigitMinutes = _toTwoDigits(inMinutes.remainder(60));
    return "${_toTwoDigits(inHours)}:$twoDigitMinutes";
  }

  /// Converts the duration into a readable string
  /// 05:15:35
  String toHoursMinutesSeconds() {
    String twoDigitMinutes = _toTwoDigits(inMinutes.remainder(60));
    String twoDigitSeconds = _toTwoDigits(inSeconds.remainder(60));
    if (inHours != 0) {
      return "${_toTwoDigits(inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    } else {
      return "$twoDigitMinutes:$twoDigitSeconds";
    }
  }

  String _toTwoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }
}

extension ConvertSecondsToTime on int {
  String get formatToTime {
    return "${(this ~/ 60).toString().padLeft(2, '0')}:${(this % 60).toString().padLeft(2, '0')}";
  }
}

extension ShortNumberDisplayDoubleX on num {
  String formatNumber({
    int? minimumFractionDigits,
    int? maximumFractionDigits,
  }) {
    final formatter = NumberFormat.decimalPatternDigits();
    formatter.maximumFractionDigits = minimumFractionDigits ?? 2;
    formatter.minimumFractionDigits = maximumFractionDigits ?? 2;
    final number = this;
    var numAfterRound = number;

    if (number.abs() >= 1e12) {
      numAfterRound = number / 1e12;
      final numAfterFormat = formatter.format(numAfterRound);
      return "${numAfterFormat}B"; // Tỷ
    } else if (number.abs() >= 1e9) {
      numAfterRound = number / 1e9;
      final numAfterFormat = formatter.format(numAfterRound);
      return "${numAfterFormat}B"; // Tỷ
    } else if (number.abs() >= 1e6) {
      numAfterRound = number / 1e6;
      final numAfterFormat = formatter.format(numAfterRound);
      return "${numAfterFormat}M"; // Triệu
    } else if (number.abs() >= 1e3) {
      numAfterRound = number / 1e3;
      final numAfterFormat = formatter.format(numAfterRound);
      return "${numAfterFormat}K"; // Nghìn
    } else {
      return formatter.format(number); // Dưới 1000 không cần định dạng
    }
  }
}

extension DateTimeString on DateTime {
  String formatString({String format = "yyyy-MM-dd"}) {
    String formattedDate = DateFormat(format).format(this);
    return formattedDate;
  }

  String formatTimeStamp() {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    return '${dateFormat.format(this)}T00:00:00Z';
  }

  String formatStartTimeStampGMT(
      {String format = 'yyyy-MM-dd\'T\'HH:mm:ss\'Z\''}) {
    return DateTime.parse(formatTimeStamp())
        .subtract(DateTime.now().timeZoneOffset)
        .formatString(format: format);
  }

  String formatTimeStampEndDay() {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    return '${dateFormat.format(this)}T24:00:00Z';
  }

  String formatEndTimeStampGMT(
      {String format = 'yyyy-MM-dd\'T\'HH:mm:ss\'Z\''}) {
    return DateTime.parse(formatTimeStampEndDay())
        .subtract(DateTime.now().timeZoneOffset)
        .formatString(format: format);
  }

  String get formattedDateTimeISO8601 =>
      "${DateFormat("yyyy-MM-ddTHH:mm:ss").format(this)}.000Z";

  bool isSameDay(DateTime date2) {
    return year == date2.year && month == date2.month && day == date2.day;
  }
}
