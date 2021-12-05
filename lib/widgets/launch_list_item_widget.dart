import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



// Blocs
import '../../blocs/launches_bloc.dart';
import '../../blocs/launches_events.dart' as launchEvents;

// Models
import '../models/launch_model.dart';
import '../screens/launch_detail/launch_detail_screen.dart';


class LaunchListItemWidget extends StatelessWidget {
  final LaunchModel launchModel;
  const LaunchListItemWidget({ 
    Key? key ,
    required this.launchModel
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _launchesBloc = context.read <LaunchesBloc>();


    return GestureDetector(
      onTap: () { FocusScope.of(context).requestFocus( FocusNode() ); },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric( horizontal: 16, vertical: 8),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.grey,
            padding:const EdgeInsets.all(12)
          ),
          onPressed: () { 
            _launchesBloc.add(
                launchEvents.MissionItemClicked(
                context: context,
                launchModel: launchModel
              ) 
            );         
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(launchModel.mission_name), 
              const Icon(
                Icons.info_outline_rounded
              )
            ],
          ),
        ),        
      ),
    );
  }
}