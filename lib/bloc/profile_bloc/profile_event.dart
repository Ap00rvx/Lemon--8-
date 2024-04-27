part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent {}
class GetUserProfilePageEvent extends ProfileEvent{
  final String uid ;

  GetUserProfilePageEvent({required this.uid});
}