import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vo_ninja/generated/l10n.dart';
import 'package:vo_ninja/modules/lessons_page/exam_page.dart';
import 'package:vo_ninja/shared/style/color.dart';
import '../../../models/lesson_page_model.dart';
import '../../../models/lesson_progress_model.dart';
import '../../../shared/constant/constant.dart';
import '../lesson_learning.dart';
import 'lessons_state.dart';

class LessonCubit extends Cubit<LessonState> {
  LessonCubit() : super(LessonInitial());
  static LessonCubit get(context) {
    return BlocProvider.of(context);
  }

  LessonsPage? lessonsPage;
  List<LearningProgressDto> learningProgress = [];

  List<LessonCard> lessonCards = [];
  DocumentSnapshot? lastDocument;

  Future<void> getLessonsPageData(String uid, String? levelId,
      String? collectionName, bool loadMore, double rewardedPoints,
      {int numLesson = 5}) async {
    emit(LessonLoading());

    try {
      Query query = fireStore
          .collection('levels')
          .doc(levelId)
          .collection(collectionName ?? '')
          .where('status', isEqualTo: 'PUBLISHED')
          .orderBy('lesson_order')
          .limit(numLesson);

      // If loadMore is true and we have a last document, start after it
      if (loadMore && lastDocument != null) {
        query = query.startAfterDocument(lastDocument!);
      } else {
        lessonCards = [];
        learningProgress = [];
      }

      QuerySnapshot lessonsSnapshot = await query.get();

      // Stop loading if there's no more data
      if (lessonsSnapshot.docs.isEmpty) {
        return;
      }

      for (var doc in lessonsSnapshot.docs) {
        String lessonId = doc.id;

        double points = 0;
        double userPoints = 0; // User points calculated from grade field
        double questionsCount = 0;
        double userProgress = 0;

        LessonCard lessonCard =
            LessonCard.fromJson(doc.data() as Map<String, dynamic>);

        points = doc['numQuestions'] * rewardedPoints;

        questionsCount = doc['numQuestions'].toDouble();

        // Fetch the user's answers and retrieve the 'grade' field
        QuerySnapshot userAnswersSnapshot = await fireStore
            .collection('users')
            .doc(uid)
            .collection('answers')
            .where('lessonId', isEqualTo: lessonId)
            .get();

        int answeredQuestions = userAnswersSnapshot.docs.length;
        double lessonProgress = 0.0;

        if (answeredQuestions > 0 &&
            lessonCard.numberOfQuestion != null &&
            lessonCard.numberOfQuestion! > 0) {
          lessonProgress = answeredQuestions / lessonCard.numberOfQuestion!;
        }

        // Calculate userPoints based on grades from answers
        for (var answerDoc in userAnswersSnapshot.docs) {
          double grade =
              (answerDoc['grade'] ?? 0).toDouble(); // Get the 'grade' field
          userPoints += grade; // Accumulate userPoints based on grades
        }

        // Update lesson progress
        lessonCard.levelProgress =
            double.parse(lessonProgress.toStringAsFixed(2));
        userProgress = double.parse(lessonProgress.toStringAsFixed(2));

        lessonCards.add(lessonCard);
        learningProgress.add(LearningProgressDto(
            lessonId: lessonId,
            points: points,
            userPoints: userPoints,
            questionsCount: questionsCount,
            userProgress: userProgress));
      }

      // Update last document for next pagination
      lastDocument = lessonsSnapshot.docs.last;

      emit(LessonLoaded());
    } catch (error) {
      emit(LessonError(error.toString()));
    }
  }
}

