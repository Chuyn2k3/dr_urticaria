import 'package:dio/dio.dart';
import 'package:dr_urticaria/core/base/base_response.dart';
import 'package:dr_urticaria/models/user/credential_model.dart';
import 'package:retrofit/retrofit.dart';

part 'user_service.g.dart';

@RestApi()
abstract class UserServices {
  factory UserServices(Dio dio, {String baseUrl}) = _UserServices;
  @POST("/api/v1/auth/staff/login")
  Future<BaseResponse<CredentialModel>> loginUser(
      @Body() Map<String, dynamic> request);

  // @GET("/api/v1/patients/owner/me")
  // Future<BaseResponse<UserInfoModel>> getProfile();
}
