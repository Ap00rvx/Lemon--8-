import 'dart:io';

import 'package:brave/data/models/post_model.dart';
import 'package:brave/data/models/user_model.dart';
import 'package:brave/data/repository/firebase_storage/storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
class AddDetailsPage extends StatefulWidget {
  const AddDetailsPage({super.key , required this.file ,required this.userModel });
  final XFile file ;
  final UserModel userModel ;
  @override
  State<AddDetailsPage> createState() => _AddDetailsPageState();
}
class _AddDetailsPageState extends State<AddDetailsPage> {
  final firebaseFirestore = FirebaseFirestore.instance ;
  bool isImage(XFile xFile) {
    List<String> imageFormats = ['jpg', 'jpeg', 'png'];
    String extension = xFile.path.split('.').last.toLowerCase();
    return imageFormats.contains(extension);
  }
  final _text = TextEditingController() ;
  final _title = TextEditingController( ) ;
  @override
  Widget build(BuildContext context) {
    final file = widget .file ;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Post',style: TextStyle(
          fontFamily: 'mon'
        ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
      SizedBox(
        child: Column(
          children: [
            Card(
              elevation: 1,
              child: Container(
                height: 150,
                decoration: const BoxDecoration(),

                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Visibility(

                      visible: isImage(file),

                      child: Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)
                        ),child: Image.file(File(file.path),width: 150,fit: BoxFit.cover,),
                      ),),
                    SizedBox(
                      width: 200,
                      child: TextField(
                        maxLines: 5,
                        controller: _text,
                        decoration:  const InputDecoration(
                            hintText: 'Add Caption',

                            hintStyle: TextStyle(
                                fontFamily: 'mon'
                            ),
                            border: InputBorder.none
                        ),

                      ),
                    ),

                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                maxLines: 1,
                controller: _title,
                decoration:  const InputDecoration(
                    hintText: 'Add Title',

                    hintStyle: TextStyle(
                        fontFamily: 'mon'
                    ),
                    border: OutlineInputBorder(

                    )
                ),

              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Icon(Icons.date_range_sharp,size: 40,) ,
                  const SizedBox(width: 20,),
                  Text("${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",style: const TextStyle(
                      fontFamily: 'mon'
                  ),)
                ],
              ),
            ),
          ],
        ),
      ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(onPressed: ()async{
              showDialog(context: context, builder: (context){
                return const Center(
                  child: CircularProgressIndicator(),
                );
              });
              try {
                final user = widget.userModel ;
                print("uploading data ");
                final url  = await FirebaseStorageServices().uploadImageToFirebaseStorage(file) ;

                if (url!= null ){
                  print('updating profile ');
                  final id = DateTime.now().millisecondsSinceEpoch ;
                  final postModel = PostModel(title: _title.text , media: isImage(file) ? 'image':'video', imageUrl: url.toString(), username: user.username, userImageUrl: user.imageurl, uid:user.uid, postId:id.toString() , caption:_text.text.toString(), likes: [], comments: [], date: DateTime.now()) ;
                  final post = user.post;
                  post.add(postModel.postId );
                  final usermodel = UserModel(username: user.username, phonenumber: user.phonenumber, uid: user.uid, email: user.email, imageurl: user.imageurl, post: post, profileviews: user.profileviews, thoughts: user.thoughts, friends: user.friends,bio: user.bio);
                  await FirebaseFirestore.instance.collection('user').doc(usermodel.uid).set(usermodel.toJson()) ;

                  await firebaseFirestore.collection('post').doc(id.toString()).set(postModel.toJson()) ;
                }
              }catch(E){
                print(E);
              }
              Navigator.pop(context) ;
              Navigator.pop(context) ;
            },
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(300, 60),
              shape: const RoundedRectangleBorder(

              )
            ), child: Text("Create Post",style: TextStyle(
              fontFamily: 'mon',
              fontSize: 22,
              color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black
            ),),
            ),
          )
        ],
      )
    );
  }
}
