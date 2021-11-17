import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

// Models
import '../models/launch_model.dart';



class LaunchProvider with ChangeNotifier {
  bool isFetchingLaunches = false;
  bool isFetchingRefreshLaunches = false;
  List<LaunchModel> launchList = [];
  int fetchLaunchLimit = 10;
  int launchPaginationPage = 0;
  List<String> errorList = [];


  void removeError () {
    if (errorList.isNotEmpty) {
      errorList.removeAt(0);
      Future.delayed( const Duration(milliseconds: 2), () {
        notifyListeners();
      });
    }
  }







  Future<void> fetchFilteredLaunches ({
    required String searchText,    
    int? limit,
    int? offset,
    required bool isPullToRefresh 

  }) async {
    if ( isPullToRefresh == false && launchPaginationPage != 0 ) {
      launchPaginationPage = 0;
    } 
    if ( isPullToRefresh  ) {
      if ( isFetchingRefreshLaunches ) {
        return;
      }
      launchPaginationPage++;
      isFetchingRefreshLaunches = true;
    }
    if ( isPullToRefresh == false ) {
      isFetchingLaunches = true;
    }
    notifyListeners();
    try {      
      var url = 'https://api.spacex.land/graphql';
      var _uri = Uri.parse(url);
      final res = await http.post(
        _uri,
        body: convert.json.encode({
          // {  launches(limit: 10, offset: 10, find: {mission_name: "c"}) {    mission_name     details  }}
          "query": "{ launches( limit: $fetchLaunchLimit, offset:${fetchLaunchLimit * launchPaginationPage} find: {mission_name: \"$searchText\"}) { mission_name details  }}",

          "variables": null
        }),
        headers: {
          'Content-Type': 'application/json'
        },
      );
      final responseData = convert.json.decode( res.body );
      if (  responseData['data'] == null || responseData['data']['launches'] == null ) {
        if ( responseData['errors'] != null  ) {
          var tempErrorList = responseData['errors'] as List;
          for (var element in tempErrorList) { 
            errorList.add( element['message'] as String );
          }
        }
        // print(responseData );
      }
      var responseRawLaunchesList = responseData['data']['launches'] as List<dynamic>;
      List<LaunchModel> tempLaunchList = [];
      for( int i = 0; i < responseRawLaunchesList.length; i++ ) {
        tempLaunchList.add(
          LaunchModel(
            mission_name: responseRawLaunchesList[i]['mission_name'] as String,
            details: responseRawLaunchesList[i]['details']
          )
        );
      }
      if ( isPullToRefresh ) {
        launchList.addAll( tempLaunchList  );
      } 
      else {
        launchList = [ ...tempLaunchList ];
      }

    } catch ( err ) {
      print('LaunchProvider -> fetchFilteredLaunches -> err -> ');
      print(err);
    }
    if ( isPullToRefresh == true ) {
      isFetchingRefreshLaunches = false;
    } else {
      isFetchingLaunches = false;
    }
    notifyListeners();
  }  // End of fetchFilteredLaunches



  



  



}