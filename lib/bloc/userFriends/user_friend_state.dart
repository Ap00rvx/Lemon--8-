part of 'user_friend_bloc.dart';

@immutable
abstract class UserFriendState {}

class UserFriendInitial extends UserFriendState {}
class UserFriendsLoaded extends UserFriendState{
  final List<String>friends ;

  UserFriendsLoaded({required this.friends});
}
class UserFriendsLoading extends UserFriendState{}
class UserFriendsError extends UserFriendState{
}