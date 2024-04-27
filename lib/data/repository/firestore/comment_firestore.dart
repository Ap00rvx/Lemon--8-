import 'package:brave/data/models/comment_model.dart';
import 'package:brave/data/models/post_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentServices{
  
  
  final _firestore = FirebaseFirestore.instance ; 
  Future<void> addComment(PostModel postModel  , CommentModel commentModel )async {
    final collection = _firestore.collection('comments') ; 
    try {
      var comments = postModel.comments ;
      comments.add(commentModel.id) ;
      await _firestore.collection('post').doc(postModel.postId).update({"comments":comments}) ;
      await collection.doc(commentModel.id).set(commentModel.toJson()); 
      print("comment Added successFully") ; 
    }catch (E){
      print(E.toString()) ;
    }
  }
}