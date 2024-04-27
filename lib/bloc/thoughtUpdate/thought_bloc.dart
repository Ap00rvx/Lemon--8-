import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:brave/data/models/thought_model.dart';
import 'package:brave/data/repository/firestore/firestore.dart';
import 'package:meta/meta.dart';

part 'thought_event.dart';
part 'thought_state.dart';

class ThoughtBloc extends Bloc<ThoughtEvent, ThoughtState> {
  ThoughtBloc() : super(ThoughtInitial()) {
   on<UpdateThought>((event, emit) async{
     emit(ThoughtUpdating()) ;
     final str= await FirebaseServices().addThoughtToFirestore(event.model) ;
     if (str  == 'Added SuccessFully'){
       emit(ThoughtUpdated(message: str));
     }
     else {
       emit (ThoughtUpdated(message: "Something went wrong, Please try again later :( "));
     }
   });

  }
}
