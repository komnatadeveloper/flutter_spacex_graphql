import 'package:flutter/material.dart';
import 'package:flutter_spacex_graphql/widgets/smart_launches_refresher.dart';
import 'package:provider/provider.dart';

// Providers
import '../../providers/launch_provider.dart';

class SearchLaunchesScreen extends StatefulWidget {
  const SearchLaunchesScreen({ Key? key }) : super(key: key);

  @override
  State<SearchLaunchesScreen> createState() => _SearchLaunchesScreenState();
}

class _SearchLaunchesScreenState extends State<SearchLaunchesScreen> {
  TextEditingController? _searchTextController;

  // Alert
  bool _isShowingAlert = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchTextController = TextEditingController(text: '');
    
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if ( Provider.of<LaunchProvider>(context, listen: false).errorList.isNotEmpty ) {
      
    }
  }

  Future<void> _showSnackBar ( String errorMessage ) async {
    FocusScope.of(context).requestFocus( FocusNode() );
    if (  _isShowingAlert  ) return;
    // _isAlertFuncRunning = true;
    _isShowingAlert = true;

    int _alertMillisecond = 1500;
    Future.delayed(Duration(milliseconds: 1), () {
      
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

    Future.delayed(Duration(milliseconds: 50), () {
      Provider.of<LaunchProvider>(context, listen: false).removeError();
    });
    Future.delayed(Duration(milliseconds: _alertMillisecond - 5), () {
      _isShowingAlert = false;
      setState(() {
        
      });
    });
    
    return;
  }

  @override
  Widget build(BuildContext context) {
    if ( Provider.of<LaunchProvider>(context).errorList.isNotEmpty ) {
      _showSnackBar(Provider.of<LaunchProvider>(context).errorList[0]);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Missions'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () { FocusScope.of(context).requestFocus( FocusNode() ); },
          child: Container(
            color: Colors.grey[200],
            height: double.infinity,
            width: double.infinity,
            // child: SingleChildScrollView(
              child: Column(
                children: [
                  
                  Expanded(
                    child: Provider.of<LaunchProvider>(context).launchList.length > 0
                      ? 
                      SmartLaunchesRefresher(searchText: _searchTextController!.text)
                      :
                      Provider.of<LaunchProvider>(context).isFetchingLaunches
                        ?
                        Center(child: CircularProgressIndicator())
                        :
                        Container(),
                  ),
                  // if ( Provider.of<LaunchProvider>(context).isFetchingRefreshLaunches) Container( 
                  //   alignment: Alignment.center,
                  //   padding: EdgeInsets.symmetric(vertical: 12),
                  //   child: SizedBox(
                  //     height: 22.5,
                  //     width: 22.5,
                  //     child: CircularProgressIndicator(
                  //       color: Colors.grey,
                  //       value: 8,
                  //     ),
                  //   ),
                  // )

                  Container(
                    width: double.infinity,
                    height: 50,
                    color: Colors.blue,
                    padding: const EdgeInsets.all(4),
                    child: TextField(
                      
                      controller: _searchTextController,
                      onChanged: _isShowingAlert
                        ?
                        null
                        :                      
                        (newVal) {
                          setState(() { });
                          Provider.of<LaunchProvider>(context, listen: false).fetchFilteredLaunches(searchText: newVal, isPullToRefresh: false);
                        },
                      // decoration: InputDecoration(
                      //   prefixIcon: Icon(
                      //     Icons.location_on,
                      //     color: Colors.pink,
                      //   ),
                      //   focusedBorder:  UnderlineInputBorder(
                      //     borderSide:  BorderSide(color: Colors.amber, ),
                      //   )
                      // ),
                      //-------------------------------------------
                      decoration: InputDecoration(
                    hintText: 'Search Missions...',
                    hintStyle: TextStyle(
                      color: Colors.red
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    
                    contentPadding: const EdgeInsets.only(
                        left: 16.0,
                        bottom: 8.0,
                        top: 8.0,
                        right: 16.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    prefixIcon: Icon(Icons.search)

                  ),
                      //-------------------------------------------
                      style: const TextStyle(
                        decorationThickness: 0.0000000001
                      ),
                    ),
                  ),
                  
                ],
              ),
            // ),
          ),
        ),
      ),
      
    );
  }
}