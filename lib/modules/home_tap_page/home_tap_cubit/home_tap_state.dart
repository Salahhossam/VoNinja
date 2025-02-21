import 'package:vo_ninja/models/user_data_model.dart';

import '../../../models/level_progress_model.dart';

abstract class HomeTapState {}

class HomeTapLoading extends HomeTapState {}

class HomeTapLoaded extends HomeTapState {
  final UserDataModel userData;
  final List<LevelsProgressData> levelsData;

  HomeTapLoaded(this.userData, this.levelsData);
}

class HomeTapError extends HomeTapState {
  final String error;

  HomeTapError(this.error);
}
class HomeTapPointsLoaded extends HomeTapState {
  final double points;
  HomeTapPointsLoaded(this.points);
}

class HomeTapRankLoaded extends HomeTapState {
  final double rank;
  HomeTapRankLoaded(this.rank);
}
