import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


// BLOCS
import './blocs/launches_bloc.dart';

// Screens
import './screens/search_launches/search_launches_screen.dart';

// Constants
import './constants/constants.dart' as constants;


void main() {
  runApp(
    MyApp(  
      navigatorKey: constants.AppStaticConstants.navigatorKey
    )
  );
}




class MyApp extends StatelessWidget {
  // const MyApp({Key? key}) : super(key: key);
  final GlobalKey<NavigatorState> navigatorKey;
  const MyApp({Key? key, required this.navigatorKey}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LaunchesBloc>(
          create: ( context ) => LaunchesBloc(),   
        ),
      ],
      child: MaterialApp(
      title: 'Spacex GraphQL',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SearchLaunchesScreen(),
      ),
    );
  }
}









