import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vo_ninja/models/pdf_book_model.dart';

import '../../../shared/constant/constant.dart';
import 'library_state.dart';


class LibraryCubit extends Cubit<LibraryState> {
  LibraryCubit() : super(LibraryInitial());

  static LibraryCubit get(context) {
    return BlocProvider.of(context);
  }

  bool loading = false;

  List<PdfBook> pdfBooks = [];

  Future<void> getAllPdfBooks(String uid) async {

    emit(PdfBooksLoading()); // Emit loading state

    try {
      // Get all documents from the pdfBooks collection ordered by createdAt
      final querySnapshot = await fireStore
          .collection('library')
          .orderBy('createdAt', descending: true) // or false for ascending
          .get();

      // Process each document asynchronously to check lock status
      pdfBooks = await Future.wait(querySnapshot.docs.map((doc) async {
        final pdfBook = PdfBook.fromMap(doc.data());

        // Check if book is locked by seeing if user exists in the library subcollection
        try {
          final libraryDoc = await fireStore
              .collection('library')
              .doc(doc.id)
              .collection('users')
              .doc(uid)
              .get();

          pdfBook.isLocked = !libraryDoc.exists;
        } catch (e) {
          pdfBook.isLocked = true; // Assume locked if there's an error
        }

        return pdfBook;
      }));


      emit(PdfBooksLoaded()); // Emit loaded state with the list

    } catch (error) {

      emit(PdfBooksError(error.toString())); // Emit error state
    }
  }

  double userPoints = 0;

  Future<void> getUserPoints(String uid) async {
    emit(LibraryLoading()); // Use your library loading state
    try {
      var response = await fireStore.collection(USERS).doc(uid).get();

      if (response.exists) {
        // Update userPoints directly from Firestore
        userPoints = (response.data()?['pointsNumber'] as num?)?.toDouble() ?? 0.0;

        emit(LibraryLoaded()); // Use your library loaded state
      } else {
        emit(LibraryError("User document not found"));
      }
    } catch (error) {
      emit(LibraryError(error.toString()));
    }
  }


  Future<void> deductUserPoints(String uid, num pointsToDeduct,String bookId) async {
    loading=true;
    // 1. Emit loading state at start
    emit(LibraryPointsDeductionLoading());

    try {
      final userDoc = await fireStore.collection(USERS).doc(uid).get();



      final currentPoints = (userDoc.data()?['pointsNumber'] as num?)?.toDouble() ?? 0.0;
      final newPoints = currentPoints - pointsToDeduct;


      await fireStore.collection(USERS).doc(uid).update({
        'pointsNumber': newPoints,
      });

      userPoints = newPoints;
      await fireStore.collection('library').doc(bookId)
          .collection('users')
          .doc(uid).set({
        'uid':uid
      });
      pdfBooks = pdfBooks.map((book) {
        if (book.id == bookId) {
          return book.copyWith(isLocked: false); // Assuming you have a copyWith method
        }
        return book;
      }).toList();
      loading=false;

      // 4. Emit success state with new points data
      emit(LibraryPointsDeductedSuccessfully(newPoints: newPoints));

    } catch (error) {
      loading=false;
      // 5. Emit error if anything fails
      emit(LibraryPointsError("Deduction failed: ${error.toString()}"));
    }
  }



}
