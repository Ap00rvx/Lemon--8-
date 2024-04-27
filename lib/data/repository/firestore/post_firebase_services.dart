import 'package:brave/data/models/post_model.dart';
import 'package:brave/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PostServices{
  final _firestore = FirebaseFirestore.instance ;
  Future<void> increaseLike(UserModel user , PostModel post )async {
    try {
      final currentLikes = post.likes ;
      currentLikes.add(user.uid);
      print(currentLikes);
      await _firestore.collection('post').doc(post.postId).update({"likes":currentLikes});
    }catch (e){
      print(e.toString()) ;
    }
  }
  Future<void> decreaseLike(UserModel user , PostModel post )async {
    try {
      final currentLikes = post.likes ;
      currentLikes.remove(user.uid);
      print(currentLikes);
      await _firestore.collection('post').doc(post.postId).update({"likes":currentLikes});
    }catch (e){
      print(e.toString()) ;
    }
  }
  Future<void> updateLike(bool isLiked,UserModel user , PostModel post)async{
    if(isLiked){
      await decreaseLike(user, post) ;
    }
    else {
    await increaseLike(user, post);
    }
  }
}