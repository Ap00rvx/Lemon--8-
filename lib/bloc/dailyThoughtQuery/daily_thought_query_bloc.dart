import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:brave/data/repository/firestore/firestore.dart';
import 'package:meta/meta.dart';

part 'daily_thought_query_event.dart';
part 'daily_thought_query_state.dart';

class DailyThoughtQueryBloc extends Bloc<DailyThoughtQueryEvent, DailyThoughtQueryState> {
  DailyThoughtQueryBloc() : super(DailyThoughtQueryInitial()) {
   on<DoDailyQuery>((event, emit)async {
     emit(DailyThoughtQueryLoading());
     try {
       await FirebaseServices().thoughtDailyQuery("");
       emit(DailyThoughtQueryLoaded()) ;
     }
     catch(E){
     }
   });
  }
}
