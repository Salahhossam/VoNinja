// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(current, required) => "Ads ${current}/${required}";

  static String m1(number) => "#${number}";

  static String m2(percentage) => "${percentage}% completed";

  static String m3(cycle) =>
      "Congratulations! All boxes for cycle #${cycle} have been completed.";

  static String m4(current, goal) => "Correct answers: ${current}/${goal}";

  static String m5(points) => "You earned ${points} points.";

  static String m6(time) => "Ends in ${time}";

  static String m7(label) => "Please enter your ${label}";

  static String m8(label) => "Please enter your ${label}";

  static String m9(level) => "Level ${level}";

  static String m10(subscriptionCostPoints) =>
      "You must have ${subscriptionCostPoints} points to enter this challenge";

  static String m11(previousLessonTitle) =>
      "You must complete all questions in lesson ${previousLessonTitle} before starting this lesson.";

  static String m12(level) =>
      "You must complete level ${level} first to unlock this content";

  static String m13(points) => "You need ${points} additional points. ";

  static String m14(current, required) => "Need ${current}/${required} pts";

  static String m15(current, required) => "Need ${current}/${required} pts";

  static String m16(cycle) => "New cycle started (#${cycle}). Good luck!";

  static String m17(current, goal) => "Points: ${current}/${goal}";

  static String m18(points) => "Reward + ${points} pts";

  static String m19(time) => "Starts in ${time}";

  static String m20(current, total) => "Total answers: ${current}/${total}";

  static String m21(ads) => "Watch ${ads} ad(s).";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "WithdrawPoints": MessageLookupByLibrary.simpleMessage(
            "Withdrawing points reduces your overall ranking"),
        "about": MessageLookupByLibrary.simpleMessage("About Us"),
        "adNotAvailable": MessageLookupByLibrary.simpleMessage(
            "Ad is not currently available, try again in a moment."),
        "adsProgress": m0,
        "allQuestionsAnswered": MessageLookupByLibrary.simpleMessage(
            "You have successfully completed all questions in this lesson"),
        "alreadyHaveAccount":
            MessageLookupByLibrary.simpleMessage("Already have an account?"),
        "appTitle": MessageLookupByLibrary.simpleMessage("Voninja"),
        "back": MessageLookupByLibrary.simpleMessage("Back"),
        "backToHome": MessageLookupByLibrary.simpleMessage("Back to home"),
        "boxNumber": m1,
        "bringYourSword":
            MessageLookupByLibrary.simpleMessage("Bring your Sword!"),
        "bronze": MessageLookupByLibrary.simpleMessage("Bronze"),
        "cannotAccessLevel": MessageLookupByLibrary.simpleMessage(
            "You cannot access this level before completing the previous one."),
        "cash": MessageLookupByLibrary.simpleMessage("Cash"),
        "challenges": MessageLookupByLibrary.simpleMessage("Challenges"),
        "changePassword":
            MessageLookupByLibrary.simpleMessage("Change Password"),
        "checkVoNinjaEvents":
            MessageLookupByLibrary.simpleMessage("Check VoNinja Events !"),
        "chooseAnAvatar":
            MessageLookupByLibrary.simpleMessage("Choose Your Ninja"),
        "claimReward": MessageLookupByLibrary.simpleMessage("Claim Reward"),
        "completeAllBoxesFirst":
            MessageLookupByLibrary.simpleMessage("Complete all boxes first."),
        "completeAllQuestions": MessageLookupByLibrary.simpleMessage(
            "You can return to complete these questions to improve your score"),
        "completeCurrentLevel": MessageLookupByLibrary.simpleMessage(
            "Complete the current level first"),
        "completeDailyChallenges": MessageLookupByLibrary.simpleMessage(
            "Complete daily challenges to collect rewards"),
        "completePreviousLesson": MessageLookupByLibrary.simpleMessage(
            "Complete the previous lesson first"),
        "completePreviousLevel":
            MessageLookupByLibrary.simpleMessage("Complete Previous Level"),
        "completedPercentage": m2,
        "confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
        "confirmNewCycle":
            MessageLookupByLibrary.simpleMessage("Confirm starting new cycle"),
        "confirmNewCycleDescription": MessageLookupByLibrary.simpleMessage(
            "If you press \"Confirm\", a new cycle will start and your balance will become 500 points.\nIf you have many points, it\'s better to spend them first.\n⚠️ If your balance ≥ 25,000 points, you must make a transfer request first."),
        "confirmPassword":
            MessageLookupByLibrary.simpleMessage("Confirm Password"),
        "congratsAllBoxes": m3,
        "congratulations":
            MessageLookupByLibrary.simpleMessage("🎉 Congratulations"),
        "continueCollectingPoints": MessageLookupByLibrary.simpleMessage(
            "Continue collecting points to convert them into financial rewards"),
        "continueExam": MessageLookupByLibrary.simpleMessage("Continue Exam"),
        "continueExams": MessageLookupByLibrary.simpleMessage("Continue"),
        "continueLearning":
            MessageLookupByLibrary.simpleMessage("Continue Learning"),
        "continueQuiz": MessageLookupByLibrary.simpleMessage("Continue Quiz"),
        "correctAnswerPoints": MessageLookupByLibrary.simpleMessage(
            "For each correct answer, you will earn points, but if you answer incorrectly, you will lose points"),
        "correctAnswers": m4,
        "createAccount": MessageLookupByLibrary.simpleMessage("Create Account"),
        "currentPassword":
            MessageLookupByLibrary.simpleMessage("Current Password"),
        "cycle": MessageLookupByLibrary.simpleMessage("Cycle"),
        "cycleWarning": MessageLookupByLibrary.simpleMessage(
            "If your balance exceeds 25,000 points, you must first make a transfer request to receive cash in your wallet within 48 working hours. Then you can start a new cycle with a 500 point reward. If your current points are more than 500, they will be replaced with only 500 points."),
        "discoverExcitingEvents":
            MessageLookupByLibrary.simpleMessage("Discover Exciting Events"),
        "doNotMatch":
            MessageLookupByLibrary.simpleMessage("Passwords do not match"),
        "earnedPoints": m5,
        "edit": MessageLookupByLibrary.simpleMessage("Edit"),
        "editPassword": MessageLookupByLibrary.simpleMessage("Edit Password"),
        "editProfile": MessageLookupByLibrary.simpleMessage("Edit Profile"),
        "egp": MessageLookupByLibrary.simpleMessage("EGP"),
        "email": MessageLookupByLibrary.simpleMessage("Email"),
        "ended": MessageLookupByLibrary.simpleMessage("Ended"),
        "endsIn": m6,
        "enterEmail":
            MessageLookupByLibrary.simpleMessage("Please enter your Email"),
        "enterEmailOrUserNameToReset":
            MessageLookupByLibrary.simpleMessage("Enter your email to reset"),
        "enterFriendLink":
            MessageLookupByLibrary.simpleMessage("Enter your friend link"),
        "enterLabel": m7,
        "enterPassword":
            MessageLookupByLibrary.simpleMessage("Please enter the password"),
        "enterPasswordLabel": m8,
        "enterPhoneNumber": MessageLookupByLibrary.simpleMessage(
            "Please enter your Phone Number"),
        "enterPhoneNumberToGetCash": MessageLookupByLibrary.simpleMessage(
            "Please enter the phone number associated with your device. We’ll send you all details to complete the payment process"),
        "enterYourRewardCode":
            MessageLookupByLibrary.simpleMessage("Enter your reward code"),
        "error": MessageLookupByLibrary.simpleMessage("Error"),
        "events": MessageLookupByLibrary.simpleMessage("Events"),
        "exit": MessageLookupByLibrary.simpleMessage("Press again to exit"),
        "exitPrompt":
            MessageLookupByLibrary.simpleMessage("Press again to exit"),
        "firstPlace": MessageLookupByLibrary.simpleMessage("1st"),
        "followOurSocialMedia":
            MessageLookupByLibrary.simpleMessage("Follow our social media"),
        "followUs": MessageLookupByLibrary.simpleMessage("Follow us!"),
        "forgetPassword":
            MessageLookupByLibrary.simpleMessage("Forget Password?"),
        "fristName": MessageLookupByLibrary.simpleMessage("Frist Name"),
        "gainPointsChallenges": MessageLookupByLibrary.simpleMessage(
            "Gain points from special \nVocab Challenges!"),
        "getNewCoins":
            MessageLookupByLibrary.simpleMessage("Get your coins now!"),
        "getPoints": MessageLookupByLibrary.simpleMessage("Get Points"),
        "getYourPoints":
            MessageLookupByLibrary.simpleMessage("Get Your Points!"),
        "goToEvents": MessageLookupByLibrary.simpleMessage("Go to Events"),
        "goToPreviousLesson":
            MessageLookupByLibrary.simpleMessage("Go to previous lesson"),
        "gold": MessageLookupByLibrary.simpleMessage("Gold"),
        "goodLuck": MessageLookupByLibrary.simpleMessage(
            "Good luck! Review your answers and try again in the next event."),
        "hi": MessageLookupByLibrary.simpleMessage("Hi"),
        "importantWarning":
            MessageLookupByLibrary.simpleMessage("⚠️ Important warning:"),
        "inProgress": MessageLookupByLibrary.simpleMessage("In progress"),
        "incompleteLesson":
            MessageLookupByLibrary.simpleMessage("Lesson Incomplete"),
        "inviteFriend":
            MessageLookupByLibrary.simpleMessage("Invite your friend"),
        "join": MessageLookupByLibrary.simpleMessage("Join"),
        "joinChallengesEarnPoints": MessageLookupByLibrary.simpleMessage(
            "Join Challenges & Earn Points"),
        "language": MessageLookupByLibrary.simpleMessage("Language"),
        "lastName": MessageLookupByLibrary.simpleMessage("Last Name"),
        "leaderboard": MessageLookupByLibrary.simpleMessage("Leaderboard"),
        "lessonNumber": MessageLookupByLibrary.simpleMessage("Lesson"),
        "lessons": MessageLookupByLibrary.simpleMessage("Lessons"),
        "lessonsLearningVocabulary": MessageLookupByLibrary.simpleMessage(
            "This is your first step in learning English vocabulary.\nGo on ninja!"),
        "levelNumber": m9,
        "librarySubtitle": MessageLookupByLibrary.simpleMessage(
            "Browse English learning books"),
        "libraryTitle": MessageLookupByLibrary.simpleMessage("Voninja Library"),
        "login": MessageLookupByLibrary.simpleMessage("Login"),
        "loginButton": MessageLookupByLibrary.simpleMessage("Login"),
        "logout": MessageLookupByLibrary.simpleMessage("Logout"),
        "maxUserName": MessageLookupByLibrary.simpleMessage(
            "Username cannot exceed 20 characters"),
        "minUserName": MessageLookupByLibrary.simpleMessage(
            "Username must be at least 3 characters long"),
        "minmaPoints": m10,
        "mustCompleteLesson": m11,
        "mustCompleteLevel": m12,
        "needPoints": m13,
        "needPoints2": m14,
        "needPointsRemaining": m15,
        "newCycleDescription": MessageLookupByLibrary.simpleMessage(
            "You can reset the cycle now and start with a reward of 500 points. Or continue as you are and keep your current points."),
        "newCycleStarted": m16,
        "newPassword": MessageLookupByLibrary.simpleMessage("New Password"),
        "nextLesson": MessageLookupByLibrary.simpleMessage("Next Lesson"),
        "nextTask": MessageLookupByLibrary.simpleMessage("Next Task"),
        "noAccount":
            MessageLookupByLibrary.simpleMessage("Don\'t have an account?"),
        "noEventsAvailable":
            MessageLookupByLibrary.simpleMessage("No events available"),
        "noVocabulariesAvailable":
            MessageLookupByLibrary.simpleMessage("No vocabularies available"),
        "notActiveYet": MessageLookupByLibrary.simpleMessage("Not active yet"),
        "ok": MessageLookupByLibrary.simpleMessage("OK"),
        "okay": MessageLookupByLibrary.simpleMessage("Okay"),
        "open": MessageLookupByLibrary.simpleMessage("Open"),
        "participateSpecialEvents": MessageLookupByLibrary.simpleMessage(
            "Participate in special events for exclusive rewards"),
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "phoneNumber": MessageLookupByLibrary.simpleMessage("Phone Number"),
        "placeNumber": MessageLookupByLibrary.simpleMessage("Place"),
        "pleaseAnswerTheQuestionFirst": MessageLookupByLibrary.simpleMessage(
            "Please answer the current question before continuing."),
        "pleaseEnterValidData":
            MessageLookupByLibrary.simpleMessage("Please enter valid data"),
        "plus20Points": MessageLookupByLibrary.simpleMessage("+10 Points"),
        "pointChallenges":
            MessageLookupByLibrary.simpleMessage("+ 1 point | - 1 point"),
        "pointNumber": MessageLookupByLibrary.simpleMessage("Point"),
        "points": MessageLookupByLibrary.simpleMessage("Points"),
        "points2": m17,
        "progress": MessageLookupByLibrary.simpleMessage("Progress"),
        "pts": MessageLookupByLibrary.simpleMessage("pts"),
        "questionsNumber": MessageLookupByLibrary.simpleMessage("Questions"),
        "rank": MessageLookupByLibrary.simpleMessage("Rank"),
        "rankPointsNumber": MessageLookupByLibrary.simpleMessage("pts"),
        "register": MessageLookupByLibrary.simpleMessage("Register"),
        "rememberMe": MessageLookupByLibrary.simpleMessage("Remember me"),
        "resetPassword": MessageLookupByLibrary.simpleMessage(
            "Password reset link sent to email"),
        "rewardClaimed": MessageLookupByLibrary.simpleMessage("Reward Claimed"),
        "rewardClaimedMessage":
            MessageLookupByLibrary.simpleMessage("Reward claimed!"),
        "rewardPoints": m18,
        "saveChanges": MessageLookupByLibrary.simpleMessage("Save Changes"),
        "secondPlace": MessageLookupByLibrary.simpleMessage("2nd"),
        "sendDetails": MessageLookupByLibrary.simpleMessage("Send Details"),
        "showMyAnswers":
            MessageLookupByLibrary.simpleMessage("Show my answers"),
        "showRanks": MessageLookupByLibrary.simpleMessage("Show Ranks"),
        "signUp": MessageLookupByLibrary.simpleMessage("Sign up"),
        "silver": MessageLookupByLibrary.simpleMessage("Silver"),
        "socialMedia": MessageLookupByLibrary.simpleMessage("Social Media"),
        "specialOfferBody": MessageLookupByLibrary.simpleMessage(
            "You can earn more points right now by visiting the Events page. There is also a Welcome Event that grants you extra bonus points on your first visit. Would you like to go now, or continue your exam?"),
        "specialOfferTitle":
            MessageLookupByLibrary.simpleMessage("Special Points Offer"),
        "splashWord": MessageLookupByLibrary.simpleMessage(
            "Be Ninja In English Vocabulary!"),
        "startChallenge":
            MessageLookupByLibrary.simpleMessage("Start Challenge"),
        "startExam": MessageLookupByLibrary.simpleMessage("Start Exam"),
        "startLearning": MessageLookupByLibrary.simpleMessage("Start Learning"),
        "startNewCycle":
            MessageLookupByLibrary.simpleMessage("Start New Cycle"),
        "startsIn": m19,
        "subscribeInChallenge":
            MessageLookupByLibrary.simpleMessage("Subscribe Now"),
        "successfullyCompleted":
            MessageLookupByLibrary.simpleMessage("Congratulations!"),
        "successfullyPoints": MessageLookupByLibrary.simpleMessage(
            "You have Successfully \nCompleted the lesson"),
        "switchIcons": MessageLookupByLibrary.simpleMessage("Switch icons"),
        "taskNumber": MessageLookupByLibrary.simpleMessage("Task"),
        "tasks": MessageLookupByLibrary.simpleMessage("Tasks"),
        "thirdPlace": MessageLookupByLibrary.simpleMessage("3rd"),
        "topTen": MessageLookupByLibrary.simpleMessage("Top 10"),
        "totalAnswers": m20,
        "totalBalance": MessageLookupByLibrary.simpleMessage("Total Balance"),
        "totalPoints": MessageLookupByLibrary.simpleMessage("Total Points"),
        "transaction": MessageLookupByLibrary.simpleMessage("Transaction"),
        "treasureBoxes": MessageLookupByLibrary.simpleMessage("Treasure Boxes"),
        "treasureBoxesCard":
            MessageLookupByLibrary.simpleMessage("Treasure Boxes"),
        "treasureBoxesLevels":
            MessageLookupByLibrary.simpleMessage("Bronze • Silver • Gold"),
        "unansweredQuestions":
            MessageLookupByLibrary.simpleMessage("Unanswered questions: "),
        "unansweredQuestionsTitle":
            MessageLookupByLibrary.simpleMessage("Questions not answered:"),
        "userName": MessageLookupByLibrary.simpleMessage("User Name"),
        "validFristName": MessageLookupByLibrary.simpleMessage(
            "First name must be at least 2 characters"),
        "validLastName": MessageLookupByLibrary.simpleMessage(
            "Last name must be at least 2 characters"),
        "validPhoneNumber": MessageLookupByLibrary.simpleMessage(
            "Enter a valid phone number (e.g., +1234567890 or 0123456789)"),
        "version": MessageLookupByLibrary.simpleMessage("Version"),
        "viewAllChallenges":
            MessageLookupByLibrary.simpleMessage("View All Challenges"),
        "viewAllEvents":
            MessageLookupByLibrary.simpleMessage("View All Events"),
        "viewResults": MessageLookupByLibrary.simpleMessage("View results"),
        "wantNewAdventure": MessageLookupByLibrary.simpleMessage(
            "🎯 Want to start a new adventure?"),
        "warning": MessageLookupByLibrary.simpleMessage("Warning"),
        "watchAd": MessageLookupByLibrary.simpleMessage("Watch Ad"),
        "watchAds": m21,
        "wrongCredentials":
            MessageLookupByLibrary.simpleMessage("Wrong email or password"),
        "wrongResetPassword":
            MessageLookupByLibrary.simpleMessage("Wrong Reset Password"),
        "you": MessageLookupByLibrary.simpleMessage("You"),
        "youAreAllSet":
            MessageLookupByLibrary.simpleMessage("You\'re All Set!"),
        "youLearned30NewwordsToday": MessageLookupByLibrary.simpleMessage(
            "You learned 30 new words Today..."),
        "yourPoints": MessageLookupByLibrary.simpleMessage("Your Points")
      };
}
