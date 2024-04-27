part of 'friend_request_bloc.dart';

@immutable
abstract class FriendRequestEvent {}
class GetFriendRequestEvent extends FriendRequestEvent {
  final String userId;

  GetFriendRequestEvent({required this.userId});
}