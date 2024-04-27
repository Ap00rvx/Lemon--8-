import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:brave/data/models/thought_model.dart';
import 'package:brave/data/repository/firestore/firestore.dart';
import 'package:meta/meta.dart';

part 'get_thought_event.dart';
part 'get_thought_state.dart';

class GetThoughtBloc extends Bloc<GetThoughtEvent, GetThoughtState> {
  GetThoughtBloc() : super(GetThoughtInitial()) {
   on<GetAllThoughtEvent>((event, emit) async{
     emit(GetThoughtLoading()) ;
     try {
       final list = await  FirebaseServices().getAllThoughts()  ?? [];
       emit(GetThoughtLoaded(data: list));
     }
      catch(e){
       emit(GetThoughtError(error: e.toString()) );
      }
   }) ;
  }
}
