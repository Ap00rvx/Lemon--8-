import 'package:brave/bloc/profile_bloc/grid_bloc/get_grid_bloc.dart';
import 'package:brave/bloc/profile_bloc/profile_bloc.dart';
import 'package:brave/bloc/userFriends/user_friend_bloc.dart';
import 'package:brave/common/pageTransition/page_transition.dart';
import 'package:brave/data/models/user_model.dart';
import 'package:brave/data/repository/firestore/profile_services.dart';
import 'package:brave/view/profile/screen/update_profile.dart';
import 'package:brave/view/profile/widgets/post_grids.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.uid});
  final String uid;
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<void> _refresh() async {
    BlocProvider.of<ProfileBloc>(context)
        .add(GetUserProfilePageEvent(uid: widget.uid));
    BlocProvider.of<UserFriendBloc>(context).add(GetUserFriends(useruid: widget.uid));
  }

  final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<GetGridBloc>(context).add(GetPostsOfProfile(uid: widget.uid)) ;
    if (currentUserUid != widget.uid) {
      ProfileServices().updateProfileView(widget.uid);
    }
    BlocProvider.of<ProfileBloc>(context)
        .add(GetUserProfilePageEvent(uid: widget.uid));
    BlocProvider.of<UserFriendBloc>(context).add(GetUserFriends(useruid: widget.uid));
  }


  late UserModel userModel ;
  @override
  void dispose() {
    super.dispose();
  }
Future<bool> requestCheck(String user , String person )async {
    final firestore = await FirebaseFirestore.instance.collection('request').doc(user).get();
     final data  = firestore.data()!['requests'] as List<dynamic>;
     if (data.contains(person)){
       return true;
     }
     else {
       return false ;
     }


}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontFamily: 'mon', fontSize: 22),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if(value == '1' ){

                Navigator.push(context, leftToRightTransition( EditProfilePage(usermodel: userModel,)));
              }

            },
            itemBuilder: (BuildContext context) => currentUserUid == widget.uid
                ? [
                    PopupMenuItem(
                      value: '1',
                      child: Visibility(
                          visible: currentUserUid == widget.uid,
                          child: const Text('Edit profile')),
                    ),
                    PopupMenuItem(
                      value: '2',
                      child: Visibility(
                          visible: currentUserUid == widget.uid,
                          child: const Text('Log out ')),
                    ),
                  ]
                : [
                    const PopupMenuItem(
                      value: '3',
                      child: Text('Report an issue'),
                    ),
                  ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoadedState) {
              userModel = state.userModel;
              final user = state.userModel;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(user.imageurl),
                            radius: 50,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(user.username,
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                        fontFamily: 'mon', fontSize: 22)),
                                Container(
                                  constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.sizeOf(context).width -
                                              150),
                                  child: Text(
                                      user.bio.toString() == ''
                                          ? 'Nothing here'
                                          : user.bio.toString(),
                                      style: TextStyle(
                                          fontFamily: 'mon',
                                          color: Colors.grey.withOpacity(0.5),
                                          fontSize: 15)),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                children: [
                                  Text('    Friends    ',
                                      style: TextStyle(
                                          fontFamily: 'mon',
                                          color: Colors.grey.withOpacity(0.8),
                                          fontSize: 22)),
                                  Text(user.friends.length.toString(),
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(
                                          fontFamily: 'mon', fontSize: 22)),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                children: [
                                  Text('Profile views ',
                                      style: TextStyle(
                                          fontFamily: 'mon',
                                          color: Colors.grey.withOpacity(0.8),
                                          fontSize: 22)),
                                  Text(user.profileviews.toString(),
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(
                                          fontFamily: 'mon', fontSize: 22)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Visibility(
                        visible: currentUserUid == widget.uid,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('phone number',
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
                                Text(user.phonenumber,
                                    style: const TextStyle(
                                        fontFamily: 'mon', fontSize: 22)),
                              ],
                            ),
                          ),
                        ),
                      ),
                  currentUserUid == widget.uid?  SizedBox(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        const Divider(),
                        const Text(
                          'Posts',
                          style: TextStyle(fontFamily: 'ds', fontSize: 30),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        PostGrids(uid: user.uid),
                      ],
                    ),
                  ):BlocBuilder<UserFriendBloc, UserFriendState>(
                    builder: (context, state) {
                      if(state is UserFriendsError){
                        return const  Center(
                          child: Text("Something went wrong "),
                        );
                      }
                      else if (state is UserFriendsLoaded){
                        return FutureBuilder(future: ProfileServices().isUserFriend(currentUserUid, widget.uid), builder: (context , data){
                          if (data.connectionState == ConnectionState.waiting){
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          else {
                            final value = data.data! ;
                            if (value ){
                              return SizedBox(
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const Divider(),
                                    const Text(
                                      'Posts',
                                      style: TextStyle(fontFamily: 'ds', fontSize: 30),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    PostGrids(uid: user.uid),
                                  ],
                                ),
                              );

                            }
                            else {
                              return FutureBuilder(future: requestCheck(widget.uid, currentUserUid), builder: (context,data){
                                if(data.connectionState  == ConnectionState.waiting){
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                else{
                                  final value = data.data ?? false;
                                  if (value){
                                    return  Card(
                                      child: Center(
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 60,
                                          child: const Text('Requested',  textAlign: TextAlign.center ,style: TextStyle(
                                              fontFamily: 'mon',

                                              fontSize: 22)),
                                        )),
                                      );

                                  }
                                  else{
                                    return    ElevatedButton(onPressed: ()async{
                                      await ProfileServices().createNewFriendRequest(widget.uid, currentUserUid);
                                    }, style: ElevatedButton.styleFrom(
                                        fixedSize: Size(MediaQuery.sizeOf(context).width - 10,60 ),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10)
                                        )
                                    ),child: const Text("Add Friend",
                                        style: TextStyle(
                                            fontFamily: 'mon',

                                            fontSize: 22)));
                                  }
                                }
                              });
                            }
                          }
                        });
                      }
                      else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  )
                    ],
                  ),
                ),
              );
            } else if (state is ProfileErrorState) {
              return Center(
                child: Text(state.error),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

          },
        ),
      ),
    );
  }
}
