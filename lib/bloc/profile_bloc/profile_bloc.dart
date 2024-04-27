

import 'package:bloc/bloc.dart';
import 'package:brave/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    final _firebase = FirebaseAuth.instance ;
    on<GetUserProfilePageEvent>((event, emit) async{
      emit(ProfileLoadingState());
      final uid = event.uid;
      final _firestore = FirebaseFirestore.instance ;
      try {
        final document  =  await _firestore.collection('user').doc(uid).get();
        final json = document.data()! ;
        print(json);
        final userModel  = UserModel.fromJson(json) ;
        emit(ProfileLoadedState(userModel: userModel)) ;
      }catch (e){
        emit(ProfileErrorState(error: e.toString())) ;
      }
    });
  }
}
