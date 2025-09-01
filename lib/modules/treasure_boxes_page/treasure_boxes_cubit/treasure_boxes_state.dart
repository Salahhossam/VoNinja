abstract class TreasureBoxState {}

class TreasureBoxInitial extends TreasureBoxState {}

class TreasureBoxLoading extends TreasureBoxState {}

class TreasureBoxUpdated extends TreasureBoxState {} // لما متغيرات الكيوبت تتغيّر

class TreasureBoxSuccess extends TreasureBoxState {}

class TreasureBoxFailure extends TreasureBoxState {
  final String errorMessage;
  TreasureBoxFailure(this.errorMessage);
}

class TreasureBoxMessage extends TreasureBoxState {
  final String message;
  TreasureBoxMessage(this.message);
}


