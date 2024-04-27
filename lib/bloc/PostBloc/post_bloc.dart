
import 'package:bloc/bloc.dart';
import 'package:brave/data/models/post_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc() : super(PostInitial()) {
    on<GetPostEvent>((event, emit) async {
      emit(PostLoading()) ;
      try {
        List<PostModel> posts=[];
        final queryData = await FirebaseFirestore.instance.collection('post').get() ;

        for(var doc in queryData.docs ){

          final json = doc.data() ;
          final postModel  = PostModel.fromJson(json) ;
          posts.add(postModel) ;
        }

        emit(PostLoaded(postList: posts)) ;

      }
      catch (e){
        emit(PostErrorState(error: e.toString()));
      }
    });
  }
}
