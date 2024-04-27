import 'dart:io';

import 'package:brave/common/pageTransition/page_transition.dart';
import 'package:brave/data/models/user_model.dart';
import 'package:brave/data/repository/firestore/firestore.dart';
import 'package:brave/view/home/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class GetUserDetailsPage extends StatefulWidget {
  const GetUserDetailsPage(
      {super.key, required this.email, required this.password});
  final String email;
  final String password;

  @override
  State<GetUserDetailsPage> createState() => _GetUserDetailsPageState();
}

class _GetUserDetailsPageState extends State<GetUserDetailsPage>
{
  bool loading = false ;
  Future<String> uploadFile(File file, String name) async {
    setState(() {
      loading  = true ;
    });
    print('upload file called');
    String url = '';
    String filename = name;
    final firebaseStorageRef =
    FirebaseStorage.instance.ref().child('uploads/$filename');
    final upload = firebaseStorageRef.putFile(file);
    final task = await upload.whenComplete(() => null);
    task.ref.getDownloadURL().then((value) {
      url = value.toString();
      setState(() {
        loading = false ;
        imgUrl = url;
      });
      print(imgUrl);
    });
    return url;
  }

  Future<File> uploadImage() async {
    XFile? image;
    ImagePicker()
        .pickImage(
        source: ImageSource.gallery,
        maxHeight: 512,
        maxWidth: 512,
        imageQuality: 75)
        .then((value) {
      setState(() {
        uploadFile(File(value!.path), value.name);
        print('image pciked');
      });
    });
    return File(image!.path);
  }
  final _phone  =  TextEditingController();
  String imgUrl='';
  bool _c = false ;
  final _username  = TextEditingController();
  final GlobalKey key = GlobalKey() ;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width ;

    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
          height: MediaQuery.sizeOf(context).height,
          width: width,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.black, Colors.black54, Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter),
              image: DecorationImage(
                  image: AssetImage('assets/images/bg2.jpg'),
                  fit: BoxFit.cover)),
          child: Stack(
            children: [
              Container(
                  width: width,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.black,
                      Colors.black54,
                      Colors.transparent
                    ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                  )),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end  ,
                  children: [

                    const SizedBox(
                      height: 25,
                    ),
                    GestureDetector(
                      onTap: ()async {
                        await uploadImage() ;
                      },
                      child: CircleAvatar(
                          backgroundColor: Colors.blueAccent.withOpacity(0.8),
                          radius: 100,
                          backgroundImage: imgUrl == ''
                              ? null
                              : NetworkImage(imgUrl),
                          child:  loading == true ? Center(child: CircularProgressIndicator(),) :imgUrl == ''
                              ? Container(
                              decoration :BoxDecoration(
                                image: const  DecorationImage(image: AssetImage('assets/images/avatar.jpg')),
                                borderRadius: BorderRadius.circular(100)
                              ), ) : null,
                    ),
                    ),

                    const SizedBox(
                      height: 25,
                    ),
                    Form(
                        key: key,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _username ,
                              style: const TextStyle(
                                  fontFamily: 'rw', color: Colors.white),
                              decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.lightBlueAccent),
                                    borderRadius: BorderRadius.circular(55),
                                  ),
                                  disabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.lightBlueAccent),
                                  ),
                                  hintText: 'username ',
                                  prefixIcon: const Icon(
                                    Icons.email_outlined,
                                    color: Colors.white54,
                                  ),
                                  hintStyle: const TextStyle(
                                      color: Colors.white54, fontFamily: 'rw'),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(55))),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.phone,
                              controller: _phone,
                              style: const TextStyle(
                                  fontFamily: 'rw', color: Colors.white),
                              decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.lightBlueAccent),
                                    borderRadius: BorderRadius.circular(55),
                                  ),
                                  disabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.lightBlueAccent),
                                  ),
                                  hintText: 'phone number',
                                  prefixIcon: const Icon(
                                    Icons.phone,
                                    color: Colors.white54,
                                  ),
                                  hintStyle: const TextStyle(
                                      color: Colors.white54, fontFamily: 'rw'),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(55))),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Checkbox(value: _c, onChanged: (v){
                                  setState(() {
                                    _c  = !_c;
                                  });
                                },activeColor: Colors.lightBlueAccent,checkColor: Colors.black54,),
                                const Text('Remember me for 30 days',style:TextStyle(
                                    fontSize: 10,


                                    fontFamily: 'rw',color: Colors.grey

                                ) ,)
                              ],
                            ),

                            const SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  if(_username.text.isNotEmpty && _phone.text.length ==10 ){
                                    final email = widget.email ;
                                    final password =widget.password ;
                                      print(imgUrl) ;
                                      final user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password) ;
                                      if(user.user != null ){
                                        final usermodel = UserModel(username: _username.text, phonenumber: "+91${_phone.text}", uid: user.user!.uid, email: email, imageurl: imgUrl, post: [], profileviews: 0, thoughts: [], friends: []);
                                        await FirebaseServices().addUserDataToFirestore(user.user!.uid, usermodel.toJson()).then((value) {
                                          Navigator.pushAndRemoveUntil(context, leftToRightTransition(const HomePage()), (route) => false);
                                        });


                                      }
                                      else {
                                        Fluttertoast.showToast(msg: 'something went wrong') ;
                                      }
                                  }
                                  else {
                                  Fluttertoast.showToast(msg: 'All fields must be correct ') ;
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.lightBlueAccent,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Text(
                                        'Continue',
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w800,
                                          fontFamily: 'rw',
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        )),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ],
          )),
    ));
  }
}
