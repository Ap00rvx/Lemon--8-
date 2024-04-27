import 'package:brave/bloc/profile_bloc/grid_bloc/get_grid_bloc.dart';
import 'package:brave/view/home/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostGrids extends StatefulWidget {
  const PostGrids({super.key ,required this.uid  });
final String uid ;

  @override
  State<PostGrids> createState() => _PostGridsState();
}

class _PostGridsState extends State<PostGrids> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<GetGridBloc>(context).add(GetPostsOfProfile(uid: widget.uid)) ;
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetGridBloc, GetGridState>(
      builder: (context, state) {
        if(state is GetGridError){
          return Center(
            child: Text(state.error),
          );
        }
        else if (state is GetGridLoaded){
          final length = state.posts.length ; 
          return length == 0 ?  Text('No Post yet'):GridView.builder(shrinkWrap: true,gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 3/4),physics: const NeverScrollableScrollPhysics(), itemCount: length,itemBuilder:(context , index ){
            final post = state.posts[index ];
            final time  = DateTime.now().difference(post.date);
            return Card(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25)
                ),
                child: Column(
                  children: [
                    Image.network(post.imageUrl,height: 180,width: 500,fit: BoxFit.cover,errorBuilder: (_,__,___){
                      return const SizedBox(
                        height: 180,width: 500,
                        child: Center(
                          child: Text("No internet"),
                        ),
                      ) ; 
                    },loadingBuilder: (_,__,progress){
                      if(progress == null ){
                        return Image.network(post.imageUrl,height: 180,width: 500,fit: BoxFit.cover,);
                      }
                      return const SizedBox(
                          height: 180,width: 500,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LimitedText(text: post.title, maxLength: 18 , style: const TextStyle(fontFamily: 'mon')),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        Row(
                          children: [
                            Text("${post.likes.length} ", style: const TextStyle(fontFamily: 'mon')),
                            const Icon(Icons.favorite,color: Colors.redAccent,size: 15,),
                            const SizedBox(
                              width: 10,
                            ),
                            Text("${post.comments.length} ", style: const TextStyle(fontFamily: 'mon')),
                            const Icon(Icons.comment,size: 15,),
                          ],
                        ),
                          SizedBox(
                            child:Text(     time.inDays  >= 30  ? "${(time.inDays/30).floor()} months ago"   : time.inDays >=1 ?  "${time.inDays} days ago" : time.inHours >=1  ?  "${time.inHours} hours ago"  :time.inMinutes  == 0 ? 'moments ago ' : "${time.inMinutes} mins ago",style: TextStyle(
                                color:  MediaQuery.of(context).platformBrightness ==Brightness.dark ? Colors.white24 : Colors.black12,
                                fontFamily: 'mon'
                            ),  ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ),
            );
          });
        }
        else{
          return const Center(
            child: CircularProgressIndicator(),
          ) ;

        }
      },
    );
  }
}
