import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:brave/data/models/post_model.dart';
import 'package:brave/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'get_grid_event.dart';
part 'get_grid_state.dart';

class GetGridBloc extends Bloc<GetGridEvent, GetGridState> {
  GetGridBloc() : super(GetGridInitial()) {
    on<GetPostsOfProfile>((event, emit) async {
      emit(GetGridLoading());
      try {
        final uid = event.uid;
        final userDocument = await FirebaseFirestore.instance.collection('user').doc(uid).get();
        final json  = userDocument.data()!;
        final usermodel =UserModel.fromJson(json);
        final postAdds= usermodel.post;
        List<PostModel> posts =[];
        final postDocuments = await FirebaseFirestore.instance.collection('post').get();
        final postDocumentsData = postDocuments.docs ;
        for(String postid  in postAdds){
          for(var doc in postDocumentsData ){

            final postmodel = PostModel.fromJson(doc.data()) ;
            if (postmodel.postId == postid){
              print(postmodel.title) ;
              posts.add(postmodel) ;
            }
          }
        }
        emit(GetGridLoaded(posts: posts)) ;
      }
       catch (e){
        emit(GetGridError(error: 'Something went wrong')) ;
       }
    });
  }
}
