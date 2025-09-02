import 'package:dr_urticaria/models/profile/model/user_info_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/global_error_handle/global_error_handle.dart';
import '../../core/repositories/user_repository.dart';
import '../../di/locator.dart';

part 'profile_state.dart';

class ProfileUserCubit extends Cubit<ProfileUserState> {
  ProfileUserCubit() : super(ProfileUserInitialState());
  final UserRepository _userRepository = serviceLocator();

  Future<void> getProfile() async {
    try {
      emit(ProfileUserLoadingState());
      final result = await _userRepository.getProfile();
      final data = result.data;
      if (data != null) {
        emit(ProfileUserLoadedState(user: data));
      } else {
        emit(ProfileUserErrorState(error: "Không lấy được dữ liệu cá nhân"));
      }
    } catch (e) {
      final message = GlobalErrorHandle(e).errorMessage();
      emit(ProfileUserErrorState(error: message));
    }
  }

  Future<void> refreshProfile() async {
    try {
      emit(ProfileUserInitialState());
      final result = await _userRepository.getProfile();
      final data = result.data;
      if (data != null) {
        emit(ProfileUserLoadedState(user: data));
      } else {
        emit(ProfileUserErrorState(error: "Không lấy được dữ liệu cá nhân"));
      }
    } catch (e) {
      final message = GlobalErrorHandle(e).errorMessage();
      emit(ProfileUserErrorState(error: message));
    }
  }

  UserInfoModel? inforUser() {
    if (state is ProfileUserLoadedState) {
      return (state as ProfileUserLoadedState).user;
    }
    return null;
  }
}
