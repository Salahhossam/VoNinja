

abstract class TapsState {}

class TapsInitial extends TapsState {}

class SelectTapLoaded extends TapsState {
  final int index;
  SelectTapLoaded(this.index);
}

class SelectTapError extends TapsState {
  final String message;
  SelectTapError(this.message);
}

class Success extends TapsState {}

class UpdateActiveStatusSuccess extends TapsState {}

class UnifiedTutorialRequested extends TapsState {}