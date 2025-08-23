// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Voninja`
  String get appTitle {
    return Intl.message(
      'Voninja',
      name: 'appTitle',
      desc: '',
      args: [],
    );
  }

  /// `Be Ninja In English Vocabulary!`
  String get splashWord {
    return Intl.message(
      'Be Ninja In English Vocabulary!',
      name: 'splashWord',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your Phone Number`
  String get enterPhoneNumber {
    return Intl.message(
      'Please enter your Phone Number',
      name: 'enterPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your Email`
  String get enterEmail {
    return Intl.message(
      'Please enter your Email',
      name: 'enterEmail',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the password`
  String get enterPassword {
    return Intl.message(
      'Please enter the password',
      name: 'enterPassword',
      desc: '',
      args: [],
    );
  }

  /// `Remember me`
  String get rememberMe {
    return Intl.message(
      'Remember me',
      name: 'rememberMe',
      desc: '',
      args: [],
    );
  }

  /// `Forget Password?`
  String get forgetPassword {
    return Intl.message(
      'Forget Password?',
      name: 'forgetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Password reset link sent to email`
  String get resetPassword {
    return Intl.message(
      'Password reset link sent to email',
      name: 'resetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Wrong Reset Password`
  String get wrongResetPassword {
    return Intl.message(
      'Wrong Reset Password',
      name: 'wrongResetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email to reset`
  String get enterEmailOrUserNameToReset {
    return Intl.message(
      'Enter your email to reset',
      name: 'enterEmailOrUserNameToReset',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get loginButton {
    return Intl.message(
      'Login',
      name: 'loginButton',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account?`
  String get noAccount {
    return Intl.message(
      'Don\'t have an account?',
      name: 'noAccount',
      desc: '',
      args: [],
    );
  }

  /// `Sign up`
  String get signUp {
    return Intl.message(
      'Sign up',
      name: 'signUp',
      desc: '',
      args: [],
    );
  }

  /// `Wrong email or password`
  String get wrongCredentials {
    return Intl.message(
      'Wrong email or password',
      name: 'wrongCredentials',
      desc: '',
      args: [],
    );
  }

  /// `Press again to exit`
  String get exitPrompt {
    return Intl.message(
      'Press again to exit',
      name: 'exitPrompt',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Frist Name`
  String get fristName {
    return Intl.message(
      'Frist Name',
      name: 'fristName',
      desc: '',
      args: [],
    );
  }

  /// `Last Name`
  String get lastName {
    return Intl.message(
      'Last Name',
      name: 'lastName',
      desc: '',
      args: [],
    );
  }

  /// `User Name`
  String get userName {
    return Intl.message(
      'User Name',
      name: 'userName',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get doNotMatch {
    return Intl.message(
      'Passwords do not match',
      name: 'doNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `Create Account`
  String get createAccount {
    return Intl.message(
      'Create Account',
      name: 'createAccount',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account?`
  String get alreadyHaveAccount {
    return Intl.message(
      'Already have an account?',
      name: 'alreadyHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your {label}`
  String enterLabel(Object label) {
    return Intl.message(
      'Please enter your $label',
      name: 'enterLabel',
      desc: '',
      args: [label],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your {label}`
  String enterPasswordLabel(Object label) {
    return Intl.message(
      'Please enter your $label',
      name: 'enterPasswordLabel',
      desc: '',
      args: [label],
    );
  }

  /// `Current Password`
  String get currentPassword {
    return Intl.message(
      'Current Password',
      name: 'currentPassword',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get newPassword {
    return Intl.message(
      'New Password',
      name: 'newPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Save Changes`
  String get saveChanges {
    return Intl.message(
      'Save Changes',
      name: 'saveChanges',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get changePassword {
    return Intl.message(
      'Change Password',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `Edit Profile`
  String get editProfile {
    return Intl.message(
      'Edit Profile',
      name: 'editProfile',
      desc: '',
      args: [],
    );
  }

  /// `Edit Password`
  String get editPassword {
    return Intl.message(
      'Edit Password',
      name: 'editPassword',
      desc: '',
      args: [],
    );
  }

  /// `Choose Your Ninja`
  String get chooseAnAvatar {
    return Intl.message(
      'Choose Your Ninja',
      name: 'chooseAnAvatar',
      desc: '',
      args: [],
    );
  }

  /// `Total Balance`
  String get totalBalance {
    return Intl.message(
      'Total Balance',
      name: 'totalBalance',
      desc: '',
      args: [],
    );
  }

  /// `EGP`
  String get egp {
    return Intl.message(
      'EGP',
      name: 'egp',
      desc: '',
      args: [],
    );
  }

  /// `Social Media`
  String get socialMedia {
    return Intl.message(
      'Social Media',
      name: 'socialMedia',
      desc: '',
      args: [],
    );
  }

  /// `Follow us!`
  String get followUs {
    return Intl.message(
      'Follow us!',
      name: 'followUs',
      desc: '',
      args: [],
    );
  }

  /// `Switch icons`
  String get switchIcons {
    return Intl.message(
      'Switch icons',
      name: 'switchIcons',
      desc: '',
      args: [],
    );
  }

  /// `Get your coins now!`
  String get getNewCoins {
    return Intl.message(
      'Get your coins now!',
      name: 'getNewCoins',
      desc: '',
      args: [],
    );
  }

  /// `Invite your friend`
  String get inviteFriend {
    return Intl.message(
      'Invite your friend',
      name: 'inviteFriend',
      desc: '',
      args: [],
    );
  }

  /// `Get Your Points!`
  String get getYourPoints {
    return Intl.message(
      'Get Your Points!',
      name: 'getYourPoints',
      desc: '',
      args: [],
    );
  }

  /// `Withdrawing points reduces your overall ranking`
  String get WithdrawPoints {
    return Intl.message(
      'Withdrawing points reduces your overall ranking',
      name: 'WithdrawPoints',
      desc: '',
      args: [],
    );
  }

  /// `Total Points`
  String get totalPoints {
    return Intl.message(
      'Total Points',
      name: 'totalPoints',
      desc: '',
      args: [],
    );
  }

  /// `Cash`
  String get cash {
    return Intl.message(
      'Cash',
      name: 'cash',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the phone number associated with your device. We’ll send you all details to complete the payment process`
  String get enterPhoneNumberToGetCash {
    return Intl.message(
      'Please enter the phone number associated with your device. We’ll send you all details to complete the payment process',
      name: 'enterPhoneNumberToGetCash',
      desc: '',
      args: [],
    );
  }

  /// `Send Details`
  String get sendDetails {
    return Intl.message(
      'Send Details',
      name: 'sendDetails',
      desc: '',
      args: [],
    );
  }

  /// `Enter your friend link`
  String get enterFriendLink {
    return Intl.message(
      'Enter your friend link',
      name: 'enterFriendLink',
      desc: '',
      args: [],
    );
  }

  /// `Get Points`
  String get getPoints {
    return Intl.message(
      'Get Points',
      name: 'getPoints',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Transaction`
  String get transaction {
    return Intl.message(
      'Transaction',
      name: 'transaction',
      desc: '',
      args: [],
    );
  }

  /// `About Us`
  String get about {
    return Intl.message(
      'About Us',
      name: 'about',
      desc: '',
      args: [],
    );
  }

  /// `Version`
  String get version {
    return Intl.message(
      'Version',
      name: 'version',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Enter your reward code`
  String get enterYourRewardCode {
    return Intl.message(
      'Enter your reward code',
      name: 'enterYourRewardCode',
      desc: '',
      args: [],
    );
  }

  /// `Follow our social media`
  String get followOurSocialMedia {
    return Intl.message(
      'Follow our social media',
      name: 'followOurSocialMedia',
      desc: '',
      args: [],
    );
  }

  /// `Please enter valid data`
  String get pleaseEnterValidData {
    return Intl.message(
      'Please enter valid data',
      name: 'pleaseEnterValidData',
      desc: '',
      args: [],
    );
  }

  /// `First name must be at least 2 characters`
  String get validFristName {
    return Intl.message(
      'First name must be at least 2 characters',
      name: 'validFristName',
      desc: '',
      args: [],
    );
  }

  /// `Last name must be at least 2 characters`
  String get validLastName {
    return Intl.message(
      'Last name must be at least 2 characters',
      name: 'validLastName',
      desc: '',
      args: [],
    );
  }

  /// `Username must be at least 3 characters long`
  String get minUserName {
    return Intl.message(
      'Username must be at least 3 characters long',
      name: 'minUserName',
      desc: '',
      args: [],
    );
  }

  /// `Username cannot exceed 20 characters`
  String get maxUserName {
    return Intl.message(
      'Username cannot exceed 20 characters',
      name: 'maxUserName',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid phone number (e.g., +1234567890 or 0123456789)`
  String get validPhoneNumber {
    return Intl.message(
      'Enter a valid phone number (e.g., +1234567890 or 0123456789)',
      name: 'validPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Leaderboard`
  String get leaderboard {
    return Intl.message(
      'Leaderboard',
      name: 'leaderboard',
      desc: '',
      args: [],
    );
  }

  /// `Check VoNinja Events !`
  String get checkVoNinjaEvents {
    return Intl.message(
      'Check VoNinja Events !',
      name: 'checkVoNinjaEvents',
      desc: '',
      args: [],
    );
  }

  /// `Continue collecting points to convert them into financial rewards`
  String get continueCollectingPoints {
    return Intl.message(
      'Continue collecting points to convert them into financial rewards',
      name: 'continueCollectingPoints',
      desc: '',
      args: [],
    );
  }

  /// `Level {level}`
  String levelNumber(Object level) {
    return Intl.message(
      'Level $level',
      name: 'levelNumber',
      desc: '',
      args: [level],
    );
  }

  /// `Hi`
  String get hi {
    return Intl.message(
      'Hi',
      name: 'hi',
      desc: '',
      args: [],
    );
  }

  /// `Points`
  String get points {
    return Intl.message(
      'Points',
      name: 'points',
      desc: '',
      args: [],
    );
  }

  /// `Rank`
  String get rank {
    return Intl.message(
      'Rank',
      name: 'rank',
      desc: '',
      args: [],
    );
  }

  /// `Progress`
  String get progress {
    return Intl.message(
      'Progress',
      name: 'progress',
      desc: '',
      args: [],
    );
  }

  /// `Press again to exit`
  String get exit {
    return Intl.message(
      'Press again to exit',
      name: 'exit',
      desc: '',
      args: [],
    );
  }

  /// `Challenges`
  String get challenges {
    return Intl.message(
      'Challenges',
      name: 'challenges',
      desc: '',
      args: [],
    );
  }

  /// `Gain points from special \nVocab Challenges!`
  String get gainPointsChallenges {
    return Intl.message(
      'Gain points from special \nVocab Challenges!',
      name: 'gainPointsChallenges',
      desc: '',
      args: [],
    );
  }

  /// `+ 1 point | - 1 point`
  String get pointChallenges {
    return Intl.message(
      '+ 1 point | - 1 point',
      name: 'pointChallenges',
      desc: '',
      args: [],
    );
  }

  /// `Task`
  String get taskNumber {
    return Intl.message(
      'Task',
      name: 'taskNumber',
      desc: '',
      args: [],
    );
  }

  /// `Tasks`
  String get tasks {
    return Intl.message(
      'Tasks',
      name: 'tasks',
      desc: '',
      args: [],
    );
  }

  /// `You must have {subscriptionCostPoints} points to enter this challenge`
  String minmaPoints(Object subscriptionCostPoints) {
    return Intl.message(
      'You must have $subscriptionCostPoints points to enter this challenge',
      name: 'minmaPoints',
      desc: '',
      args: [subscriptionCostPoints],
    );
  }

  /// `Place`
  String get placeNumber {
    return Intl.message(
      'Place',
      name: 'placeNumber',
      desc: '',
      args: [],
    );
  }

  /// `pts`
  String get rankPointsNumber {
    return Intl.message(
      'pts',
      name: 'rankPointsNumber',
      desc: '',
      args: [],
    );
  }

  /// `1st`
  String get firstPlace {
    return Intl.message(
      '1st',
      name: 'firstPlace',
      desc: '',
      args: [],
    );
  }

  /// `2nd`
  String get secondPlace {
    return Intl.message(
      '2nd',
      name: 'secondPlace',
      desc: '',
      args: [],
    );
  }

  /// `3rd`
  String get thirdPlace {
    return Intl.message(
      '3rd',
      name: 'thirdPlace',
      desc: '',
      args: [],
    );
  }

  /// `Subscribe Now`
  String get subscribeInChallenge {
    return Intl.message(
      'Subscribe Now',
      name: 'subscribeInChallenge',
      desc: '',
      args: [],
    );
  }

  /// `Start Challenge`
  String get startChallenge {
    return Intl.message(
      'Start Challenge',
      name: 'startChallenge',
      desc: '',
      args: [],
    );
  }

  /// `Bring your Sword!`
  String get bringYourSword {
    return Intl.message(
      'Bring your Sword!',
      name: 'bringYourSword',
      desc: '',
      args: [],
    );
  }

  /// `Next Task`
  String get nextTask {
    return Intl.message(
      'Next Task',
      name: 'nextTask',
      desc: '',
      args: [],
    );
  }

  /// `Top 10`
  String get topTen {
    return Intl.message(
      'Top 10',
      name: 'topTen',
      desc: '',
      args: [],
    );
  }

  /// `You`
  String get you {
    return Intl.message(
      'You',
      name: 'you',
      desc: '',
      args: [],
    );
  }

  /// `Show Ranks`
  String get showRanks {
    return Intl.message(
      'Show Ranks',
      name: 'showRanks',
      desc: '',
      args: [],
    );
  }

  /// `Lessons`
  String get lessons {
    return Intl.message(
      'Lessons',
      name: 'lessons',
      desc: '',
      args: [],
    );
  }

  /// `This is your first step in learning English vocabulary.\nGo on ninja!`
  String get lessonsLearningVocabulary {
    return Intl.message(
      'This is your first step in learning English vocabulary.\nGo on ninja!',
      name: 'lessonsLearningVocabulary',
      desc: '',
      args: [],
    );
  }

  /// `For each correct answer, you will earn points, but if you answer incorrectly, you will lose points`
  String get correctAnswerPoints {
    return Intl.message(
      'For each correct answer, you will earn points, but if you answer incorrectly, you will lose points',
      name: 'correctAnswerPoints',
      desc: '',
      args: [],
    );
  }

  /// `Lesson`
  String get lessonNumber {
    return Intl.message(
      'Lesson',
      name: 'lessonNumber',
      desc: '',
      args: [],
    );
  }

  /// `Point`
  String get pointNumber {
    return Intl.message(
      'Point',
      name: 'pointNumber',
      desc: '',
      args: [],
    );
  }

  /// `Questions`
  String get questionsNumber {
    return Intl.message(
      'Questions',
      name: 'questionsNumber',
      desc: '',
      args: [],
    );
  }

  /// `Start Learning`
  String get startLearning {
    return Intl.message(
      'Start Learning',
      name: 'startLearning',
      desc: '',
      args: [],
    );
  }

  /// `Start Exam`
  String get startExam {
    return Intl.message(
      'Start Exam',
      name: 'startExam',
      desc: '',
      args: [],
    );
  }

  /// `You have Successfully \nCompleted the lesson`
  String get successfullyPoints {
    return Intl.message(
      'You have Successfully \nCompleted the lesson',
      name: 'successfullyPoints',
      desc: '',
      args: [],
    );
  }

  /// `pts`
  String get pts {
    return Intl.message(
      'pts',
      name: 'pts',
      desc: '',
      args: [],
    );
  }

  /// `Back to home`
  String get backToHome {
    return Intl.message(
      'Back to home',
      name: 'backToHome',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get back {
    return Intl.message(
      'Back',
      name: 'back',
      desc: '',
      args: [],
    );
  }

  /// `View results`
  String get viewResults {
    return Intl.message(
      'View results',
      name: 'viewResults',
      desc: '',
      args: [],
    );
  }

  /// `No vocabularies available`
  String get noVocabulariesAvailable {
    return Intl.message(
      'No vocabularies available',
      name: 'noVocabulariesAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continueExams {
    return Intl.message(
      'Continue',
      name: 'continueExams',
      desc: '',
      args: [],
    );
  }

  /// `You're All Set!`
  String get youAreAllSet {
    return Intl.message(
      'You\'re All Set!',
      name: 'youAreAllSet',
      desc: '',
      args: [],
    );
  }

  /// `You learned 30 new words Today...`
  String get youLearned30NewwordsToday {
    return Intl.message(
      'You learned 30 new words Today...',
      name: 'youLearned30NewwordsToday',
      desc: '',
      args: [],
    );
  }

  /// `+10 Points`
  String get plus20Points {
    return Intl.message(
      '+10 Points',
      name: 'plus20Points',
      desc: '',
      args: [],
    );
  }

  /// `Next Lesson`
  String get nextLesson {
    return Intl.message(
      'Next Lesson',
      name: 'nextLesson',
      desc: '',
      args: [],
    );
  }

  /// `Continue Learning`
  String get continueLearning {
    return Intl.message(
      'Continue Learning',
      name: 'continueLearning',
      desc: '',
      args: [],
    );
  }

  /// `Congratulations!`
  String get successfullyCompleted {
    return Intl.message(
      'Congratulations!',
      name: 'successfullyCompleted',
      desc: '',
      args: [],
    );
  }

  /// `You have successfully completed all questions in this lesson`
  String get allQuestionsAnswered {
    return Intl.message(
      'You have successfully completed all questions in this lesson',
      name: 'allQuestionsAnswered',
      desc: '',
      args: [],
    );
  }

  /// `Lesson Incomplete`
  String get incompleteLesson {
    return Intl.message(
      'Lesson Incomplete',
      name: 'incompleteLesson',
      desc: '',
      args: [],
    );
  }

  /// `Questions not answered:`
  String get unansweredQuestionsTitle {
    return Intl.message(
      'Questions not answered:',
      name: 'unansweredQuestionsTitle',
      desc: '',
      args: [],
    );
  }

  /// `You can return to complete these questions to improve your score`
  String get completeAllQuestions {
    return Intl.message(
      'You can return to complete these questions to improve your score',
      name: 'completeAllQuestions',
      desc: '',
      args: [],
    );
  }

  /// `Unanswered questions: `
  String get unansweredQuestions {
    return Intl.message(
      'Unanswered questions: ',
      name: 'unansweredQuestions',
      desc: '',
      args: [],
    );
  }

  /// `Complete the previous lesson first`
  String get completePreviousLesson {
    return Intl.message(
      'Complete the previous lesson first',
      name: 'completePreviousLesson',
      desc: '',
      args: [],
    );
  }

  /// `You must complete all questions in lesson {previousLessonTitle} before starting this lesson.`
  String mustCompleteLesson(Object previousLessonTitle) {
    return Intl.message(
      'You must complete all questions in lesson $previousLessonTitle before starting this lesson.',
      name: 'mustCompleteLesson',
      desc: '',
      args: [previousLessonTitle],
    );
  }

  /// `Okay`
  String get okay {
    return Intl.message(
      'Okay',
      name: 'okay',
      desc: '',
      args: [],
    );
  }

  /// `Go to previous lesson`
  String get goToPreviousLesson {
    return Intl.message(
      'Go to previous lesson',
      name: 'goToPreviousLesson',
      desc: '',
      args: [],
    );
  }

  /// `Complete Previous Level`
  String get completePreviousLevel {
    return Intl.message(
      'Complete Previous Level',
      name: 'completePreviousLevel',
      desc: '',
      args: [],
    );
  }

  /// `You must complete level {level} first to unlock this content`
  String mustCompleteLevel(Object level) {
    return Intl.message(
      'You must complete level $level first to unlock this content',
      name: 'mustCompleteLevel',
      desc: '',
      args: [level],
    );
  }

  /// `Please answer the current question before continuing.`
  String get pleaseAnswerTheQuestionFirst {
    return Intl.message(
      'Please answer the current question before continuing.',
      name: 'pleaseAnswerTheQuestionFirst',
      desc: '',
      args: [],
    );
  }

  /// `Warning`
  String get warning {
    return Intl.message(
      'Warning',
      name: 'warning',
      desc: '',
      args: [],
    );
  }

  /// `Voninja Library`
  String get libraryTitle {
    return Intl.message(
      'Voninja Library',
      name: 'libraryTitle',
      desc: '',
      args: [],
    );
  }

  /// `Browse English learning books`
  String get librarySubtitle {
    return Intl.message(
      'Browse English learning books',
      name: 'librarySubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Join Challenges & Earn Points`
  String get joinChallengesEarnPoints {
    return Intl.message(
      'Join Challenges & Earn Points',
      name: 'joinChallengesEarnPoints',
      desc: '',
      args: [],
    );
  }

  /// `Complete daily challenges to collect rewards`
  String get completeDailyChallenges {
    return Intl.message(
      'Complete daily challenges to collect rewards',
      name: 'completeDailyChallenges',
      desc: '',
      args: [],
    );
  }

  /// `View All Challenges`
  String get viewAllChallenges {
    return Intl.message(
      'View All Challenges',
      name: 'viewAllChallenges',
      desc: '',
      args: [],
    );
  }

  /// `Discover Exciting Events`
  String get discoverExcitingEvents {
    return Intl.message(
      'Discover Exciting Events',
      name: 'discoverExcitingEvents',
      desc: '',
      args: [],
    );
  }

  /// `Participate in special events for exclusive rewards`
  String get participateSpecialEvents {
    return Intl.message(
      'Participate in special events for exclusive rewards',
      name: 'participateSpecialEvents',
      desc: '',
      args: [],
    );
  }

  /// `View All Events`
  String get viewAllEvents {
    return Intl.message(
      'View All Events',
      name: 'viewAllEvents',
      desc: '',
      args: [],
    );
  }

  /// `Events`
  String get events {
    return Intl.message(
      'Events',
      name: 'events',
      desc: '',
      args: [],
    );
  }

  /// `No events available`
  String get noEventsAvailable {
    return Intl.message(
      'No events available',
      name: 'noEventsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Starts in {time}`
  String startsIn(Object time) {
    return Intl.message(
      'Starts in $time',
      name: 'startsIn',
      desc: '',
      args: [time],
    );
  }

  /// `Ends in {time}`
  String endsIn(Object time) {
    return Intl.message(
      'Ends in $time',
      name: 'endsIn',
      desc: '',
      args: [time],
    );
  }

  /// `Not active yet`
  String get notActiveYet {
    return Intl.message(
      'Not active yet',
      name: 'notActiveYet',
      desc: '',
      args: [],
    );
  }

  /// `Ended`
  String get ended {
    return Intl.message(
      'Ended',
      name: 'ended',
      desc: '',
      args: [],
    );
  }

  /// `Correct answers: {current}/{goal}`
  String correctAnswers(Object current, Object goal) {
    return Intl.message(
      'Correct answers: $current/$goal',
      name: 'correctAnswers',
      desc: '',
      args: [current, goal],
    );
  }

  /// `Total answers: {current}/{total}`
  String totalAnswers(Object current, Object total) {
    return Intl.message(
      'Total answers: $current/$total',
      name: 'totalAnswers',
      desc: '',
      args: [current, total],
    );
  }

  /// `Points: {current}/{goal}`
  String points2(Object current, Object goal) {
    return Intl.message(
      'Points: $current/$goal',
      name: 'points2',
      desc: '',
      args: [current, goal],
    );
  }

  /// `{percentage}% completed`
  String completedPercentage(Object percentage) {
    return Intl.message(
      '$percentage% completed',
      name: 'completedPercentage',
      desc: '',
      args: [percentage],
    );
  }

  /// `Join`
  String get join {
    return Intl.message(
      'Join',
      name: 'join',
      desc: '',
      args: [],
    );
  }

  /// `In progress`
  String get inProgress {
    return Intl.message(
      'In progress',
      name: 'inProgress',
      desc: '',
      args: [],
    );
  }

  /// `Continue Quiz`
  String get continueQuiz {
    return Intl.message(
      'Continue Quiz',
      name: 'continueQuiz',
      desc: '',
      args: [],
    );
  }

  /// `Claim Reward`
  String get claimReward {
    return Intl.message(
      'Claim Reward',
      name: 'claimReward',
      desc: '',
      args: [],
    );
  }

  /// `Reward Claimed`
  String get rewardClaimed {
    return Intl.message(
      'Reward Claimed',
      name: 'rewardClaimed',
      desc: '',
      args: [],
    );
  }

  /// `Reward claimed!`
  String get rewardClaimedMessage {
    return Intl.message(
      'Reward claimed!',
      name: 'rewardClaimedMessage',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message(
      'Error',
      name: 'error',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
