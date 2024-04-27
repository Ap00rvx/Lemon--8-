import 'package:brave/view/authentications/login/screen/login.dart';
import 'package:brave/view/home/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import'package:flutter/material.dart';
class LinkScreen extends StatefulWidget {
  const LinkScreen({super.key});

  @override
  State<LinkScreen> createState() => _LinkScreenState();
}

class _LinkScreenState extends State<LinkScreen> {
  final _firebase = FirebaseAuth.instance ;
  @override
  Widget build(BuildContext context) {
    return  StreamBuilder(stream: _firebase.authStateChanges(), builder: (context,snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Scaffold(
            body:  Center(
              child: CircularProgressIndicator(

              ),
            ),
          );
        }
        else{
          if (snapshot.hasData){
            return const  HomePage();
          }
          else{
            return const LoginPage();
          }
        }
      }

    );
  }
}
