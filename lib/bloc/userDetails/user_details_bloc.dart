import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:brave/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'user_details_event.dart';
part 'user_details_state.dart';

class UserDetailsBloc extends Bloc<UserDetailsEvent, UserDetailsState> {
  UserDetailsBloc() : super(UserDetailsInitial()) {
   final _firebase = FirebaseAuth.instance;
   on<GetUserDetailsEvent>((event, emit) async {
     emit(UserDetailsLoadingState());
     final uid = _firebase.currentUser!.uid;
     final _firestore = FirebaseFirestore.instance ;
     try {
       final document  =  await _firestore.collection('user').doc(uid).get();
       final json = document.data()! ;
       print(json);
       final userModel  = UserModel.fromJson(json) ;
       emit(UserDetailsLoadedState(usermodel: userModel)) ;
     }catch (e){
       emit(UserDetailsErrorState(error: e.toString())) ;
     }
    });
  }
}
