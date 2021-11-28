import 'package:equatable/equatable.dart';

// Models
import '../models/launch_model.dart';


class LaunchesState extends Equatable {

      final String searchText;
      final bool isFetchingLaunches;
      final bool isFetchingRefreshLaunches;
      final List<LaunchModel> launchList;
      final int launchPaginationPage;
      final List<String> errorList;
      final bool isNoMoreLaunchOnApi;
      final bool isRefreshComplete;
      // constant
      final int fetchLaunchLimit = 10;

  const LaunchesState._({
    this. searchText = '',
      this. isFetchingLaunches = false,
      this. isFetchingRefreshLaunches = false,
      this. launchList = const [],
      // this fetchLaunchLimit = 10,
      this. launchPaginationPage = 0,
      this. errorList = const [],
      this. isNoMoreLaunchOnApi = false,
      this.isRefreshComplete = false,
  });

  const LaunchesState.initial() : this._();

  const LaunchesState.searchTextHasNotEnoughLength({
    required String searchText
  }) : this._(
    launchList: const [],
    searchText: searchText,
    launchPaginationPage: 0
  );

  const LaunchesState.setLoadingForFetchingLaunches({
    required String searchText,
    bool isFetchingRefreshLaunches = false
  }) : this._(
    isFetchingLaunches: isFetchingRefreshLaunches ? false : true, 
    isFetchingRefreshLaunches: isFetchingRefreshLaunches ? true : false, 
    searchText: searchText ,
    launchPaginationPage: 0
  );


  const LaunchesState.existsFetchLaunchesRequestErrors({
    required List<String> errorList
  }) : this._(
    errorList: errorList,
    launchList: const  [],
    isFetchingLaunches: false,
    isFetchingRefreshLaunches: false,    
  );

  bool get isNoMoreLaunchItemOnApi {
      int _launchListLength = launchList.length;

      bool _isRemainderZero = // is there possibly more launch on DB? 
              _launchListLength%fetchLaunchLimit == 0;

    if (  _launchListLength == 0 ||  !_isRemainderZero ) {
      return true;
    }
    return false;
  }

  bool get isPossibleToHaveMoreLanchItemOnApi {
    int _launchListLength = launchList.length;
    bool _isRemainderZero = // is there possibly more launch on DB? 
              _launchListLength%fetchLaunchLimit == 0;
    if ( launchList.isNotEmpty && _isRemainderZero == true && searchText.isNotEmpty ) {
      return true;
    }
    return false;
  }





  LaunchesState copyWith ({
    String? searchText,
    bool? isFetchingLaunches,
    bool? isFetchingRefreshLaunches,
    List<LaunchModel>? launchList,
    int? launchPaginationPage,
    List<String>? errorList,
    bool? isNoMoreLaunchOnApi,
    bool? isRefreshComplete,

  }) {
    return LaunchesState._(
      searchText: searchText ?? this.searchText,
      isFetchingLaunches: isFetchingLaunches ?? this.isFetchingLaunches,
      isFetchingRefreshLaunches : isFetchingRefreshLaunches ?? this.isFetchingRefreshLaunches,
      launchList : launchList ?? this.launchList,
      launchPaginationPage : launchPaginationPage ?? this.launchPaginationPage,
      errorList : errorList ?? this.errorList,
      isNoMoreLaunchOnApi : isNoMoreLaunchOnApi ?? this.isNoMoreLaunchOnApi,
      isRefreshComplete : isRefreshComplete ?? this.isRefreshComplete,
    );
  }



  @override
  List<Object?> get props => [
    searchText, 
    isFetchingLaunches, 
    isFetchingRefreshLaunches, 
    launchList, 
    launchPaginationPage, 
    errorList,
    isNoMoreLaunchItemOnApi,
    isPossibleToHaveMoreLanchItemOnApi
  ];

}