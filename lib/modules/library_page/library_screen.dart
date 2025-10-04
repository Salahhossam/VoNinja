import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:vo_ninja/modules/library_page/library_cubit/library_cubit.dart';
import 'package:vo_ninja/modules/library_page/library_cubit/library_state.dart';
import 'package:vo_ninja/modules/library_page/pdf_viewer_screen.dart';
import 'package:vo_ninja/shared/style/color.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


import '../../generated/l10n.dart';
import '../../models/pdf_book_model.dart';
import '../../shared/local_awesome_dialog.dart';
import '../../shared/network/local/cash_helper.dart';
import '../taps_page/taps_page.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  bool isLoading=true;

   Future<void> initData() async {
     final cubit = LibraryCubit.get(context);
     setState(() {
       isLoading = true;
     });
     WidgetsBinding.instance.addPostFrameCallback((_) {
       Future.microtask(() async {
         String uid = await CashHelper.getData(key: 'uid');
         await cubit.getAllPdfBooks(uid);
         await cubit.getUserPoints(uid);
         setState(() {
           isLoading = false;
         });
       });

     });
   }
   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = LibraryCubit.get(context);
    return BlocConsumer<LibraryCubit,LibraryState>(
        listener: (context,state){},
        builder: (context,state){
          return  Scaffold(
            backgroundColor: AppColors.lightColor,
            appBar: AppBar(
              title: Text(S.of(context).libraryTitle, style: const TextStyle(color: Colors.white)),
              centerTitle: true,
              backgroundColor: AppColors.mainColor,
              iconTheme: const IconThemeData(color: Colors.white),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const TapsPage()),
                        (route) => false,  // يزيل كل الصفحات السابقة
                  );
                },
              ),
            ),
            body: LoadingOverlay(
              isLoading: cubit.loading,
              progressIndicator: const Center(
                child: Image(
                  image: AssetImage(
                      'assets/img/ninja_gif.gif'),
                  height: 100,
                  width: 100,
                ),
              ),
              child: WillPopScope(
                onWillPop: () async {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const TapsPage()),
                  );
                  return true;
                },
                child: isLoading?const Center(
                  child: Image(
                    image: AssetImage('assets/img/ninja_gif.gif'),
                    height: 100,
                    width: 100,
                  ),
                ):
                ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: cubit.pdfBooks.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return _buildPdfItem(context, cubit.pdfBooks[index]);
                  },
                ),
              ),
            ),
          );
        },

    );
  }

  Widget _buildPdfItem(BuildContext context, PdfBook book) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: AppColors.secondColor,
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (book.isLocked!) {
            _showLockedDialog(context, book);
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PDFScreen(pdfBook: book),
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: FaIcon(
                    FontAwesomeIcons.filePdf,
                    color: book.isLocked! ? Colors.grey : AppColors.secondColor,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title??'',
                      style: const TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                    if (book.isLocked!)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '${book.requiredPoint} points required',
                          style: TextStyle(
                            color: AppColors.whiteColor.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (book.isLocked!)
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(
                    Icons.lock,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.whiteColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLockedDialog(BuildContext context, PdfBook book) {
    final cubit = LibraryCubit.get(context);
    final hasEnoughPoints = cubit.userPoints >= book.requiredPoint!;

    LocalAwesomeDialog(
      context: context,
      dialogType: LocalDialogType.question,
      title: 'Book Locked',
      desc: 'You need ${book.requiredPoint} points to unlock this book.\n'
          'Your current points: ${cubit.userPoints}\n\n'
          '${hasEnoughPoints ? 'Do you want to unlock it using your points?' : 'You don\'t have enough points to unlock this book.'}',
      btnOkText: 'Unlock',
      btnCancelText: 'Cancel',
      btnOkColor: hasEnoughPoints ? AppColors.mainColor : Colors.grey,
      btnCancelColor: Colors.grey,
      btnOkOnPress: hasEnoughPoints ? () async {
        // Show loading dialog


        try {
          String uid = await CashHelper.getData(key: 'uid');
          await cubit.deductUserPoints(uid, book.requiredPoint!, book.id!);


          // Show success dialog
          LocalAwesomeDialog(
            context: context,
            dialogType: LocalDialogType.success,
            title: 'Book Unlocked!',
            desc: '${book.requiredPoint} points have been deducted.\nYou can now access the book.',
            btnOkOnPress: () {
              // Update the book status to unlocked
              setState(() {
                book.isLocked = false;
              });
              // Open the book
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PDFScreen(pdfBook: book),
                ),
              );
            },
            btnOkColor: AppColors.mainColor,
          ).show();
        } catch (error) {
          // Close loading dialog
          Navigator.of(context).pop();

          // Show error dialog
          LocalAwesomeDialog(
            context: context,
            dialogType: LocalDialogType.error,
            title: 'Error',
            desc: 'Failed to unlock book: ${error.toString()}',
            btnOkColor: AppColors.mainColor,
          ).show();
        }
      } : null,
      btnCancelOnPress: () {},
    ).show();
  }
}