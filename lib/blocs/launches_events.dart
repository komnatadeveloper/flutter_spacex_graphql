import 'package:flutter/material.dart';

// Models
import '../models/launch_model.dart';


abstract class LaunchesEvent{}



class LaunchesSearchTextChanged extends LaunchesEvent {
  final String searchText;
  LaunchesSearchTextChanged({ required this.searchText });
}

class SmartRefreshPulled extends LaunchesEvent {
  // final String searchText;
  SmartRefreshPulled();
}

class MissionItemClicked extends LaunchesEvent {
  final BuildContext context;
  final LaunchModel launchModel;
  MissionItemClicked({
    required this.context,
    required this.launchModel
  });
}