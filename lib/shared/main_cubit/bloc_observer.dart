import 'dart:developer';
import '../../modules/taps_page/taps_cubit/taps_cubit.dart';
import '../../modules/taps_page/taps_cubit/taps_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class MyBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    log('onCreate -- ${bloc.runtimeType}');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);

    if (bloc is TapsCubit && change.nextState is SelectTapLoaded) {
      final index = (change.nextState as SelectTapLoaded).index;
      log('onChange -- TapsCubit, index: $index');
    }
    
    log('onChange -- ${bloc.runtimeType}, $change');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log('onError -- ${bloc.runtimeType}, $error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    log('onClose -- ${bloc.runtimeType}');
  }
}