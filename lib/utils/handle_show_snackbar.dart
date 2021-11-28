import 'package:flutter/material.dart';


Future<void> handleShowSnackBar ({ 
  required String errorMessage ,
  required BuildContext context
}) async {
  FocusScope.of(context).requestFocus( FocusNode() );

  int _alertMillisecond = 1500;
  Future.delayed(const Duration(milliseconds: 1), () {
    
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(
          milliseconds: _alertMillisecond
        ),
        content: Text(
          errorMessage,
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.redAccent,            
      ),
    ); 
  });
}


