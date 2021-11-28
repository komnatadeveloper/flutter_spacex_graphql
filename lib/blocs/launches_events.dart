



abstract class LaunchesEvent{}



class LaunchesSearchTextChanged extends LaunchesEvent {
  final String searchText;
  LaunchesSearchTextChanged({ required this.searchText });
}

class SmartRefreshPulled extends LaunchesEvent {
  // final String searchText;
  SmartRefreshPulled();
}