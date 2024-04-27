import 'package:brave/common/pageTransition/page_transition.dart';
import 'package:brave/data/models/user_model.dart';
import 'package:brave/view/home/widgets/add_details_to_page/add_deatails_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key ,required this.userModel});
  final UserModel userModel;
  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}
class _CreatePostPageState extends State<CreatePostPage> {
  XFile? _file ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 200,
            ),
            GestureDetector(
              onTap: ()async {
                showDialog(context: context, builder: (context){
                  return AlertDialog(
                    actions: [
                      TextButton(onPressed: (){
                        Navigator.pop(context) ;
                      }, child:  const Text('close',style: TextStyle(
                          fontFamily: 'mon'
                      ),),)
                    ],
                    title: const Text('Selct mode :',style: TextStyle(
                        fontFamily: 'mon',
                      fontSize: 30
                    ),),
                    content: SizedBox(
                      height: 170,
                      width: 400,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(Icons.image),
                              const  SizedBox(
                                width: 20,
                              ),
                              GestureDetector(
                                onTap: ()async {
                                _file =  await ImagePicker().pickImage(source: ImageSource.gallery);
                                if(_file != null ){
                                  Navigator.push(context, leftToRightTransition(AddDetailsPage(file: _file!,userModel: widget.userModel,)));
                                }
                                },
                                child: const Text('Select image from gallery',style: TextStyle(
                                    fontFamily: 'mon',
                                  fontSize: 18
                                ),),
                              ),
                            ],
                          ), 
                          const Divider(),
                          Row( mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(Icons.video_call_rounded) ,
                              const  SizedBox(
                                width: 20,
                              ),
                              GestureDetector(
                                onTap: ()async{
                                  _file = await ImagePicker().pickVideo(source: ImageSource.gallery);
                                  if(_file != null ){
                                    Navigator.push(context, leftToRightTransition(AddDetailsPage(file: _file!,userModel: widget.userModel,)));
                                  }
                                },
                                child: const Text('Select video from gallery',style: TextStyle(
                                    fontFamily: 'mon',  fontSize: 18,),
                              ),)
                            ],
                          ),
                          const Divider(),
                          Row( mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(Icons.camera),
                             const  SizedBox(
                                width: 20,
                              ),
                              GestureDetector(
                                onTap: ()async{
                                  _file = await ImagePicker().pickImage(source: ImageSource.camera);
                                  if(_file != null ){
                                    Navigator.push(context, leftToRightTransition(AddDetailsPage(file: _file!,userModel: widget.userModel,)));
                                  }
                                },
                                child: const Text('Open Camera',style: TextStyle(
                                    fontFamily: 'mon',  fontSize: 18
                                ),),
                              ),
                            ],
                          ),
                          const Divider(),
                        ],
                      ),
                    )
                  );
                });
              },
              child: Image.asset('assets/images/upload.png'),
            ),
           const  SizedBox(
              height: 100,
            ),
            const Text("Upload a Media" ,style: TextStyle(
              fontFamily: "mon",
              fontSize: 30
            ),) ,
            const Text("(Tap on image)" ,style: TextStyle(
              fontFamily: "mon",
              fontSize: 10
            ),)
          ],
        ),
      ),
    );
  }
}
