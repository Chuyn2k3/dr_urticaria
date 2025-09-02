part of 'profile_cubit.dart';

abstract class ProfileUserState extends Equatable {
  const ProfileUserState();
}

class ProfileUserInitialState extends ProfileUserState {
  @override
  List<Object> get props => [];
}

class ProfileUserLoadingState extends ProfileUserState {
  @override
  List<Object> get props => [];
}

class ProfileUserLoadedState extends ProfileUserState {
  final UserInfoModel user;
  const ProfileUserLoadedState({
    required this.user,
  });

  @override
  List<Object> get props => [user];
}

class ProfileUserErrorState extends ProfileUserState {
  final String error;
  const ProfileUserErrorState({required this.error});

  @override
  List<Object> get props => [error];
}
