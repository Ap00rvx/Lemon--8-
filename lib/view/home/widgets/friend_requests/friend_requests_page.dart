import 'package:brave/bloc/friend_request_bloc/friend_request_bloc.dart';
import 'package:brave/data/models/user_model.dart';
import 'package:brave/data/repository/firestore/profile_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FriendRequestPage extends StatefulWidget {
  const FriendRequestPage({super.key,required this.user});
  final UserModel user;

  @override
  State<FriendRequestPage> createState() => _FriendRequestPageState();
}

class _FriendRequestPageState extends State<FriendRequestPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<FriendRequestBloc>(context).add(GetFriendRequestEvent(userId: widget.user.uid));
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        elevation: 5,
        title: const Text('Friend Requests'),
      ),
      body: BlocBuilder<FriendRequestBloc, FriendRequestState>(
        builder: (context, requests) {
          if (requests is FriendRequestLoaded){
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(shrinkWrap: true ,itemCount: requests.requests.length,itemBuilder: (context,index){
                final user = requests.requests[index];
                return Dismissible(
                  background: Icon(Icons.delete),

                  direction: DismissDirection.startToEnd,
                  onDismissed: (value){
                    print("deleted");
                  },
                  key: Key('ss'),
                  child: ListTile(

                    leading: CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(user.imageurl),
                    ),
                    title: RichText(
                      text: TextSpan(text: user.username,style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      fontSize:17 ),children: const [
                         TextSpan(text: 'wants to be your friend',style: TextStyle(
                          fontWeight: FontWeight.normal
                        ))
                      ]),
                    ),
                    trailing:  ElevatedButton(onPressed: ()async {
                      await ProfileServices().friendRequestAccepted(widget.user.uid,user.uid);
                    }, style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      // fixedSize: Size(120, 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                  
                    ),child:Text("Confirm") ),
                    subtitle: Row(
                      children: [
                  
                      ],
                    ),
                  ),
                );
              }),
            );
          }
          else if (requests is FriendRequestLoading){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          else {
            return const Center(
              child: Text("Something went wrong "),
            );
          }

        },
      ),
    );
  }
}
