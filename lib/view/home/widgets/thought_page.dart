import 'dart:async';
import 'package:brave/common/pageTransition/page_transition.dart';
import 'package:brave/data/models/thought_model.dart';
import 'package:brave/view/home/screens/home_screen.dart';
import 'package:brave/view/profile/screen/profile_page.dart';
import 'package:flutter/material.dart';

class ViewThoughtsPage extends StatefulWidget {
  const ViewThoughtsPage({super.key ,required this.thought});
  final ThoughtModel thought ;

  @override
  State<ViewThoughtsPage> createState() => _ViewThoughtsPageState();
}

class _ViewThoughtsPageState extends State<ViewThoughtsPage> {
  double _width = 0 ;
  int seconds = 0;
  late Timer timer;

  void _startAnimation() {
    Future.delayed(const Duration(seconds: 1) ,(){
      setState(() {
        _width = 400.0;
      });
    } ).then((value) {
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startAnimation() ;
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        seconds++;
        if (seconds == 7) {
          Navigator.pop(context);
          timer.cancel();
        }
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    final model =  widget.thought ;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              child: Center(
                child: Text(model.content,textAlign: TextAlign.center ,style: const TextStyle(
                    fontFamily: 'mon',
                    fontSize: 25
                ),),
              ),
            ),
            SizedBox(
              child: Column(
                children: [
                  Row(

                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                     SizedBox(
                       child: Row(
                         children: [
                           Padding(
                             padding: const EdgeInsets.symmetric(vertical:30 ,horizontal: 10),
                             child: GestureDetector(
                               onTap: (){
                                    timer.cancel();
                                 Navigator.push(context, leftToRightTransition(ProfilePage(uid: model.uid)));
                               },
                               child: CircleAvatar(
                                 radius: 30,
                                 backgroundImage: NetworkImage(model.userimage),
                               ),
                             ),
                           ),
                           LimitedText(text : model.username ,maxLength: 20,style: const TextStyle(
                               fontFamily: 'mon',
                               fontSize: 25
                           ),)
                         ],
                       ),
                     ),
                      IconButton(onPressed: (){
                        Navigator.pop(context);
                      }, icon: const Icon(Icons.close,color: Colors.red ,size: 30,))
                    ],
                  ),
    AnimatedContainer(duration: const  Duration(seconds: 6),
    color:  Colors.grey.withOpacity(0.5) ,
    height: 3 ,
    width: _width
    ,)

                ],
              ),
            )

          ],
        ),
      )
    );
  }
}

class MyTimerContainer extends StatefulWidget {
  const MyTimerContainer({super.key});

  @override
  State<MyTimerContainer> createState() => _MyTimerContainerState();
}

class _MyTimerContainerState extends State<MyTimerContainer> {
  double _width = 0 ;
  int seconds = 0;
  late Timer timer;

  void _startAnimation() {
    Future.delayed(const Duration(seconds: 1) ,(){
      setState(() {
        _width = 400.0;
      });
    } ).then((value) {
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startAnimation() ;
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        seconds++;
        if (seconds == 7) {
          Navigator.pop(context);
          timer.cancel();
        }
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(duration: const  Duration(seconds: 6),
    color:  Colors.grey.withOpacity(0.5) ,
      height: 3 ,
      width: _width
      ,);
  }
}

