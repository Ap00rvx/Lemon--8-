part of 'post_bloc.dart';

@immutable
abstract class PostState {}

class PostInitial extends PostState {}
class PostLoading extends PostState {}
class PostLoaded extends PostState {
  final List<PostModel> postList ;

  PostLoaded({required this.postList});
}
class PostErrorState extends PostState{
  final String error ;

  PostErrorState({required this.error});

}


