part of 'comments_bloc.dart';

@immutable
abstract class CommentsEvent {}

class GetCommentsOfPostEvent extends CommentsEvent{
  final PostModel post ;

  GetCommentsOfPostEvent({required this.post});

}
