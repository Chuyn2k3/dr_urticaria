import 'package:dr_urticaria/utils/extension.dart';

class Validator {
  static String? validatePassword(
      {required String password, int minLength = 4}) {
    if (password.isEmpty) {
      return "Mật khẩu không được để trống";
    }
    if (password.length < minLength) {
      return "Độ dài mật khẩu không được ít hơn $minLength ký tự";
    }
    return null;
  }

  // static String? validateNumber(String value) {
  //   if (value.isEmpty) {
  //     return S.current.validate_number_empty;
  //   } else if (!RegExp(r'^-?[0-9]+$').hasMatch(value)) {
  //     return S.current.enter_a_valid_number;
  //   } else {
  //     return null;
  //   }
  // }

  // static String? validateDouble(String value) {
  //   if (value.isEmpty) {
  //     return S.current.validate_double_empty;
  //   }
  //   final n = double.tryParse(value);
  //   if (n == null) {
  //     return S.current.validate_double;
  //   }
  //   return null;
  // }

  static String? validateString({required String str, required String name}) {
    if (str.isEmpty) {
      return "$name không hợp lệ";
    }
    return null;
  }

  static String? validateEmail(String str) {
    if (str.isValidEmail()) {
      return null;
    }

    return "Email không hợp lệ";
  }

  static String? validatePhoneNumber(String value) {
    Pattern pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regex = RegExp(pattern.toString());
    if (!regex.hasMatch(value)) {
      return "Số điện thoại không hợp lệ";
    } else {
      return null;
    }
  }

  static String? checkEmpty(dynamic str) {
    if (str.isEmpty) {
      return '_';
    }
    return str.toString();
  }
}
