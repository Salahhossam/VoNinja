abstract class LibraryState {}

class LibraryInitial extends LibraryState {}

class PdfBooksLoading extends LibraryState {}

class PdfBooksLoaded extends LibraryState {}

class PdfBooksError extends LibraryState {
  final String message;

  PdfBooksError(this.message);
}


class LibraryLoading extends LibraryState {}

class LibraryLoaded extends LibraryState {}

class LibraryError extends LibraryState {
  final String message;

  LibraryError(this.message);
}

class LibraryPointsDeductionLoading extends LibraryState {}

class LibraryPointsDeductedSuccessfully extends LibraryState {
  final double newPoints;
  LibraryPointsDeductedSuccessfully({required this.newPoints});
}

class LibraryPointsError extends LibraryState {
  final String message;
  LibraryPointsError(this.message);
}
