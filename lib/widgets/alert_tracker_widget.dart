import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


// Blocs
import '../../blocs/launches_bloc.dart';
import '../../blocs/launches_state.dart';



// Utils
import '../../utils/handle_show_snackbar.dart';


class AlertTrackerWidget extends StatelessWidget {
  const AlertTrackerWidget({ Key? key }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LaunchesBloc, LaunchesState>(
      builder: ( context, state ) {
        return  Container( );
      },
      buildWhen: ( previous, current ) {
        if( previous.errorList.length < current.errorList.length ) {
          handleShowSnackBar(errorMessage: current.errorList[ previous.errorList.length ], context: context);
          return true;
        }
        return false;
      },
    );
  }
}