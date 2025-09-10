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

  static String m9(minutes) =>
      "You finished all questions correctly within ${minutes} minutes. 500 points have been added to your balance.";

  static String m10(level) => "Level ${level}";

  static String m11(subscriptionCostPoints) =>
      "You must have ${subscriptionCostPoints} points to enter this challenge";

  static String m12(previousLessonTitle) =>
      "You must complete all questions in lesson ${previousLessonTitle} before starting this lesson.";

  static String m13(level) =>
      "You must complete level ${level} first to unlock this content";

  static String m14(points) => "You need ${points} additional points. ";

  static String m15(current, required) => "Need ${current}/${required} pts";

  static String m16(current, required) => "Need ${current}/${required} pts";

  static String m17(cycle) => "New cycle started (#${cycle}). Good luck!";

  static String m18(current, goal) => "Points: ${current}/${goal}";

  static String m19(points) => "Reward + ${points} pts";

  static String m20(time) => "Starts in ${time}";

  static String m21(current, total) => "Total answers: ${current}/${total}";

  static String m22(ads) => "Watch ${ads} ad(s).";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "WithdrawPoints": MessageLookupByLibrary.simpleMessage(
            "Withdrawing points reduces your overall ranking"),
        "about": MessageLookupByLibrary.simpleMessage("About Us"),
        "aboutUs": MessageLookupByLibrary.simpleMessage("About Us"),
        "about_intro_1": MessageLookupByLibrary.simpleMessage(
            "Voninja is an innovative learning app for mastering English words and vocabulary in a fun, interactive way."),
        "about_intro_2": MessageLookupByLibrary.simpleMessage(
            "It combines learning + challenges + real rewards to make your learning experience engaging and exciting."),
        "about_title": MessageLookupByLibrary.simpleMessage("📖 About Voninja"),
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
        "cannotStartNewCycle":
            MessageLookupByLibrary.simpleMessage("Cannot start a new cycle"),
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
        "confirmNewCycleDesc": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to start a new cycle? This action will reset all boxes."),
        "confirmNewCycleDescription": MessageLookupByLibrary.simpleMessage(
            "By pressing \"Confirm\", a new cycle will begin and your balance will be reset to 500 points.\nWe recommend using your existing points before starting a new cycle.\n⚠️ If your balance is 25,000 points or more, you must submit a transfer request first."),
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
        "copied": MessageLookupByLibrary.simpleMessage("Copied"),
        "copy": MessageLookupByLibrary.simpleMessage("Copy"),
        "correctAnswerPoints": MessageLookupByLibrary.simpleMessage(
            "For each correct answer, you will earn points"),
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
        "faq_a1": MessageLookupByLibrary.simpleMessage(
            "We usually reply within a few hours. During events and peak times, it may take a little longer."),
        "faq_a2": MessageLookupByLibrary.simpleMessage(
            "Please share your device type, app version, and a brief description or a screenshot of the issue."),
        "faq_a3": MessageLookupByLibrary.simpleMessage(
            "Yes, messages are accepted 24/7. Our team will get back to you in the next available window."),
        "faq_q1":
            MessageLookupByLibrary.simpleMessage("How fast do you respond?"),
        "faq_q2": MessageLookupByLibrary.simpleMessage(
            "What info should I include in my message?"),
        "faq_q3": MessageLookupByLibrary.simpleMessage(
            "Can I contact you outside business hours?"),
        "faq_title":
            MessageLookupByLibrary.simpleMessage("Frequently Asked Questions"),
        "feature_challenges": MessageLookupByLibrary.simpleMessage(
            "🏆 Challenges: tasks with specific points to keep you progressing step by step."),
        "feature_events": MessageLookupByLibrary.simpleMessage(
            "📅 Special Events: time-limited events that boost your engagement and unlock big rewards."),
        "feature_interactive_lessons": MessageLookupByLibrary.simpleMessage(
            "🎯 Interactive lessons: learn new words through short, easy questions."),
        "feature_library": MessageLookupByLibrary.simpleMessage(
            "📚 Voninja Library: a collection of PDF files to expand your vocabulary."),
        "feature_treasure": MessageLookupByLibrary.simpleMessage(
            "🎁 Treasure Boxes Page: progressive boxes (Bronze – Silver – Gold) that unlock gradually and reward you with points and gifts."),
        "features_title":
            MessageLookupByLibrary.simpleMessage("Voninja Features:"),
        "final_congrats_desc": m9,
        "final_congrats_title":
            MessageLookupByLibrary.simpleMessage("Congratulations!"),
        "final_ok": MessageLookupByLibrary.simpleMessage("OK"),
        "final_tryAgain_desc_inTimeWrong": MessageLookupByLibrary.simpleMessage(
            "You finished before time, but some answers were incorrect.\nTry again!"),
        "final_tryAgain_desc_timeOver": MessageLookupByLibrary.simpleMessage(
            "Time ended before completing all answers correctly.\nTry again!"),
        "final_tryAgain_title":
            MessageLookupByLibrary.simpleMessage("Better luck next time"),
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
        "goal_body": MessageLookupByLibrary.simpleMessage(
            "Make learning English easy, enjoyable, and financially rewarding at the same time. With Voninja, every minute you learn brings you closer to your language goal—and helps you earn extra income from your effort."),
        "goal_title": MessageLookupByLibrary.simpleMessage("Our Goal:"),
        "gold": MessageLookupByLibrary.simpleMessage("Gold"),
        "goodLuck": MessageLookupByLibrary.simpleMessage(
            "Good luck! Review your answers and try again in the next event."),
        "hi": MessageLookupByLibrary.simpleMessage("Hi"),
        "importantWarning":
            MessageLookupByLibrary.simpleMessage("⚠️ Important warning:"),
        "inProgress": MessageLookupByLibrary.simpleMessage("In progress"),
        "incompleteLesson":
            MessageLookupByLibrary.simpleMessage("Lesson Incomplete"),
        "intro_appBarTitle": MessageLookupByLibrary.simpleMessage(
            "Welcome Challenge Instructions"),
        "intro_bullet_all_questions": MessageLookupByLibrary.simpleMessage(
            "Answer all the challenge questions."),
        "intro_bullet_five_minutes": MessageLookupByLibrary.simpleMessage(
            "You have only 5 minutes from the moment you start."),
        "intro_bullet_reward": MessageLookupByLibrary.simpleMessage(
            "If you answer all questions correctly before time runs out, you will earn 500 points!"),
        "intro_startButton":
            MessageLookupByLibrary.simpleMessage("Start Challenge"),
        "intro_title": MessageLookupByLibrary.simpleMessage(
            "Welcome to VoNinja! This is a welcome challenge:"),
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
        "levelNumber": m10,
        "librarySubtitle": MessageLookupByLibrary.simpleMessage(
            "Browse English learning books"),
        "libraryTitle": MessageLookupByLibrary.simpleMessage("Voninja Library"),
        "locked": MessageLookupByLibrary.simpleMessage("Locked"),
        "login": MessageLookupByLibrary.simpleMessage("Login"),
        "loginButton": MessageLookupByLibrary.simpleMessage("Login"),
        "logout": MessageLookupByLibrary.simpleMessage("Logout"),
        "maxUserName": MessageLookupByLibrary.simpleMessage(
            "Username cannot exceed 20 characters"),
        "minUserName": MessageLookupByLibrary.simpleMessage(
            "Username must be at least 3 characters long"),
        "minmaPoints": m11,
        "mustCompleteLesson": m12,
        "mustCompleteLevel": m13,
        "mustTransferPointsFirst": MessageLookupByLibrary.simpleMessage(
            "Your balance is above 25,000 points. Please submit a transfer request first before starting a new cycle."),
        "mustTransferPointsFirst2": MessageLookupByLibrary.simpleMessage(
            "You must complete a withdrawal transaction before starting a new cycle."),
        "nav_challenges": MessageLookupByLibrary.simpleMessage("Challenges"),
        "nav_home": MessageLookupByLibrary.simpleMessage("Home"),
        "nav_leaderboard": MessageLookupByLibrary.simpleMessage("Leaderboard"),
        "nav_learn": MessageLookupByLibrary.simpleMessage("Learn"),
        "nav_settings": MessageLookupByLibrary.simpleMessage("Settings"),
        "nav_treasure": MessageLookupByLibrary.simpleMessage("Treasures"),
        "needPoints": m14,
        "needPoints2": m15,
        "needPointsRemaining": m16,
        "newCycleDescription": MessageLookupByLibrary.simpleMessage(
            "You can reset the cycle now and start with a reward of 500 points. Or continue as you are and keep your current points."),
        "newCycleStarted": m17,
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
        "points2": m18,
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
        "rewardPoints": m19,
        "rewards_cash": MessageLookupByLibrary.simpleMessage(
            "When you collect 25,000 points, you can convert them directly to 100 EGP cash."),
        "rewards_intro": MessageLookupByLibrary.simpleMessage(
            "With Voninja, every point you learn has real value 💰"),
        "rewards_time": MessageLookupByLibrary.simpleMessage(
            "If you use the app for two hours daily, you can reach 25,000 points in a short period of only 3–5 days."),
        "rewards_title":
            MessageLookupByLibrary.simpleMessage("Rewards System:"),
        "saveChanges": MessageLookupByLibrary.simpleMessage("Save Changes"),
        "secondPlace": MessageLookupByLibrary.simpleMessage("2nd"),
        "select_tap_error":
            MessageLookupByLibrary.simpleMessage("Could not switch tab"),
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
        "startsIn": m20,
        "subscribeInChallenge":
            MessageLookupByLibrary.simpleMessage("Subscribe Now"),
        "successfullyCompleted":
            MessageLookupByLibrary.simpleMessage("Congratulations!"),
        "successfullyPoints": MessageLookupByLibrary.simpleMessage(
            "You have Successfully \nCompleted the lesson"),
        "support_email_label":
            MessageLookupByLibrary.simpleMessage("Support Email"),
        "support_email_value":
            MessageLookupByLibrary.simpleMessage("voninja15@gmail.com"),
        "support_intro": MessageLookupByLibrary.simpleMessage(
            "If you face any issue or have a question about using Voninja, our support team is ready to help anytime."),
        "support_note": MessageLookupByLibrary.simpleMessage(
            "You can contact us at any time, and our team will get back to you as soon as possible to solve your problem or answer your questions."),
        "support_title":
            MessageLookupByLibrary.simpleMessage("🛠️ Technical Support"),
        "support_whatsapp_label":
            MessageLookupByLibrary.simpleMessage("WhatsApp Support"),
        "support_whatsapp_value":
            MessageLookupByLibrary.simpleMessage("+20 1034672064"),
        "switchIcons": MessageLookupByLibrary.simpleMessage("Switch icons"),
        "taskNumber": MessageLookupByLibrary.simpleMessage("Task"),
        "tasks": MessageLookupByLibrary.simpleMessage("Tasks"),
        "technicalSupport":
            MessageLookupByLibrary.simpleMessage("Technical Support"),
        "thirdPlace": MessageLookupByLibrary.simpleMessage("3rd"),
        "topTen": MessageLookupByLibrary.simpleMessage("Top 10"),
        "totalAnswers": m21,
        "totalBalance": MessageLookupByLibrary.simpleMessage("Total Balance"),
        "totalPoints": MessageLookupByLibrary.simpleMessage("Total Points"),
        "transaction": MessageLookupByLibrary.simpleMessage("Transaction"),
        "treasureBoxes": MessageLookupByLibrary.simpleMessage("Treasure Boxes"),
        "treasureBoxesCard":
            MessageLookupByLibrary.simpleMessage("Treasure Boxes"),
        "treasureBoxesLevels":
            MessageLookupByLibrary.simpleMessage("Bronze • Silver • Gold"),
        "ug_10_body": MessageLookupByLibrary.simpleMessage(
            "Every 25,000 points = 100 EGP, processed within 24–48 hours after submitting a request. Go to Settings → “Get your coins now”, enter your wallet or a contact number, and track the transfer via the WhatsApp number listed under Technical Support. Cashouts are currently available for Egyptian wallets/numbers only, with plans to expand globally."),
        "ug_10_title":
            MessageLookupByLibrary.simpleMessage("How do I cash out?"),
        "ug_11_body": MessageLookupByLibrary.simpleMessage(
            "Voninja combines fun learning with real incentives. Three lesson levels suit all learners; challenges, events, and treasure boxes keep you motivated; and points convert quickly into real rewards."),
        "ug_11_title":
            MessageLookupByLibrary.simpleMessage("Why choose Voninja?"),
        "ug_1_body": MessageLookupByLibrary.simpleMessage(
            "Voninja is an interactive learning app for English using short lessons, quizzes, challenges, and a points system. Every learning activity grants points that can be converted into real cash rewards."),
        "ug_1_title": MessageLookupByLibrary.simpleMessage("What is Voninja?"),
        "ug_2_body": MessageLookupByLibrary.simpleMessage(
            "The app offers three learning levels:\n• Basic: each lesson = 1 point.\n• Intermediate: each lesson = 2 points.\n• Advanced: each lesson = 3 points.\nAfter every lesson, a short quiz evaluates your recall and adds points automatically."),
        "ug_2_title":
            MessageLookupByLibrary.simpleMessage("What levels are available?"),
        "ug_3_body": MessageLookupByLibrary.simpleMessage(
            "Challenges are multi-question tasks. Each correct answer can grant 3, 5, 10, 20, 25 points or more. To join a challenge, you must meet the entry requirement (e.g., have 2,000 points)."),
        "ug_3_title":
            MessageLookupByLibrary.simpleMessage("What are \"Challenges\"?"),
        "ug_4_body": MessageLookupByLibrary.simpleMessage(
            "Time-limited events that grant extra rewards, such as:\n• Double Points Day: all points earned double for 24 hours.\n• Kickstart Challenge: earn 1,000 points in your first 48 hours to get +3,000 points.\n• Quiz Master 100: answer 100 questions correctly within 48 hours to get +1,000 points."),
        "ug_4_title":
            MessageLookupByLibrary.simpleMessage("What are \"Events\"?"),
        "ug_5_body": MessageLookupByLibrary.simpleMessage(
            "Voninja Treasures include Bronze, Silver, and Gold boxes. Each box requires a minimum points balance and ad views to enter, and grants increasing point rewards."),
        "ug_5_title":
            MessageLookupByLibrary.simpleMessage("How do Treasure Boxes work?"),
        "ug_6_body": MessageLookupByLibrary.simpleMessage(
            "Yes. Watch a short ad to get +10 extra points, or claim bonus points after each quiz via a rewarded ad."),
        "ug_6_title": MessageLookupByLibrary.simpleMessage(
            "Can I boost points with ads?"),
        "ug_7_body": MessageLookupByLibrary.simpleMessage(
            "An in-app library of educational PDF books. You can unlock and read books directly after paying with points."),
        "ug_7_title": MessageLookupByLibrary.simpleMessage(
            "What is the Voninja Library?"),
        "ug_8_body": MessageLookupByLibrary.simpleMessage(
            "After finishing Bronze + Silver + Gold boxes and reaching 25,000 points, you can request a 100 EGP cashout by entering your wallet number in the transfer screen. Your points then reset to 0 so you can re-enter Voninja Treasures and start the cycle again."),
        "ug_8_title": MessageLookupByLibrary.simpleMessage(
            "How does the \"Treasure Recycle\" work?"),
        "ug_9_body": MessageLookupByLibrary.simpleMessage(
            "Follow our social pages for questions and giveaways. Winners receive a special code. Go to Settings → Social Media and enter your reward code to redeem."),
        "ug_9_title": MessageLookupByLibrary.simpleMessage(
            "How do I get reward codes from social media?"),
        "ug_image_alt_cashout":
            MessageLookupByLibrary.simpleMessage("Cashout flow example"),
        "ug_image_alt_social":
            MessageLookupByLibrary.simpleMessage("Social reward code example"),
        "unansweredQuestions":
            MessageLookupByLibrary.simpleMessage("Unanswered questions: "),
        "unansweredQuestionsTitle":
            MessageLookupByLibrary.simpleMessage("Questions not answered:"),
        "userGuide": MessageLookupByLibrary.simpleMessage("User Guide"),
        "userGuide_headerSubtitle": MessageLookupByLibrary.simpleMessage(
            "Short lessons, quizzes, challenges, treasure boxes, and real cash rewards."),
        "userGuide_headerTitle":
            MessageLookupByLibrary.simpleMessage("Voninja — Learn & Earn"),
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
        "watchAds": m22,
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
