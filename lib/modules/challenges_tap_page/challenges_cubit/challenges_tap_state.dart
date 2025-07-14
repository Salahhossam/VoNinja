import '../../../models/challenge_tap_model.dart';

abstract class ChallengeTapState {}

class ChallengeTapLoading extends ChallengeTapState {}

class ChallengeTapLoaded extends ChallengeTapState {


  ChallengeTapLoaded();
}

class ChallengeTapError extends ChallengeTapState {
  final String error;

  ChallengeTapError(this.error);
}
