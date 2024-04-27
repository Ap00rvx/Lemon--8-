part of 'thought_bloc.dart';

@immutable
abstract class ThoughtEvent {}
class UpdateThought extends ThoughtEvent{
  final ThoughtModel model ;

  UpdateThought({required this.model});

}