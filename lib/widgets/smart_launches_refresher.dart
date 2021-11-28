import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



// Blocs
import '../../blocs/launches_bloc.dart';
import '../../blocs/launches_events.dart' as launchEvents;


// Widgets
import './launch_list_item_widget.dart';


class SmartLaunchesRefresher extends StatefulWidget {
  const SmartLaunchesRefresher({ 
    Key? key ,
  }) : super(key: key);
  @override
  State<SmartLaunchesRefresher> createState() => _SmartLaunchesRefresherState();
}


// -------------------------------- STATE --------------------------------
class _SmartLaunchesRefresherState extends State<SmartLaunchesRefresher> {
  final RefreshController refreshController =  RefreshController(
    // initialRefresh: true
  );  

  @override
  void dispose() {
    // TODO: implement dispose
    refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _launchesBloc = context.read <LaunchesBloc>();
    
    return Builder(
      builder: (context) {
        final _launchState = context.watch<LaunchesBloc>().state;

        // Track if Response to HTTP Request has been Taken
        if ( _launchState.isRefreshComplete ) {
          refreshController.loadComplete();
        }
        
        return SmartRefresher(
          enablePullDown: false,
          enablePullUp: true,
          controller: refreshController,
          onRefresh: ()  {
            _launchesBloc.add(launchEvents.SmartRefreshPulled() );
          },
          footer: CustomFooter(
            builder: (BuildContext context, LoadStatus? mode){
              Widget body ;
              if(mode==LoadStatus.idle){
                body = const  Text("pull up load");
              }
              else if(mode==LoadStatus.loading){
                body = const CupertinoActivityIndicator();
              }
              else if(mode == LoadStatus.failed){
                body =const Text("Load Failed!Click retry!");
              }
              else if(mode == LoadStatus.canLoading){
                  body =const Text("release to load more");
              }
              else{
                body =const Text("No more Data");
              }
              return  SizedBox(
                height: 55.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    body,
                  ], 
                ),
              );
            },
          ),
          

          onLoading: ()  {
           // we CALCULATE THAT there are no more launch...
            if( _launchState.isNoMoreLaunchItemOnApi ) {
              return refreshController.loadNoData();
            }
            // at LAST FETCH there was NO LAUNCH on API
            if ( _launchState.isNoMoreLaunchOnApi ) {
              return refreshController.loadComplete();
            }
            // We may possibly have more launch item on API
            if ( _launchState.isPossibleToHaveMoreLanchItemOnApi ) {
              return _launchesBloc.add(launchEvents.SmartRefreshPulled() );
            }            
          },

          child: _launchState.isFetchingLaunches
            ?
            const Center(child: CircularProgressIndicator())
            :      
            ListView.builder(
              itemBuilder: (context, ind) {
                final _launchItem = _launchState.launchList[ind];
                return LaunchListItemWidget(launchModel: _launchItem,);
              }, 
              itemCount: _launchState.launchList.length
            ),
          
        );
      }
    );
  }
}