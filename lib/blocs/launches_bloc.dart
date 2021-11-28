
import 'package:bloc/bloc.dart';



// Models
import '../models/launch_model.dart';

// State & Events
import './launches_events.dart' as launchEvents;
import './launches_state.dart';

// Services
import '../service/launches/launches_service.dart';





class LaunchesBloc extends Bloc<launchEvents.LaunchesEvent, LaunchesState> {






  LaunchesBloc()
      : super(const LaunchesState.initial()) {
    on<launchEvents.LaunchesSearchTextChanged>(_handleSearchTextChange);
    on<launchEvents.SmartRefreshPulled>(_handlePullSmartRefresh);
  } 

  



  void _handleSearchTextChange(
    launchEvents.LaunchesSearchTextChanged event  ,
    Emitter<LaunchesState> emit,
  ) async {
    // Check if text.length < 4
    if ( event.searchText.length < 4 ) {
      emit(
        LaunchesState.searchTextHasNotEnoughLength(
          searchText: event.searchText,
        )
      );
      return;
    }    
    // Set Loading
    emit(
      LaunchesState.setLoadingForFetchingLaunches(
        searchText: event.searchText,
      )
    );    
    // HTTP Request
    var _serviceResponse = await fetchFilteredLaunches(
      searchText: event.searchText, 
      launchPaginationPage: 0, 
      fetchLaunchLimit: state.fetchLaunchLimit
    );
    // If Error
    if(_serviceResponse.errorList != null ) {
      emit(
        LaunchesState.existsFetchLaunchesRequestErrors(
          errorList: _serviceResponse.errorList!,
        )
      );
      return;
    }
    // update Launch List
    if ( _serviceResponse.apiResponse != null  ) {
      emit(
        state.copyWith(
          launchList:_serviceResponse.apiResponse as List<LaunchModel>,
          isFetchingLaunches: false,
          isFetchingRefreshLaunches: false
        )
      );
    }
  }  // End of _handleSearchTextChange



  void _handlePullSmartRefresh(
    launchEvents.SmartRefreshPulled event  ,
    Emitter<LaunchesState> emit,
  ) async {
    var currentPagination = state.launchPaginationPage;
    // Seat Loading
    emit(
      state.copyWith( 
        isFetchingRefreshLaunches: true, 
        launchPaginationPage: state.launchPaginationPage + 1,
        isRefreshComplete: false
      )
    ); 
    // HTTP Request
    var _serviceResponse = await fetchFilteredLaunches(
      searchText: state.searchText, 
      launchPaginationPage: currentPagination + 1, 
      fetchLaunchLimit: state.fetchLaunchLimit
    );
    // If Error
    if(_serviceResponse.errorList != null ) {
      emit(
        state.copyWith(
          errorList: _serviceResponse.errorList!,
          isRefreshComplete: true,
        )
      );
      return;
    }
    // update Launch List
    if ( _serviceResponse.apiResponse != null  ) {
      var _fetchedLaunchesList = _serviceResponse.apiResponse as List<LaunchModel>;
      emit(
        state.copyWith(
          isFetchingRefreshLaunches: false,
          launchList: [
            ...state.launchList,
            ..._fetchedLaunchesList,
            
          ],
          isNoMoreLaunchOnApi: _fetchedLaunchesList.isEmpty,
          isRefreshComplete: true,
        )
      );
    }
  }  // End of _handleSearchTextChange


  
}