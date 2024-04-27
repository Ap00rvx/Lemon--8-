part of 'thought_bloc.dart';

@immutable
abstract class ThoughtState {}


class ThoughtUpdating extends ThoughtState{}
class ThoughtInitial extends ThoughtState{}
class ThoughtUpdated extends ThoughtState{
  final String message ;

  ThoughtUpdated({required this.message});

}
class ThoughtError extends ThoughtState{
  final String error ;
  ThoughtError({required this.error});
}
