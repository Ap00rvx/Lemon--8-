part of 'get_grid_bloc.dart';

@immutable
abstract class GetGridState {}

class GetGridInitial extends GetGridState {}
class GetGridLoading extends GetGridState{}
class GetGridError extends GetGridState{
  final String error ;

  GetGridError({required this.error});
}
class GetGridLoaded extends GetGridState{
  final List<PostModel> posts  ;

  GetGridLoaded({required this.posts});
}