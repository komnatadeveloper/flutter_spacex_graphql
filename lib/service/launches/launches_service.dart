import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

// Models
import '../../models/launch_model.dart';
import '../../models/service_response_model.dart';




Future< ServiceResponseModel > fetchFilteredLaunches ({
    required String searchText,    
    required int launchPaginationPage,
    required int fetchLaunchLimit,

  }) async {
    var errorList = <String>[];
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
      // Errors      
      if (  responseData['data'] == null || responseData['data']['launches'] == null ) {
        if ( responseData['errors'] != null  ) {
          var tempErrorList = responseData['errors'] as List;
          for (var element in tempErrorList) { 
            errorList.add( element['message'] as String );
          }
        }
      }
      // End of Errors
      var responseRawLaunchesList = responseData['data']['launches'] ?? const [];
      List<LaunchModel> tempLaunchList = [];
      for( int i = 0; i < responseRawLaunchesList.length; i++ ) {
        tempLaunchList.add(
          LaunchModel(
            mission_name: responseRawLaunchesList[i]['mission_name'] as String,
            details: responseRawLaunchesList[i]['details']
          )
        );
      }
      return ServiceResponseModel(
        apiResponse: tempLaunchList,
        errorList: errorList.isNotEmpty ? errorList : null
      );




    } catch ( err ) {
      print('services -> launches -> fetchFilteredLaunches -> err -> ');
      print(err);
      return ServiceResponseModel(
        apiResponse: null,
        errorList: ['Unidentified Server Error']
      );
    }
  }  // End of fetchFilteredLaunches