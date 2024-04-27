part of 'comments_bloc.dart';

@immutable
abstract class CommentsState {}

class CommentsInitial extends CommentsState {}
class CommentsLoadingState extends CommentsState {}
class CommentsLoadedState extends CommentsState {
  final List<CommentModel> comments ;

  CommentsLoadedState({required this.comments});
}
class CommentsErrorState extends CommentsState{
  final String err ;

  CommentsErrorState({required this.err});

}