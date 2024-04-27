

import 'package:bloc/bloc.dart';
import 'package:brave/data/models/comment_model.dart';
import 'package:brave/data/models/post_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'comments_event.dart';
part 'comments_state.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  CommentsBloc() : super(CommentsInitial()) {
    on<GetCommentsOfPostEvent>((event, emit) async {
      emit(CommentsLoadingState()) ;
      final _firestore = FirebaseFirestore.instance;
      try {
        List<CommentModel> comments = [];
        final commentAddresses = event.post.comments ;

        final allCommentsDocs = await _firestore.collection('comments').get() ;
        for(var  commentDoc in allCommentsDocs.docs){
          final json = commentDoc.data();
          final commentModel = CommentModel.fromJson(json);
          if(commentAddresses.contains(commentModel.id)) {
            comments.add(commentModel);
          }
        }
        emit(CommentsLoadedState(comments: comments)) ;
      }catch (E){
        print(E.toString());
        emit(CommentsErrorState(err: E.toString())); }
    });
  }
}
