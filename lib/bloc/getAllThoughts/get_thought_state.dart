part of 'get_thought_bloc.dart';

@immutable
abstract class GetThoughtState {}

class GetThoughtInitial extends GetThoughtState {}
class GetThoughtLoading extends GetThoughtState {}
class GetThoughtError extends GetThoughtState {
  final String error  ;

  GetThoughtError({required this.error});
}
class GetThoughtLoaded extends GetThoughtState {
  final List<ThoughtModel> data;

  GetThoughtLoaded({required this.data});
}
