import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Constants
import '../constants/constants.dart' as constants;

// Models
import '../models/launch_model.dart';

// Screens
import '../screens/launch_detail/launch_detail_screen.dart';



// For future use of some cases
var _navigator = constants.AppStaticConstants.navigatorKey.currentState;


void nextScreen (context, page){
  FocusScope.of(context).requestFocus( FocusNode() );
  _navigator?.push( MaterialPageRoute(
    builder: (context) => page));
}


void nextScreeniOS (context, page){
  FocusScope.of(context).requestFocus( FocusNode() );
  Navigator.of(context).push( 
    CupertinoPageRoute(
      builder: (context) => page
    )
  );
}


void nextScreenCloseOthers (context, page){
  FocusScope.of(context).requestFocus( FocusNode() );
  Navigator.of(context).pushAndRemoveUntil( 
    MaterialPageRoute(builder: (context) => page), (route) => false
  );
}

void nextScreenReplace (context, page){
  FocusScope.of(context).requestFocus( FocusNode() );
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (context) => page)
  );
}


void nextScreenPopup (context, page){
  FocusScope.of(context).requestFocus( FocusNode() );
  Navigator.of(context).push(
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => page
    ),
  );
}


void navigateToLaunchDetailsScreen (
  context, 
  LaunchModel launchModel
){
  nextScreeniOS(
    context, 
    LaunchDetailScreen(
      launchModel: launchModel
    )
  );
}

