import 'package:brave/common/pageTransition/page_transition.dart';
import 'package:brave/data/models/user_model.dart';
import 'package:brave/data/repository/firestore/firestore.dart';
import 'package:brave/view/authentications/signup/sign_up_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import "package:email_validator/email_validator.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:brave/view/home/screens/home_screen.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _c = false;
  final GlobalKey key = GlobalKey() ;
  bool _obsure = true ;
  final _email =TextEditingController();
  bool validateCredentials(String email, String password) {
    // Validate email
    bool isEmailValid = EmailValidator.validate(email);

    // Validate password (minimum length of 6 characters)
    bool isPasswordValid = password.length >= 6;

    // Return true if both email and password are valid, otherwise false
    return isEmailValid && isPasswordValid;
  }
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signIn();

      if (googleSignInAccount == null) {
        return null; // User canceled the sign-in
      }

      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      UserCredential authResult = await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = authResult.user;

      return user;
    } catch (error) {
      print("Error during Google Sign In: $error");
      return null;
    }
  }
  final _password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width ;
    return  Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.sizeOf(context).height,
          width: width ,
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.black,
              Colors.black54,
              Colors.transparent
            ],begin: Alignment.bottomCenter,end: Alignment.topCenter),
            image: DecorationImage(image: AssetImage('assets/images/bg.jpg'),fit: BoxFit.cover)
          ),
          child: Stack(
            children: [
              Container(
                width: width ,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.black,
                Colors.black54,
        
                Colors.transparent
              ],begin: Alignment.bottomCenter,end: Alignment.topCenter),)
              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(onPressed: ()async {
                      final user =await signInWithGoogle() ;
                      if (user != null){
                        final usermodel = UserModel(username: user.displayName.toString(), phonenumber: user.phoneNumber ?? "not-provided", uid: user.uid, email: user.email.toString(), imageurl: user.photoURL.toString(), post: [], profileviews: 0, thoughts: [], friends: []);
                         FirebaseServices().addUserDataToFirestore(user.uid, usermodel.toJson()).then((value) {
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomePage()), (route) => false);
                        });
        
                      }
                    }, style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white
                    ),child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/google.png',height: 60,),
                        const SizedBox(width: 10,),
                        const Text('Log In with Google',style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'ds',
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                        ),)
                      ],
                    )),
                    const SizedBox(height: 25,),
                    const Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color:Colors.white54,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 0.0),
                          child: Text('or',style: TextStyle(
                              fontSize: 20,
                              color: Colors.white
                          ),),
                        ),
                        Expanded(
                          child: Divider(
                              color: Colors.white54
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25,),
                Form(
                  key: key,
                    child: Column(children: [
                  TextFormField(
                    controller : _email ,
        
                    style:const  TextStyle(
                      fontFamily: 'rw',
                      color: Colors.white
                    ),
                    decoration:InputDecoration(
        
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.lightBlueAccent
                          ),
                          borderRadius: BorderRadius.circular(55),
                        ),
                        disabledBorder:  const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.lightBlueAccent
                          ),),
                      hintText: 'Email',
                      prefixIcon: const Icon(Icons.email_outlined,color:Colors.white54 ,),
                      hintStyle: const TextStyle(color: Colors.white54,fontFamily: 'rw'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(55)
                      )
                    ),
                  ), const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        obscureText: _obsure,
                        controller : _password  ,
                        style: const TextStyle(
                            fontFamily: 'rw',
                            color: Colors.white
                        ),
                    decoration:InputDecoration(

                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.lightBlueAccent
                        ),
                          borderRadius: BorderRadius.circular(55),
                      ),
                      disabledBorder: const  OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.lightBlueAccent
                        ),),
                      hintText: 'Password',

                      suffixIcon: IconButton(onPressed: (){
                        setState(() {
                          _obsure  = !_obsure ;
                        });
                      }, icon: const Icon(Icons.remove_red_eye_rounded)),
                      prefixIcon:  Image.asset('assets/images/key.png',color: Colors.white54,)
        ,                    hintStyle: const TextStyle(color: Colors.white54,fontFamily: 'rw'),
                      border: OutlineInputBorder(
        
                        borderRadius: BorderRadius.circular(55)
                      ),
        
                    ),
                  ),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween ,children: [
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
                            GestureDetector(
                              onTap:(){},
                              child: const Text('Forgot Password?',style:TextStyle(
                                fontSize: 15,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.grey,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'rw',color: Colors.grey
        
                              ),),
                            )
                        ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(onPressed: ()async {
                        if (validateCredentials(_email.text, _password.text)) {
                          final str = await FirebaseServices().signUp(_email.text, _password.text) ;
                          if (str ==  "success"){
                           Navigator.pushAndRemoveUntil(context, leftToRightTransition(HomePage()), (route) => false) ;
                          }else{
                            Fluttertoast.showToast(msg: 'Setting up things ');
                            Navigator.push(context, leftToRightTransition(GetUserDetailsPage(email: _email.text,password: _password.text,)));
                          }
                        }
                        else{
                          Fluttertoast.showToast(msg: "Wrong email or password Combination");
                        }
                      },style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlueAccent,
                        foregroundColor: Colors.white,
        
                      ), child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding:  EdgeInsets.all(10.0),
                            child:  Text('Log In',style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'rw',
        
                            ),),
                          ),
                        ],
                      )),
                ],)),
                    const SizedBox(
                      height: 30,
                    ),
        
                  ],
                ),
              ),
            ],
          )
        ),
      ),
    );
  }
}
