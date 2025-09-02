import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../constant/config.dart';
import '../../utils/shared_preferences_manager.dart';

part 'auth_state.dart';

GetIt sl = GetIt.instance;

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState());

  void login({
    String? username,
    String? password,
  }) async {
    final spManager = GetIt.instance.get<SharedPreferencesManager>();
    await spManager.putString(AppConfig.SL_USERNAME, username ?? "");
    await spManager.putString(AppConfig.SL_PASSWORD, password ?? "");
    emit(AuthState(isLogin: true));
  }

  Future<void> logout() async {
    final spManager = GetIt.instance.get<SharedPreferencesManager>();

    spManager.remove(AppConfig.accessTokenKey);
    spManager.remove(AppConfig.idTokenKey);
    await spManager.remove(AppConfig.SL_USERNAME);
    await spManager.remove(AppConfig.SL_PASSWORD);
    emit(AuthState(isLogin: false));
  }

  void checkLogin() async {
    final isExpired = await isTokenExpired();
    if (isExpired) {
      logout();
    } else {
      login();
    }
  }

  Future<bool> isTokenExpired() async {
    final spManager = GetIt.instance.get<SharedPreferencesManager>();

    final username = spManager.getString(AppConfig.SL_USERNAME);
    final password = spManager.getString(AppConfig.SL_PASSWORD);
    final accessToken = spManager.getString(AppConfig.accessTokenKey) ?? "";
    // if (accessToken.isEmpty) {
    //   return true;
    // }
    if (username != null && password != null) {
      return false;
    }
    return true;
  }

  Future<void> deleteAccount() async {
    // await sl.get<UserRepository>().deleteAccount();
    // logout();
  }
}
