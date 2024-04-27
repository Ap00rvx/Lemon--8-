import 'package:brave/bloc/commentsBloc/comments_bloc.dart';
import 'package:brave/data/models/post_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentsSection extends StatefulWidget {
  const CommentsSection({super.key, required this.postModel});
  final PostModel postModel;
  @override
  State<CommentsSection> createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<CommentsBloc>(context)
        .add(GetCommentsOfPostEvent(post: widget.postModel));}


  @override
  Widget build(BuildContext context) {
    final dark = MediaQuery.of(context).platformBrightness == Brightness.dark ;
    return Container(
      child: BlocBuilder<CommentsBloc, CommentsState>(
        builder: (context, state) {
          if (state is CommentsLoadedState) {
            final length = state.comments.length;
            final comments = state.comments ;
            comments.sort((a, b) => b.date.compareTo(a.date)) ;
            return Center(
              child: length == 0
                  ? const Text(
                      'No Comments Yet',
                      style: TextStyle(fontFamily: 'mon'),
                    )
                  : ListView.builder(

                      itemCount: length,
                      itemBuilder: (context, index) {
                        final comment = state.comments[index];
                        final time = DateTime.now().difference(comment.date);
                        return GestureDetector(
                          onLongPress: (){
                            final uid  = FirebaseAuth.instance.currentUser!.uid ;
                            print(comment.userId) ;
                           if(comment.userId != uid ){}
                           else {
                             showDialog(context: context, builder: (context) {
                               return AlertDialog(
                                 title: Column(
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   children: [
                                     GestureDetector(
                                       onTap: () {},
                                       child: const Text('Edit'),
                                     ),
                                     const SizedBox(
                                       height: 30,
                                     )
                                     ,
                                     GestureDetector(
                                       onTap: () {},
                                       child: const Text('Delete'),
                                     ),
                                   ],

                                 ),
                                 actions: [
                                   TextButton(onPressed: () {
                                     Navigator.pop(context);
                                   }, child: const Text('Close'))
                                 ],
                               );
                             });
                           }
                          },
                          child: Card(
                            elevation: 3,
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              child:Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(comment.userImageurl),
                                    radius: 15,
                                  ),
                                  SizedBox(
                                    child: RichText(text: TextSpan(text: '${comment.username}  ',style: TextStyle(fontSize:18, fontFamily: 'mon',color:
                                    dark ? Colors.white : Colors.black),children: [
                                      TextSpan(text: comment.comment,style: TextStyle(
                                        fontFamily: 'mon',
                                        color: dark ? Colors.grey.withOpacity(0.5): Colors.black45
                                      ))
                                    ])),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(     time.inDays  >= 30  ? "${time.inDays/30} months ago"   : time.inDays >=1 ?  "${time.inDays} days ago" : time.inHours >=1  ?  "${time.inHours} hours ago"  :time.inMinutes  == 0 ? 'moments ago ' : "${time.inMinutes} minutes ago",style: TextStyle(
                                        color:  MediaQuery.of(context).platformBrightness ==Brightness.dark ? Colors.white24 : Colors.black12,
                                        fontFamily: 'mon'
                                    ),  ),
                                  )
                                ],

                              )
                            ),
                          ),
                        );
                      }),
            );
          } else if (state is CommentsErrorState) {
            return Container(
              child: Text(state.err),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
