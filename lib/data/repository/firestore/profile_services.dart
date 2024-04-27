import 'dart:io';
import 'package:brave/data/models/post_model.dart';
import 'package:brave/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
class ProfileServices {
  final _firestore = FirebaseFirestore.instance ;
  Future<void> updateProfileView(String uid )async {
    try {
      final doc = await FirebaseFirestore.instance.collection('user').doc(uid).get(); 
      final usermodel = UserModel.fromJson(doc.data()!);
      int  view = usermodel.profileviews ;
      view = view + 1 ; 
      await  FirebaseFirestore.instance.collection('user').doc(uid).update({"profileviews": view});
      if (kDebugMode) {
        print("view updated ");
      }
    }
    catch (E){
    }
  }
  Future<String> updateProfilePhoto(XFile selectedImage , UserModel userModel)async {
    final storage = FirebaseStorage.instance ;
    try {
      Reference reference =
      storage.ref().child('uploads/${userModel.uid}.jpg');

      final  uploadTask = reference.putFile(File(selectedImage.path));

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String downloadURL = await taskSnapshot.ref.getDownloadURL();
      return downloadURL ;
        } catch (error) {
      return '';
    }
  }
  Future<void> updateUserDetailsinPost(UserModel usermodel )async {
    final postAddress = usermodel.post ; 
    final postCollections = await FirebaseFirestore.instance.collection('post').get();
    final allPostData  = postCollections.docs;
    for (String add in postAddress){
      for ( var postData in allPostData){
        final postmodel = PostModel.fromJson(postData.data());
          if (add == postmodel.postId){
            final newPostmodel = PostModel(title: postmodel.title, media: postmodel.media, imageUrl: postmodel.imageUrl, username: usermodel.username, userImageUrl: usermodel.imageurl, uid: postmodel.uid, postId: postmodel.postId, caption: postmodel.caption, likes: postmodel.likes, comments: postmodel.comments, date: postmodel.date) ;
            await FirebaseFirestore.instance.collection('post').doc(newPostmodel.postId).set(newPostmodel.toJson());
          }
      }
    }
  }
  Future<void> updateUserDetails(UserModel usermodel)async{
    try {
      final firestore = FirebaseFirestore.instance.collection('user');
      await firestore.doc(usermodel.uid).set(usermodel.toJson());
    }
    catch(E){
      print(E.toString());
    }
  }
  Future<List<String>>getUserFriends(String uid)async{
    try {
      final docSnapshot = await _firestore.collection('user').doc(uid).get();
      final json = docSnapshot.data()!;
      final usermodel = UserModel.fromJson(json);
      final friends = usermodel.friends ;
      return friends ;
    }
    catch (e){
      return [];
    }
  }
  Future<void>friendRequestAccepted(String uid, String reqId)async{
    final _firebase = FirebaseFirestore.instance;
    final usercollection = await _firebase.collection('user').doc(uid).get();
    final friends =usercollection.get('friends') as List ;
    friends.add(reqId) ;
    await _firebase.collection('user').doc(uid).update({"friends":friends});
    final requsercollection = await _firebase.collection('user').doc(reqId).get();
    final reqfriends =usercollection.get('friends') as List ;
    reqfriends.add(uid) ;
    await _firebase.collection('user').doc(reqId).update({"friends":reqfriends});

    final reqCollection = await _firestore.collection('request').doc(uid).get();
    final reqs = reqCollection.get('requests') as List;
    reqs.remove(reqId);
    await _firebase.collection('request').doc(uid).update({"requests": reqs});
    print("updated friend request");
   
  }
  Future<void> createNewFriendRequest(String user , String person )async {
    print(user);
    final collection = _firestore.collection('request');
    final doc = await collection.doc(user).get();
    if(doc.exists){
      final  data = doc.data()!;
      final friends = data['requests'] as List<dynamic>;
      friends.add(person);

      await collection.doc(user).update({'requests':friends.toSet().toList()}) ;
      print('request created '); 
    }
    else {
      await collection.doc(user).set({'requests': [person]});
      print('new request added ');
    }

  }
  Future<bool> isUserFriend(String user , String person)async{
    final friends = await getUserFriends(person );
    if (friends.contains(user)){
      return true;
    }
    else {
      return false;
    }
  }
}