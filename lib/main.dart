import 'package:brave/bloc/PostBloc/post_bloc.dart';
import 'package:brave/bloc/commentsBloc/comments_bloc.dart';
import 'package:brave/bloc/dailyThoughtQuery/daily_thought_query_bloc.dart';
import 'package:brave/bloc/friend_request_bloc/friend_request_bloc.dart';
import 'package:brave/bloc/getAllThoughts/get_thought_bloc.dart';
import 'package:brave/bloc/profile_bloc/grid_bloc/get_grid_bloc.dart';
import 'package:brave/bloc/profile_bloc/profile_bloc.dart';
import 'package:brave/bloc/thoughtUpdate/thought_bloc.dart';
import 'package:brave/bloc/userDetails/user_details_bloc.dart';
import 'package:brave/bloc/userFriends/user_friend_bloc.dart';
import 'package:brave/common/theme/theme_manager.dart';
import 'package:brave/firebase_options.dart';
import 'package:brave/view/authentications/login/widgets/link_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return   MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => FriendRequestBloc()),
        BlocProvider(create: (_)=>UserDetailsBloc()),
        BlocProvider(create: (_)=> ThoughtBloc()),
        BlocProvider(create: (_) => GetThoughtBloc()),
        BlocProvider(create: (_)=>ProfileBloc()),
        BlocProvider(create: (_)=> GetGridBloc()),
        BlocProvider(create: (_)=>PostBloc()),
        BlocProvider(create: (_)=>DailyThoughtQueryBloc()),
        BlocProvider(create: (_) => CommentsBloc()),
        BlocProvider(create: (_)=>UserFriendBloc())
      ],
      child: MaterialApp(

        theme: MediaQuery.of(context).platformBrightness == Brightness.light ? lightTheme : darkTheme,
        debugShowCheckedModeBanner: false,
          home: const LinkScreen(),
      ),
    );
  }
}
