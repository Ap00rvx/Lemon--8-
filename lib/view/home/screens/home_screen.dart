import 'dart:math';
import 'package:brave/bloc/PostBloc/post_bloc.dart';
import 'package:brave/bloc/commentsBloc/comments_bloc.dart';
import 'package:brave/bloc/dailyThoughtQuery/daily_thought_query_bloc.dart';
import 'package:brave/bloc/getAllThoughts/get_thought_bloc.dart';
import 'package:brave/bloc/profile_bloc/profile_bloc.dart';
import 'package:brave/bloc/thoughtUpdate/thought_bloc.dart';
import 'package:brave/bloc/userDetails/user_details_bloc.dart';
import 'package:brave/common/pageTransition/page_transition.dart';
import 'package:brave/data/models/comment_model.dart';
import 'package:brave/data/models/thought_model.dart';
import 'package:brave/data/repository/firestore/comment_firestore.dart';
import 'package:brave/data/repository/firestore/post_firebase_services.dart';
import 'package:brave/view/home/widgets/comments/comments_section.dart';
import 'package:brave/view/home/widgets/create_new_post/create_post.dart';
import 'package:brave/view/home/widgets/friend_requests/friend_requests_page.dart';
import 'package:brave/view/home/widgets/thought_page.dart';
import 'package:brave/view/profile/screen/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math' as math ;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:widget_circular_animator/widget_circular_animator.dart';
class LimitedText extends StatelessWidget {
  final String text;
  final int maxLength;
  final TextStyle style;

  const LimitedText({super.key, required this.text, required this.maxLength, required this.style});

