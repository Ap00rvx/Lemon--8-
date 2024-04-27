import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:brave/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'friend_request_event.dart';
part 'friend_request_state.dart';

class FriendRequestBloc extends Bloc<FriendRequestEvent, FriendRequestState> {
  FriendRequestBloc() : super(FriendRequestInitial()) {
  on<GetFriendRequestEvent>((event, emit) async{
    emit(FriendRequestLoading()) ;
    try {
      final firebase  = FirebaseFirestore.instance;
      final collection = firebase.collection('request');
      final userdocument = await collection.doc(event.userId ).get();
      if(userdocument.exists){
        List<UserModel> requestedUsers =[]; 
        final requestIds= userdocument.data()!['requests'] as List;
        final allUserDocument = await firebase.collection('user').get();

        final users = allUserDocument.docs;
        for(QueryDocumentSnapshot user in users){
          final json = user.data()  as Map<String,dynamic>;
          final uid = json['uid'];
          if(requestIds.contains(uid)){
            print(json);
             final user = UserModel.fromJson(json);
             requestedUsers.add(user);
          }
        }
        print("loop ");

        emit(FriendRequestLoaded(requests: requestedUsers));

      }
      else{
        emit(FriendRequestLoaded(requests: const []));
      }

    }
    catch (e){

    }
  });
  }
}
