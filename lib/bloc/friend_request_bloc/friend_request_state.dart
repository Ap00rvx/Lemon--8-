part of 'friend_request_bloc.dart';

@immutable
abstract class FriendRequestState {}

class FriendRequestInitial extends FriendRequestState {}
class FriendRequestLoaded extends FriendRequestState {
  final List<UserModel> requests ;

  FriendRequestLoaded({required this.requests});
}
class FriendRequestLoading extends FriendRequestState {}
class FriendRequestError extends FriendRequestState {
  final String error ;

  FriendRequestError({required this.error});

}