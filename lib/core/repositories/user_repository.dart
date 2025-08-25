import 'package:dr_urticaria/constant/config.dart';
import 'package:dr_urticaria/core/base/base_response.dart';
import 'package:dr_urticaria/core/services/user_service.dart';
import 'package:dr_urticaria/models/user/credential_model.dart';
import 'package:dr_urticaria/utils/shared_preferences_manager.dart';
import 'package:get_it/get_it.dart';

abstract class UserRepository {
  Future<BaseResponse<CredentialModel>> login(String phone, String password);

  //Future<BaseResponse<UserInfoModel>> getProfile();
}

class UserRepositoryImpl implements UserRepository {
  final UserServices userServices;
  const UserRepositoryImpl({required this.userServices});

  @override
  Future<BaseResponse<CredentialModel>> login(
      String phone, String password) async {
    try {
      final request = {
        'username': phone,
        'password': password,
      };
      final result = await userServices.loginUser(request);
      GetIt.instance
          .get<SharedPreferencesManager>()
          .putString(AppConfig.accessTokenKey, result.data?.token ?? "");

      return result;
    } catch (e) {
      rethrow;
    }
  }

  // @override
  // Future<BaseResponse<UserInfoModel>> getProfile() async {
  //   try {
  //     final result = await userServices.getProfile();
  //     return result;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
}