  @override
  Widget build(BuildContext context) {
    String limitedText = text.length <= maxLength ? text : '${text.substring(0, maxLength)}...';

    return Text(
      limitedText,
      style: style,
    );
  }
}
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  late GlobalKey<ScaffoldState> scaffoldKey ;
  final _thoughtController = TextEditingController() ;
  final moods = ['😀','😞','😦','🥺','😇'];
  final moodString = ['happy', 'sad','shocked','pleased','blessed'] ;
  int selectedMood = 0;
  Color generateRandomColor() {
    Random random = Random();
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1.0,
    );
  }
  Future<void> _refresh ()async {
    setState(() {
      BlocProvider.of<PostBloc>(context).add(GetPostEvent()) ;
      BlocProvider.of<DailyThoughtQueryBloc>(context).add(DoDailyQuery());
      BlocProvider.of<GetThoughtBloc>(context).add(GetAllThoughtEvent()) ;
    });
  }
  @override
  void initState() {
    super.initState();
    scaffoldKey = GlobalKey<ScaffoldState>();
    BlocProvider.of<DailyThoughtQueryBloc>(context).add(DoDailyQuery());
    BlocProvider.of<PostBloc>(context).add(GetPostEvent()) ;
    BlocProvider.of<GetThoughtBloc>(context).add(GetAllThoughtEvent()) ;
    BlocProvider.of<UserDetailsBloc>(context).add(GetUserDetailsEvent());
  }
  bool isBottomSheetOpen = false ;
  final _commentController  = TextEditingController() ;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DailyThoughtQueryBloc,DailyThoughtQueryState>(builder: (context, state){
      if (state is DailyThoughtQueryLoaded){
        return BlocBuilder<UserDetailsBloc, UserDetailsState>(
            builder: (context, state) {
              if (state is UserDetailsLoadedState) {
                return Scaffold(
                    key: scaffoldKey,
                    drawer: Drawer(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 300,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                WidgetCircularAnimator(
                                  innerColor: generateRandomColor(),
                                  outerColor: generateRandomColor(),
                                  size: 150,
                                  innerAnimation: Curves.linearToEaseOut,
                                  outerAnimation: Curves.linear,
                                  child: Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey[200]),
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        state.usermodel.imageurl
                                            .toString(),
                                      ),
                                      radius: 15.0,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  state.usermodel.username.toString(),
                                  style: const TextStyle(fontFamily: 'mon', fontSize: 22),
                                )
                              ],
                            ),
                          ),
                          const Divider(),
                          GestureDetector(
                            onTap: () {

                              scaffoldKey.currentState!.closeDrawer() ;
                            },
                            child: const SizedBox(
                              height: 60,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 6,
                                  ),
                                  Icon(
                                    Icons.home,
                                    size: 30,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Home",
                                    style: TextStyle(fontFamily: 'mon', fontSize: 22),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const Divider(),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, leftToRightTransition(ProfilePage(uid: state.usermodel.uid))) ;
                            },
                            child: const SizedBox(
                              height: 60,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 6,
                                  ),
                                  Icon(
                                    Icons.person,
                                    size: 30,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Your Profile",
                                    style: TextStyle(fontFamily: 'mon', fontSize: 22),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const Divider(),
                          GestureDetector(
                            onTap: () {},
                            child: const SizedBox(
                              height: 60,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 6,
                                  ),
                                  Icon(
                                    Icons.settings,
                                    size: 30,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Settings",
                                    style: TextStyle(fontFamily: 'mon', fontSize: 22),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const Divider(),
                          GestureDetector(
                            onTap: () async{
                              showDialog(context: context, builder: (context){
                                return AlertDialog(
                                  actions: [
                                    TextButton(onPressed:()async{
                                      final google  =GoogleSignIn(scopes: ['email']) ;
                                      await FirebaseAuth.instance.signOut() ;
                                      await google.disconnect();
                                      Navigator.pop(context);
                                    }, child: const Text('Yes',style: TextStyle(
                                        fontFamily: 'mon'
                                    ),)), TextButton(onPressed:(){
                                      Navigator.pop(context) ;
                                    }, child: const Text('No',style: TextStyle(
                                        fontFamily: 'mon'
                                    ),)),
                                  ],
                                  title: const Text("Log out now? " ,style: TextStyle(
                                      fontFamily: 'mon'
                                  ),),
                                );
                              });
                            },
                            child: const SizedBox(
                              height: 60,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 6,
                                  ),
                                  Icon(
                                    Icons.multiple_stop,
                                    size: 30,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Log Out",
                                    style: TextStyle(fontFamily: 'mon', fontSize: 22),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    appBar: AppBar(
                      leading: GestureDetector(
                        onTap: () {
                          scaffoldKey.currentState?.openDrawer();
                        },
                        child: Image.asset(
                          'assets/images/widgets.png',
                          color: MediaQuery.of(context).platformBrightness ==
                              Brightness.light
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                      actions: [
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                              GestureDetector(onTap: ()async {

                              Navigator.push(context, leftToRightTransition(FriendRequestPage(user: state.usermodel)));
                              }, child:Image.asset("assets/images/notify.png",color: MediaQuery.of(context).platformBrightness ==Brightness.dark ? Colors.white :Colors.black,)),
                                const SizedBox(
                                  width: 20,
                                ),
                                GestureDetector(onTap: (){

                                  Navigator.push(context, leftToRightTransition(CreatePostPage(userModel:  state.usermodel,))) ;


                                }, child:Image.asset("assets/images/addd.png",color: MediaQuery.of(context).platformBrightness ==Brightness.dark ? Colors.white :Colors.black,)),
                                const SizedBox(
                                  width: 20,
                                ),
                                Image.asset(
                                  'assets/images/heli.png',
                                  color: MediaQuery.of(context).platformBrightness ==
                                      Brightness.light
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              ],
                            ))
                      ],
                      elevation: 3,
                      title: Text(
                        "Lemon 8",
                        style: TextStyle(
                            fontFamily: 'ds',
                            fontSize: 30,
                            color: MediaQuery.of(context).platformBrightness ==
                                Brightness.light
                                ? Colors.black
                                : Colors.white),
                      ),
                    ),
                    body: RefreshIndicator(
                      onRefresh: _refresh,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 120,
                              child: BlocBuilder<GetThoughtBloc,GetThoughtState>(
                                  builder: (context,thought) {
                                    if (thought is GetThoughtLoaded) {

                                      return  thought.data.isEmpty ? Center(
                                        child: Text("Be the First to add a  Thought" ,style: const TextStyle(
                                            fontFamily: 'mon',
                                          fontSize: 25
                                        ),),
                                      ) :ListView.builder(
                                          itemCount: thought.data.length,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            final data  = thought.data[index] ;
                                            return Hero(
                                              tag : data.thoughtId.toString() ,
                                              child: GestureDetector(
                                                onTap: ()async {
                                                 Navigator.push(context,MaterialPageRoute(builder: (context )=> ViewThoughtsPage(thought :data ))) ;
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.all(10.0),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                        height: 70,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: generateRandomColor(),
                                                                width: 3
                                                            ),
                                                            shape: BoxShape.circle,
                                                            color: Colors.grey[200]),
                                                        child: CircleAvatar(
                                                          backgroundImage: NetworkImage(
                                                            data.userimage,
                                                          ),
                                                          radius: 30.0,
                                                        ),
                                                      ),
                                                      LimitedText(text:data.username ,maxLength: 12,style: const TextStyle(
                                                          fontFamily: 'mon'
                                                      ), )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          });
                                    }
                                    else if (thought is GetThoughtError){
                                      return Center(
                                        child: Text(thought.error ,style: const TextStyle(
                                            fontFamily: 'mon'
                                        ),),
                                      );
                                    }
                                    else {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                  }
                              ),
                            ),
                            Divider (
                              color: MediaQuery.of(context).platformBrightness == Brightness.light ? Colors.grey.shade200 : Colors.grey.shade800.withOpacity(0.3) ,
                            ),
                            SizedBox(
                              height: 150,
                              child: Center(
                                child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 30),
                                  child: Card(
                                    child: SizedBox(
                                      height: 140,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                              children: [
                                                CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                      state.usermodel.imageurl),
                                                  radius: 20,
                                                ),
                                                SizedBox(
                                                    width: 250,
                                                    child: TextField(
                                                      decoration: const InputDecoration(
                                                          suffixIcon: Icon(Icons.edit),
                                                          border: InputBorder.none,
                                                          hintText: "What's on your mind ? ",
                                                          hintStyle:
                                                          TextStyle(fontFamily: 'mon')),
                                                      controller: _thoughtController,
                                                    )),
                                                const Column(
                                                  children: [],
                                                ),
                                              ],
                                            ),
                                            const Divider(),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  // width: 200,
                                                  height:60,
                                                  child: ListView.builder(shrinkWrap: true,scrollDirection: Axis.horizontal,itemCount:  5 ,itemBuilder: (context , index ){
                                                    return GestureDetector(
                                                      onTap: (){
                                                        setState(() {
                                                          selectedMood = index ;
                                                        });
                                                      },
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal:8.0,vertical: 15),
                                                        child: Text(moods[index],style: TextStyle(fontFamily: "mon",fontSize: 20,backgroundColor: selectedMood == index ? Colors.blueAccent : Colors.transparent),),
                                                      ),
                                                    );
                                                                                              }),
                                                ),
                                                IconButton(
                                                    onPressed: () async {
                                                      if(_thoughtController.text.isNotEmpty){

                                                        final thoughtId  = DateTime.now().millisecondsSinceEpoch.toString() ;
                                                        final thoughtModel = ThoughtModel(mood: moodString[selectedMood], content: _thoughtController.text, date: DateTime.now(), username: state.usermodel.username, userimage: state.usermodel.imageurl, uid: state.usermodel.uid, thoughtId: thoughtId) ;
                                                        BlocProvider.of<ThoughtBloc>(context).add(UpdateThought(model: thoughtModel));
                                                        _thoughtController.clear() ;
                                                      }
                                                      showDialog(context: context, builder: (context ){
                                                        return AlertDialog(
                                                            actions: [
                                                              TextButton(onPressed: (){
                                                                Navigator.pop(context) ;
                                                              }, child: const Text("Close",style: TextStyle(fontFamily: 'mon'),))
                                                            ],
                                                            title: BlocBuilder<ThoughtBloc, ThoughtState>(
                                                              builder: (context, state) {
                                                                return state is ThoughtUpdated ? Text(state.message,style: const TextStyle(fontFamily: 'mon'),): state is ThoughtError ? Text(state.error,style:  const TextStyle(fontFamily: 'mon'),) : const Center(child: CircularProgressIndicator(),);
                                                              },
                                                            )
                                                        );
                                                      });
                                                    },
                                                    icon: const Icon(
                                                      Icons.send_rounded,
                                                      color: Colors.blue,
                                                    ))
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Divider (
                              color: MediaQuery.of(context).platformBrightness == Brightness.light ? Colors.grey.shade200 : Colors.grey.shade800.withOpacity(0.3) ,
                            ),
                            SizedBox(
                                child: BlocBuilder<PostBloc, PostState>(
                              builder: (context, postState) {
                                if(postState is PostInitial || postState is PostLoading){
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                else if (postState is PostLoaded){
                                  final posts = postState.postList ;
                                  posts.sort((a, b) => b.date.compareTo(a.date)) ;
                                  final width = MediaQuery.sizeOf(context).width ;
                                  return SizedBox(
                                    child: ListView.builder(physics: const NeverScrollableScrollPhysics(),shrinkWrap: true,itemCount: posts.length, itemBuilder: (context , ind ){
                                      final post = posts[ind];
                                      bool isLiked = post.likes.contains(state.usermodel.uid) ;
                                      final time = DateTime.now().difference(post.date) ;
                                      return SizedBox(
                                        width: width,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                               SizedBox(
                                                 child: Row(
                                                   children: [
                                                     GestureDetector(
                                                       onTap:(){
                                                         BlocProvider.of<ProfileBloc>(context).add(GetUserProfilePageEvent(uid: post.uid )) ;
                                                         Navigator.push(context, leftToRightTransition(ProfilePage(uid: post.uid)));
                                                       },
                                                       child: CircleAvatar(
                                                         backgroundImage: NetworkImage(post.userImageUrl),
                                                       ),
                                                     ),
                                                     const SizedBox(
                                                       width: 20,
                                                     ),
                                                     Text(post.username ,style: const TextStyle(fontFamily: 'mon',fontSize: 18),)
                                                   ],
                                                 ),
                                               ),
                                                  GestureDetector(
                                                    onTap: (){},
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal:  8.0),
                                                      child: Image.asset('assets/images/menu.png',color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black,),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                           GestureDetector(
                                                onLongPress: ()async {
                                                  await showDialog(context: context, builder: (context ){
                                                    return Image.network(post.imageUrl,fit: BoxFit.cover ,height: 400,errorBuilder: (context , obj , stackTrace){
                                                      return SizedBox(
                                                        height: 400,
                                                        width: width,
                                                        child: const Center(
                                                          child: Icon(Icons.error,color: Colors.red,size: 50,),
                                                        ),
                                                      ) ;
                                                    },loadingBuilder: (_,child , progress ){
                                                      if(progress == null ){
                                                        return  Image.network(post.imageUrl,fit: BoxFit.cover,height: 600)  ;
                                                      }
                                                      else{
                                                        return SizedBox(
                                                          height: 400,
                                                          width: width,
                                                          child: const Center(
                                                            child: CircularProgressIndicator(),
                                                          ),
                                                        ) ;
                                                      }
                                                    },);
                                                  });

                                                },
                                             child: Container(
                                               width: width,
                                               color : MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.black :Colors.white,
                                               child:  Image.network(post.imageUrl,fit: BoxFit.fitHeight,height: 400,errorBuilder: (context , obj , stackTrace){
                                                 return SizedBox(
                                                   height: 400,
                                                   width: width,
                                                   child: const Center(
                                                     child: Icon(Icons.error,color: Colors.red,size: 50,),
                                                   ),
                                                 ) ;
                                               },loadingBuilder: (_,child , progress ){
                                                 if(progress == null ){
                                                   return  Image.network(post.imageUrl,fit: BoxFit.fitHeight,height: 400)  ;
                                                 }
                                                 else{
                                                   return SizedBox(
                                                     height: 400,
                                                     width: width,
                                                     child: const Center(
                                                       child: CircularProgressIndicator(),
                                                     ),
                                                   ) ;
                                                 }
                                               },),
                                             ),
                                             onDoubleTap: ()async{
                                               await PostServices().updateLike(isLiked, state.usermodel, post);
                                               setState(() {
                                                 isLiked = !isLiked ;
                                               });
                                             },
                                           ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child:RichText(text: TextSpan(text: post.username,style:  TextStyle(
                                                fontSize: 15,
                                                color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black,
                                                fontFamily: 'mon',
                                                fontWeight: FontWeight.bold
                                              ),children: [
                                                TextSpan(text: '   ',style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.grey.withOpacity(0.6),
                                                  fontFamily: 'mon',

                                                ),),
                                                TextSpan(text: post.title,style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.grey.withOpacity(0.6),
                                                    fontFamily: 'mon',

                                                ),)
                                              ]),)
                                            ),
                                            Row(

                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                              children: [
                                                SizedBox(
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        child: Row(
                                                          children: [
                                                            IconButton(onPressed: ()async {
                                                              await PostServices().updateLike(isLiked, state.usermodel, post);
                                                              setState(() {
                                                                isLiked = !isLiked ;
                                                              });
                                                            }, icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border,color: isLiked ? Colors.red : Colors.grey,)),
                                                            Text("${post.likes.length} loves" , style: const TextStyle(
                                                              fontFamily: 'mon'
                                                            ),)
                                                          ],
                                                        ),
                                                      ),
                                                      IconButton(onPressed: ()async {
                                                        setState(() {
                                                          isBottomSheetOpen = !isBottomSheetOpen  ;
                                                        });
                                                        showBottomSheet(context: context,enableDrag: true , builder: (context) {
                                                          return SizedBox(
                                                            width: width,

                                                            child:  SingleChildScrollView(
                                                              child: Column(
                                                                children: [
                                                                   Padding(
                                                                    padding: const EdgeInsets.all(8.0),
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        const Text('Comments',style: TextStyle(fontFamily: 'mon',
                                                                        fontSize: 30),),
                                                                        IconButton(onPressed: (){
                                                                          Navigator.pop(context);
                                                                        }, icon: const Icon(Icons.close,color: Colors.red,))
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  const Divider() ,
                                                                  SizedBox(height: 650,
                                                                    child: CommentsSection(postModel: post),
                                                                  ),
                                                                  SizedBox(
                                                                    child: TextFormField(
                                                                      controller: _commentController,
                                                                      decoration: InputDecoration(
                                                                        hintText: 'Add a Comment',
                                                                        hintStyle: const TextStyle(
                                                                          fontFamily: 'mon'
                                                                        ),
                                                                        border: OutlineInputBorder(
                                                                          borderRadius: BorderRadius.circular(25)
                                                                        ),
                                                                        suffixIcon: GestureDetector(
                                                                          onTap: ()async {
                                                                           if(_commentController.text.isNotEmpty){
                                                                             final postmodel = post ;
                                                                             final id = DateTime.now().millisecondsSinceEpoch ;
                                                                             final commentModel = CommentModel(username: state.usermodel.username, comment: _commentController.text, id:id.toString() , userId: state.usermodel.uid, date: DateTime.now(), userImageurl:state.usermodel.imageurl);
                                                                             _commentController.clear() ;
                                                                             await CommentServices().addComment(postmodel, commentModel);
                                                                             BlocProvider.of<CommentsBloc>(context).add(GetCommentsOfPostEvent(post: postmodel)) ;
                                                                           }
                                                                           else {
                                                                             Fluttertoast.showToast(msg: 'Please add Comment');
                                                                           }
                                                                          },
                                                                          child: Image.asset('assets/images/add.png', color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black,),
                                                                        ),
                                                                      ),
                                                                      
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        });

                                                      }, icon: const Icon(Icons.comment_outlined)),
                                                     GestureDetector(onTap: (){},child: Image.asset('assets/images/send.png',height: 25,width: 35,color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black,),)
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text(     time.inDays  >= 30  ? "${(time.inDays/30).floor()} months ago"   : time.inDays >=1 ?  "${time.inDays} days ago" : time.inHours >=1  ?  "${time.inHours} hours ago"  :time.inMinutes  == 0 ? 'moments ago ' : "${time.inMinutes} minutes ago",style: TextStyle(
                                                    color:  MediaQuery.of(context).platformBrightness ==Brightness.dark ? Colors.white24 : Colors.black12,
                                                    fontFamily: 'mon'
                                                  ),  ),
                                                )
                                              ],
                                            ),
                                            const Divider(),
                                          ],
                                        ),
                                      );
                                    }),
                                  );
                                }
                                else {
                                  return  const Center(
                                    child: Text("error"),
                                  );
                                }
                              },
                            )),
                          ],
                        ),
                      ),
                    ));
              }
              else if (state is UserDetailsErrorState) {
                return Scaffold(
                  body: Center(
                    child: Text(state.error),
                  ),
                );
              }
              else {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                  ),
                );
              }
            });
      }
      else{
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
    });
  }
}
