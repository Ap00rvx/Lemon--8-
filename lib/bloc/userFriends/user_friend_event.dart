part of 'user_friend_bloc.dart';

@immutable
abstract class UserFriendEvent {}
final class GetUserFriends extends UserFriendEvent{
  final  String useruid;


  GetUserFriends({required this.useruid});


}