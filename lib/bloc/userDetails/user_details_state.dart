part of 'user_details_bloc.dart';

@immutable
abstract class UserDetailsState {}

class UserDetailsInitial extends UserDetailsState {}
class UserDetailsLoadingState extends UserDetailsState{}
class UserDetailsLoadedState extends UserDetailsState{
  final UserModel usermodel ;
  UserDetailsLoadedState({required this.usermodel});
}
class UserDetailsErrorState extends UserDetailsState{
  final String error ;

  UserDetailsErrorState({required this.error});

}

