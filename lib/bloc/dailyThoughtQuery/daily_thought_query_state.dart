part of 'daily_thought_query_bloc.dart';

@immutable
abstract class DailyThoughtQueryState {}

class DailyThoughtQueryInitial extends DailyThoughtQueryState {}
class DailyThoughtQueryLoaded extends DailyThoughtQueryState {}
class DailyThoughtQueryLoading extends DailyThoughtQueryState {}
