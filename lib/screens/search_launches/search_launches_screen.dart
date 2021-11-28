import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


// Blocs
import '../../blocs/launches_bloc.dart';
import '../../blocs/launches_state.dart';
import '../../blocs/launches_events.dart' as launchEvents;

// Widgets
import '../../widgets/smart_launches_refresher.dart';
import '../../widgets/alert_tracker_widget.dart';

// Utils
import '../../utils/handle_show_snackbar.dart';

class SearchLaunchesScreen extends StatefulWidget {
  const SearchLaunchesScreen({ Key? key }) : super(key: key);

  @override
  State<SearchLaunchesScreen> createState() => _SearchLaunchesScreenState();
}



//-------------------------------- STATE -------------------------------
class _SearchLaunchesScreenState extends State<SearchLaunchesScreen> {
  TextEditingController? _searchTextController;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchTextController = TextEditingController(text: '');    
  }


  final _textFieldInputDecoration = InputDecoration(
    hintText: 'Search Missions...',
    hintStyle: const  TextStyle(
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
    prefixIcon: const  Icon(Icons.search)
  );

  

  @override
  Widget build(BuildContext context) {
    final _launchesBloc = context.read <LaunchesBloc>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Missions'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () { FocusScope.of(context).requestFocus( FocusNode() ); },
          child: Container(
            color: Colors.grey[200],
            height: double.infinity,
            width: double.infinity,
            child: Column(
              children: [

                // Track, Catch, & Handle Error Alerts
                const AlertTrackerWidget(),
                
                // Loading or Missions
                Expanded(
                  child: BlocBuilder<LaunchesBloc, LaunchesState>(
                    builder: ( context, state ) {
                      return  state.launchList.isNotEmpty
                        ? 
                        const SmartLaunchesRefresher()
                        :
                        (
                          state.isFetchingLaunches
                            ?
                            const Center(child: CircularProgressIndicator())
                            :
                            Container()
                        )
                      ;
                    },
                  )
                ),

                // TextField
                Container(
                  width: double.infinity,
                  height: 50,
                  color: Colors.blue,
                  padding: const EdgeInsets.all(4),
                  child: TextField(                      
                    controller: _searchTextController,
                    onChanged: (newVal) {
                      _launchesBloc.add( launchEvents.LaunchesSearchTextChanged(searchText: newVal) );
                      setState(() {   });
                    },
                    decoration: _textFieldInputDecoration,
                    style: const TextStyle(
                      decorationThickness: 0.0000000001
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
      
    );
  }
}