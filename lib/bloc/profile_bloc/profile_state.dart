part of 'profile_bloc.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}
class ProfileLoadingState extends ProfileState {}
class ProfileLoadedState extends ProfileState {
  final UserModel userModel ;

  ProfileLoadedState({required this.userModel});

}
final class ProfileErrorState extends ProfileState{
  final String error ;

  ProfileErrorState({required this.error});

}
