import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:brave/data/repository/firestore/profile_services.dart';
import 'package:meta/meta.dart';

part 'user_friend_event.dart';
part 'user_friend_state.dart';

class UserFriendBloc extends Bloc<UserFriendEvent, UserFriendState> {
  UserFriendBloc() : super(UserFriendInitial()) {
   on<GetUserFriends>((event, emit) async {
     emit(UserFriendsLoading());
     try {
       final data = await ProfileServices().getUserFriends(event.useruid);
       emit(UserFriendsLoaded(friends: data)) ;
     }catch (e){
       print(e.toString());
       emit(UserFriendsError()) ;
     }
   });
  }
}
