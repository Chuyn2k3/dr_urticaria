import 'package:dr_urticaria/core/global_error_handle/global_error_handle.dart';
import 'package:dr_urticaria/core/repositories/user_repository.dart';
import 'package:dr_urticaria/di/locator.dart';
import 'package:dr_urticaria/models/user/credential_model.dart';
import 'package:dr_urticaria/utils/validator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginAppState> {
  LoginCubit() : super(LoginAppInitialState());
  final UserRepository _userRepository = serviceLocator<UserRepository>();

  Future<void> handleLogin({
    required String phone,
    required String password,
  }) async {
    // final errorError = Validator.validatePhoneNumber(phone);
    // if (errorError != null) {
    //   emit(LoginErrorState(error: errorError));
    //   return;
    // }
    // final errorPassWord = Validator.validatePassword(
    //   password: password,
    // );
    // if (errorPassWord != null) {
    //   emit(LoginErrorState(error: errorPassWord));
    //   return;
    // }
    try {
      emit(LoginInLoadingState());
      final result = await _userRepository.login(phone, password);
      emit(
          LoggedInState(credential: result.data ?? CredentialModel(token: "")));
    } catch (e) {
      final message = GlobalErrorHandle(e).errorMessage();
      final errorCode = GlobalErrorHandle(e).errorCode;
      if (errorCode == "401") {
        emit(const LoginErrorState(
            error: "Tài khoản hoặc mật khẩu không chính xác"));
      } else {
        emit(LoginErrorState(error: message));
      }
    }
  }
}
