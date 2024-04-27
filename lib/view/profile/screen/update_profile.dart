
import 'dart:io';

import 'package:brave/data/models/user_model.dart';
import 'package:brave/data/repository/firestore/profile_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key ,required this.usermodel });
  final UserModel usermodel ;
  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _username =  TextEditingController() ;
  final _phone =  TextEditingController();
  final _bio =  TextEditingController();

  XFile? image;
  @override
  Widget build(BuildContext context) {
  final usermodel = widget.usermodel ;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit profile',
          style: TextStyle(fontFamily: 'mon', fontSize: 22),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
           Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               GestureDetector(
                 onTap: ()async{
                  image = await ImagePicker().pickImage(source: ImageSource.gallery);
                  setState(() {});
                 },
                 child: CircleAvatar(
                   radius: 80,
                   backgroundImage: image == null ? null : FileImage(File(image!.path)),
                   backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.grey.shade300: Colors.grey.shade200,
                   foregroundColor: Colors.black54,
                   child: image != null ? null  : const Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Icon(Icons.add_a_photo_rounded,size: 50,),
                       Text('change profile photo',style: TextStyle(
                         fontFamily: 'mon',
                         fontSize: 10
                       ),)
                     ],
                   ),
                 ),
               ),

             ],
           ),
            const SizedBox(
              height: 15,
            ),
            Visibility(visible: image != null ,child: ElevatedButton(onPressed: ()async {
              final newImage  = await ImagePicker().pickImage(source: ImageSource.gallery);
              setState(() {
                if(newImage != null){
                  image = newImage ; 
                }
              });
            }, child: Text('Choose Another'))),
            const SizedBox(
              height: 15,
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Change username ',
                            style: TextStyle(
                                fontFamily: 'mon',
                                color: Colors.grey.withOpacity(0.8),
                                fontSize: 10)),

                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      child: TextFormField(
                        controller: _username,
                        maxLength: 35,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            suffixIcon: const Icon(Icons.person),
                            hintText: usermodel.username,
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
            const SizedBox(
              height: 10,
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Update phone number ',
                            style: TextStyle(
                                fontFamily: 'mon',
                                color: Colors.grey.withOpacity(0.8),
                                fontSize: 10)),
                        Text('(only visible to you)',
                            style: TextStyle(
                                fontFamily: 'mon',
                                color: Colors.grey.withOpacity(0.8),
                                fontSize: 10))
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                   SizedBox(
                     child: TextFormField(
                       controller: _phone,
                       maxLength: 10,
                       keyboardType: TextInputType.phone,
                       decoration: InputDecoration(
                         suffixIcon: const Icon(Icons.phone),
                         hintText: usermodel.phonenumber == 'not-provided' ? 'Add phone number':usermodel.phonenumber,
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
            const SizedBox(
              height: 10,
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Change Bio',
                            style: TextStyle(
                                fontFamily: 'mon',
                                color: Colors.grey.withOpacity(0.8),
                                fontSize: 10)),

                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      child: TextFormField(
                        controller: _bio,
                        maxLength: 300,
                        maxLines: 6,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            suffixIcon: const Icon(Icons.description),
                            hintText: usermodel.bio,
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
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(onPressed: ()async {

                  try {
                    String phoneNumber =usermodel.phonenumber.toString();
                    String newImageurl =usermodel.imageurl.toString();
                    String bio = usermodel.bio.toString();
                    String username = usermodel.username.toString() ;
                    if(image != null) {
                       newImageurl = await ProfileServices()
                          .updateProfilePhoto(image!, usermodel);
                    }
                    if(_phone.text.length == 10 ) {
                      phoneNumber =  "+91"+_phone.text.toString();
                      if(_username.text.isNotEmpty){
                        username = _username.text ;
                      }
                      if(_bio.text.isNotEmpty){
                        bio = _bio.text ;
                      }

                      final newUsermodel  = UserModel(username: username, phonenumber: phoneNumber, uid: usermodel.uid, email: usermodel.email, imageurl: newImageurl, post: usermodel.post, profileviews: usermodel.profileviews, thoughts: usermodel.thoughts, friends: usermodel.friends,bio: bio);
                      await ProfileServices().updateUserDetails(newUsermodel).then((value) {
                        Fluttertoast.showToast(msg: 'Profile Updated');
                      });
                      await ProfileServices().updateUserDetailsinPost(newUsermodel);

                    }
                    else if (_phone.text.isEmpty){
                      if(_username.text.isNotEmpty){
                        username = _username.text ;
                      }
                      if(_bio.text.isNotEmpty){
                        bio = _bio.text ;
                      }

                      final newUsermodel  = UserModel(username: username, phonenumber: phoneNumber, uid: usermodel.uid, email: usermodel.email, imageurl: newImageurl, post: usermodel.post, profileviews: usermodel.profileviews, thoughts: usermodel.thoughts, friends: usermodel.friends,bio: bio);
                      await ProfileServices().updateUserDetailsinPost(newUsermodel);
                      await ProfileServices().updateUserDetails(newUsermodel).then((value) {
                        Fluttertoast.showToast(msg: 'Profile Updated');
                      });
                    }
                    else {
                      Fluttertoast.showToast(msg: 'Phone number must have only 10 digits');
                    }



                  }
                  catch (e){
                  Fluttertoast.showToast(msg: e.toString());
                  }

                },
                    style: ElevatedButton.styleFrom(
                  fixedSize: Size(200, 50),
                  shape: RoundedRectangleBorder(),
                  backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.transparent : Colors.white
                ), child: Text('Submit', style: TextStyle(
                fontFamily: 'mon',
                    color:  MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black,
                    fontSize: 20))),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text("Secure | Save | Smooth ", style: TextStyle(
                fontFamily: 'mon',
                color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black,
                fontSize: 10)),
        const SizedBox(
        height: 10,

      ),
          ],
        ),
      ),
    );
  }
}
