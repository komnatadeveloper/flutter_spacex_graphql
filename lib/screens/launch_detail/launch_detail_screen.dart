import 'package:flutter/material.dart';

// Models
import '../../models/launch_model.dart';


class LaunchDetailScreen extends StatelessWidget {
  
  final LaunchModel launchModel;
  const LaunchDetailScreen({ 
    required this.launchModel,
    Key? key 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text( 
          'Mission Details',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () { FocusScope.of(context).requestFocus( FocusNode() ); },
          child: Container(
            color: Colors.grey[200],
            height: double.infinity,
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // SizedBox(height: 40,),
                  Text( 
                    launchModel.mission_name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 16,),
                  Text(
                    launchModel.details ??'NO INFORMATION!',
                    style: const  TextStyle(
                      height: 1.5,
                      fontSize: 16
                    ),
                  )
                  
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}