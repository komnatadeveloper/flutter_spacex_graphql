import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


// Screens
import './screens/search_launches/search_launches_screen.dart';

// BLOCS
import './blocs/launches_bloc.dart';



void main() {
  runApp(const MyApp());
}




class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<LaunchesBloc>(
      create: ( context ) => LaunchesBloc(),
      child:    MaterialApp(
      title: 'Spacex GraphQL',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SearchLaunchesScreen(),
      )
    );
  }
}


