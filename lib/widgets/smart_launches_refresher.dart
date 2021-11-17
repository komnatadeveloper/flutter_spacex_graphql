import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:provider/provider.dart';


// Providers
import '../providers/launch_provider.dart';

// Widgets
import 'package:flutter_spacex_graphql/widgets/launch_list_item_widget.dart';


class SmartLaunchesRefresher extends StatefulWidget {
  final String searchText;
  const SmartLaunchesRefresher({ 
    Key? key ,
    required this.searchText
  }) : super(key: key);

  @override
  State<SmartLaunchesRefresher> createState() => _SmartLaunchesRefresherState();
}

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
    return SmartRefresher(
      enablePullDown: false,
      enablePullUp: true,
      controller: refreshController,
      onRefresh: () async {
        await Provider.of<LaunchProvider>(context, listen: false).fetchFilteredLaunches(searchText: widget.searchText, isPullToRefresh: true);
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
      

      onLoading: () async {
        int _launchListLength = // do we have any launch?
          Provider.of<LaunchProvider>(context, listen: false).launchList.length;

        int _fetchLaunchLimit = Provider.of<LaunchProvider>(context, listen: false).fetchLaunchLimit;

        bool _isRemainderZero = // is there possibly more launch on DB? 
          _launchListLength%_fetchLaunchLimit == 0;

        if ( _launchListLength == 0 ) {
          return refreshController.loadNoData();
        }
        if ( !_isRemainderZero  ) {
          return refreshController.loadNoData();
        }




          
        if ( 
          // do we have any launch?
          _launchListLength > 0
          &&
          _isRemainderZero == true
          &&
          widget.searchText.length > 0
        ) {
          await Provider.of<LaunchProvider>(context, listen: false).fetchFilteredLaunches(
            searchText: widget.searchText,
            isPullToRefresh: true
          );
          refreshController.loadComplete();
        } else {
          refreshController.loadComplete();
        }
      },
      child: Provider.of<LaunchProvider>(context).isFetchingLaunches
        ?
        const Center(child: CircularProgressIndicator())
        :      
        ListView.builder(
          itemBuilder: (context, ind) {
            final _launchItem = Provider.of<LaunchProvider>(context, listen: false).launchList[ind];
            return LaunchListItemWidget(launchModel: _launchItem,);
          }, 
          itemCount: Provider.of<LaunchProvider>(context).launchList.length
        ),
      
    );
  }
}