void showLessonDialog(
  BuildContext context,
  String lessonId,
  double order,
  String title,
  double points,
  double questionsCount,
  String levelId,
  double page,
  double size,
  double userPoints,
  String collectionName,
  double rewardedPoints,
  double deducedPoints,
) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
        insetPadding:
            const EdgeInsets.all(20), // Adjust inset padding as needed
        content: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.mainColor, // Dark background
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.secondColor.withOpacity(1), // Shadow color
                spreadRadius: 3, // Spread of the shadow
                blurRadius: 2, // Blur effect
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // This makes the dialog fit content

            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Circular Badge for Lesson Number
              CircleAvatar(
                backgroundColor: AppColors.secondColor,
                radius: 25,
                child: Text(
                  '${order.toInt()}',
                  style: const TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Lesson Name
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              // Points and Questions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset(
                    'assets/img/fane.png', // Replace with your image path
                    width: 25,
                    height: 25,
                    color: AppColors.whiteColor, // Make the icon white
                  ),
                  const Icon(Icons.help_outline, color: Colors.white, size: 30),
                ],
              ),
              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    '${points.toInt()} ${S.of(context).points}',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Text(
                    '${questionsCount.toInt()} ${S.of(context).questionsNumber}',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildActionButton(
                      context,
                      S.of(context).startLearning,
                      AppColors.lightColor,
                      () => Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => LessonLearning(
                                      lessonId: lessonId,
                                      levelId: levelId,
                                      page: page,
                                      size: size,
                                      order: order,
                                      title: title,
                                      userPoints: userPoints,
                                      collectionName: collectionName,
                                      rewardedPoints: rewardedPoints,
                                      deducedPoints: deducedPoints,
                                    )),
                          ),
                      Colors.black),
                  buildActionButton(
                      context,
                      S.of(context).startExam,
                      AppColors.secondColor,
                      () => Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => ExamPage(
                                levelId: levelId,
                                page: page,
                                size: size,
                                order: order,
                                title: title,
                                userPoints: userPoints,
                                lessonId: lessonId,
                                collectionName: collectionName,
                                rewardedPoints: rewardedPoints,
                                deducedPoints: deducedPoints,
                              ),
                            ),
                          ),
                      AppColors.whiteColor),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

void showFinishLessonDialog(
    BuildContext context,
    double order,
    String title,
    double userPoints,
    String levelId,
    double page,
    double size,
    String collectionName,
    double rewardedPoints,
    double deducedPoints,
    String lessonId) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
        insetPadding:
            const EdgeInsets.all(20), // Adjust inset padding as needed
        content: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.mainColor, // Dark background
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.secondColor.withOpacity(1), // Shadow color
                spreadRadius: 3, // Spread of the shadow
                blurRadius: 2, // Blur effect
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: AppColors.secondColor,
                radius: 25,
                child: Text(
                  '${order.toInt()}',
                  style: const TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 15,
                decoration: const BoxDecoration(
                  color: AppColors.secondColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                S.of(context).successfullyPoints,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '${userPoints.toInt()}',
                style: const TextStyle(
                  color: Colors.amber,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                S.of(context).pts,
                style: const TextStyle(
                  color: AppColors.lightColor,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 5),
              Container(
                height: 15,
                decoration: const BoxDecoration(
                  color: AppColors.secondColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(35),
                    bottomRight: Radius.circular(35),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 60, // Set a fixed height for both buttons
                      child: buildActionButton(
                        context,
                        S.of(context).back,
                        AppColors.secondColor,
                        () => Navigator.of(context).pop(),
                        AppColors.whiteColor,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 60, // Set the same fixed height for both buttons
                      child: buildActionButton(
                        context,
                        S.of(context).viewResults,
                        AppColors.secondColor,
                        () => Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => ExamPage(
                              levelId: levelId,
                              page: page,
                              size: size,
                              order: order,
                              title: title,
                              userPoints: userPoints,
                              lessonId: lessonId,
                              collectionName: collectionName,
                              rewardedPoints: rewardedPoints,
                              deducedPoints: deducedPoints,
                            ),
                          ),
                        ),
                        AppColors.whiteColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              buildActionButton(
                  context,
                  S.of(context).continueLearning,
                  AppColors.lightColor,
                  () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => LessonLearning(
                                  lessonId: lessonId,
                                  levelId: levelId,
                                  page: page,
                                  size: size,
                                  order: order,
                                  title: title,
                                  userPoints: userPoints,
                                  collectionName: collectionName,
                                  rewardedPoints: rewardedPoints,
                                  deducedPoints: deducedPoints,
                                )),
                      ),
                  Colors.black),
            ],
          ),
        ),
      );
    },
  );
}

Widget buildActionButton(BuildContext context, String label,
    Color backgroundColor, void Function()? onPressed, Color textColor) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      child: Text(
        label,
        style: TextStyle(color: textColor, fontSize: 16),
      ),
    ),
  );
}
