part of 'get_grid_bloc.dart';

@immutable
abstract class GetGridEvent {}
class GetPostsOfProfile extends GetGridEvent{
  final String uid ;

  GetPostsOfProfile({required this.uid});
}