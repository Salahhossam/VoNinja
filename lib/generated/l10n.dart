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
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
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
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Voninja`
  String get appTitle {
    return Intl.message('Voninja', name: 'appTitle', desc: '', args: []);
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
    return Intl.message('Login', name: 'login', desc: '', args: []);
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
    return Intl.message('Password', name: 'password', desc: '', args: []);
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
    return Intl.message('Remember me', name: 'rememberMe', desc: '', args: []);
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
    return Intl.message('Login', name: 'loginButton', desc: '', args: []);
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
    return Intl.message('Sign up', name: 'signUp', desc: '', args: []);
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
    return Intl.message('Register', name: 'register', desc: '', args: []);
  }

  /// `Frist Name`
  String get fristName {
    return Intl.message('Frist Name', name: 'fristName', desc: '', args: []);
  }

  /// `Last Name`
  String get lastName {
    return Intl.message('Last Name', name: 'lastName', desc: '', args: []);
  }

  /// `User Name`
  String get userName {
    return Intl.message('User Name', name: 'userName', desc: '', args: []);
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
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
    return Intl.message('Edit', name: 'edit', desc: '', args: []);
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
    return Intl.message('EGP', name: 'egp', desc: '', args: []);
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
    return Intl.message('Follow us!', name: 'followUs', desc: '', args: []);
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
    return Intl.message('Cash', name: 'cash', desc: '', args: []);
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
    return Intl.message('Get Points', name: 'getPoints', desc: '', args: []);
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Transaction`
  String get transaction {
    return Intl.message('Transaction', name: 'transaction', desc: '', args: []);
  }

  /// `About Us`
  String get about {
    return Intl.message('About Us', name: 'about', desc: '', args: []);
  }

  /// `Version`
  String get version {
    return Intl.message('Version', name: 'version', desc: '', args: []);
  }

  /// `Logout`
  String get logout {
    return Intl.message('Logout', name: 'logout', desc: '', args: []);
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
    return Intl.message('Leaderboard', name: 'leaderboard', desc: '', args: []);
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
    return Intl.message('Hi', name: 'hi', desc: '', args: []);
  }

  /// `Points`
  String get points {
    return Intl.message('Points', name: 'points', desc: '', args: []);
  }

  /// `Rank`
  String get rank {
    return Intl.message('Rank', name: 'rank', desc: '', args: []);
  }

  /// `Progress`
  String get progress {
    return Intl.message('Progress', name: 'progress', desc: '', args: []);
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
    return Intl.message('Challenges', name: 'challenges', desc: '', args: []);
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
    return Intl.message('Task', name: 'taskNumber', desc: '', args: []);
  }

  /// `Tasks`
  String get tasks {
    return Intl.message('Tasks', name: 'tasks', desc: '', args: []);
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
    return Intl.message('Place', name: 'placeNumber', desc: '', args: []);
  }

  /// `pts`
  String get rankPointsNumber {
    return Intl.message('pts', name: 'rankPointsNumber', desc: '', args: []);
  }

  /// `1st`
  String get firstPlace {
    return Intl.message('1st', name: 'firstPlace', desc: '', args: []);
  }

  /// `2nd`
  String get secondPlace {
    return Intl.message('2nd', name: 'secondPlace', desc: '', args: []);
  }

  /// `3rd`
  String get thirdPlace {
    return Intl.message('3rd', name: 'thirdPlace', desc: '', args: []);
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
    return Intl.message('Next Task', name: 'nextTask', desc: '', args: []);
  }

  /// `Top 10`
  String get topTen {
    return Intl.message('Top 10', name: 'topTen', desc: '', args: []);
  }

  /// `You`
  String get you {
    return Intl.message('You', name: 'you', desc: '', args: []);
  }

  /// `Show Ranks`
  String get showRanks {
    return Intl.message('Show Ranks', name: 'showRanks', desc: '', args: []);
  }

  /// `Lessons`
  String get lessons {
    return Intl.message('Lessons', name: 'lessons', desc: '', args: []);
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

  /// `For each correct answer, you will earn points`
  String get correctAnswerPoints {
    return Intl.message(
      'For each correct answer, you will earn points',
      name: 'correctAnswerPoints',
      desc: '',
      args: [],
    );
  }

  /// `Lesson`
  String get lessonNumber {
    return Intl.message('Lesson', name: 'lessonNumber', desc: '', args: []);
  }

  /// `Point`
  String get pointNumber {
    return Intl.message('Point', name: 'pointNumber', desc: '', args: []);
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
    return Intl.message('Start Exam', name: 'startExam', desc: '', args: []);
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
    return Intl.message('pts', name: 'pts', desc: '', args: []);
  }

  /// `Back to home`
  String get backToHome {
    return Intl.message('Back to home', name: 'backToHome', desc: '', args: []);
  }

  /// `Back`
  String get back {
    return Intl.message('Back', name: 'back', desc: '', args: []);
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
    return Intl.message('Continue', name: 'continueExams', desc: '', args: []);
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
    return Intl.message('+10 Points', name: 'plus20Points', desc: '', args: []);
  }

  /// `Next Lesson`
  String get nextLesson {
    return Intl.message('Next Lesson', name: 'nextLesson', desc: '', args: []);
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
    return Intl.message('Okay', name: 'okay', desc: '', args: []);
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
    return Intl.message('Warning', name: 'warning', desc: '', args: []);
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
    return Intl.message('Events', name: 'events', desc: '', args: []);
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
    return Intl.message('Ended', name: 'ended', desc: '', args: []);
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
    return Intl.message('Join', name: 'join', desc: '', args: []);
  }

  /// `In progress`
  String get inProgress {
    return Intl.message('In progress', name: 'inProgress', desc: '', args: []);
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
    return Intl.message('Error', name: 'error', desc: '', args: []);
  }

  /// `Special Points Offer`
  String get specialOfferTitle {
    return Intl.message(
      'Special Points Offer',
      name: 'specialOfferTitle',
      desc: '',
      args: [],
    );
  }

  /// `You can earn more points right now by visiting the Events page. There is also a Welcome Event that grants you extra bonus points on your first visit. Would you like to go now, or continue your exam?`
  String get specialOfferBody {
    return Intl.message(
      'You can earn more points right now by visiting the Events page. There is also a Welcome Event that grants you extra bonus points on your first visit. Would you like to go now, or continue your exam?',
      name: 'specialOfferBody',
      desc: '',
      args: [],
    );
  }

  /// `Go to Events`
  String get goToEvents {
    return Intl.message('Go to Events', name: 'goToEvents', desc: '', args: []);
  }

  /// `Continue Exam`
  String get continueExam {
    return Intl.message(
      'Continue Exam',
      name: 'continueExam',
      desc: '',
      args: [],
    );
  }

  /// `Good luck! Review your answers and try again in the next event.`
  String get goodLuck {
    return Intl.message(
      'Good luck! Review your answers and try again in the next event.',
      name: 'goodLuck',
      desc: '',
      args: [],
    );
  }

  /// `Show my answers`
  String get showMyAnswers {
    return Intl.message(
      'Show my answers',
      name: 'showMyAnswers',
      desc: '',
      args: [],
    );
  }

  /// `Treasure Boxes`
  String get treasureBoxes {
    return Intl.message(
      'Treasure Boxes',
      name: 'treasureBoxes',
      desc: '',
      args: [],
    );
  }

  /// `Start New Cycle`
  String get startNewCycle {
    return Intl.message(
      'Start New Cycle',
      name: 'startNewCycle',
      desc: '',
      args: [],
    );
  }

  /// `🎯 Want to start a new adventure?`
  String get wantNewAdventure {
    return Intl.message(
      '🎯 Want to start a new adventure?',
      name: 'wantNewAdventure',
      desc: '',
      args: [],
    );
  }

  /// `You can reset the cycle now and start with a reward of 500 points. Or continue as you are and keep your current points.`
  String get newCycleDescription {
    return Intl.message(
      'You can reset the cycle now and start with a reward of 500 points. Or continue as you are and keep your current points.',
      name: 'newCycleDescription',
      desc: '',
      args: [],
    );
  }

  /// `⚠️ Important warning:`
  String get importantWarning {
    return Intl.message(
      '⚠️ Important warning:',
      name: 'importantWarning',
      desc: '',
      args: [],
    );
  }

  /// `If your balance exceeds 25,000 points, you must first make a transfer request to receive cash in your wallet within 48 working hours. Then you can start a new cycle with a 500 point reward. If your current points are more than 500, they will be replaced with only 500 points.`
  String get cycleWarning {
    return Intl.message(
      'If your balance exceeds 25,000 points, you must first make a transfer request to receive cash in your wallet within 48 working hours. Then you can start a new cycle with a 500 point reward. If your current points are more than 500, they will be replaced with only 500 points.',
      name: 'cycleWarning',
      desc: '',
      args: [],
    );
  }

  /// `Confirm starting new cycle`
  String get confirmNewCycle {
    return Intl.message(
      'Confirm starting new cycle',
      name: 'confirmNewCycle',
      desc: '',
      args: [],
    );
  }

  /// `By pressing "Confirm", a new cycle will begin and your balance will be reset to 500 points.\nWe recommend using your existing points before starting a new cycle.\n⚠️ If your balance is 25,000 points or more, you must submit a transfer request first.`
  String get confirmNewCycleDescription {
    return Intl.message(
      'By pressing "Confirm", a new cycle will begin and your balance will be reset to 500 points.\nWe recommend using your existing points before starting a new cycle.\n⚠️ If your balance is 25,000 points or more, you must submit a transfer request first.',
      name: 'confirmNewCycleDescription',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message('Confirm', name: 'confirm', desc: '', args: []);
  }

  /// `Complete the current level first`
  String get completeCurrentLevel {
    return Intl.message(
      'Complete the current level first',
      name: 'completeCurrentLevel',
      desc: '',
      args: [],
    );
  }

  /// `Your Points`
  String get yourPoints {
    return Intl.message('Your Points', name: 'yourPoints', desc: '', args: []);
  }

  /// `Cycle`
  String get cycle {
    return Intl.message('Cycle', name: 'cycle', desc: '', args: []);
  }

  /// `Bronze`
  String get bronze {
    return Intl.message('Bronze', name: 'bronze', desc: '', args: []);
  }

  /// `Silver`
  String get silver {
    return Intl.message('Silver', name: 'silver', desc: '', args: []);
  }

  /// `Gold`
  String get gold {
    return Intl.message('Gold', name: 'gold', desc: '', args: []);
  }

  /// `Ad is not currently available, try again in a moment.`
  String get adNotAvailable {
    return Intl.message(
      'Ad is not currently available, try again in a moment.',
      name: 'adNotAvailable',
      desc: '',
      args: [],
    );
  }

  /// `You cannot access this level before completing the previous one.`
  String get cannotAccessLevel {
    return Intl.message(
      'You cannot access this level before completing the previous one.',
      name: 'cannotAccessLevel',
      desc: '',
      args: [],
    );
  }

  /// `You need {points} additional points. `
  String needPoints(Object points) {
    return Intl.message(
      'You need $points additional points. ',
      name: 'needPoints',
      desc: '',
      args: [points],
    );
  }

  /// `Watch {ads} ad(s).`
  String watchAds(Object ads) {
    return Intl.message(
      'Watch $ads ad(s).',
      name: 'watchAds',
      desc: '',
      args: [ads],
    );
  }

  /// `You earned {points} points.`
  String earnedPoints(Object points) {
    return Intl.message(
      'You earned $points points.',
      name: 'earnedPoints',
      desc: '',
      args: [points],
    );
  }

  /// `Congratulations! All boxes for cycle #{cycle} have been completed.`
  String congratsAllBoxes(Object cycle) {
    return Intl.message(
      'Congratulations! All boxes for cycle #$cycle have been completed.',
      name: 'congratsAllBoxes',
      desc: '',
      args: [cycle],
    );
  }

  /// `Complete all boxes first.`
  String get completeAllBoxesFirst {
    return Intl.message(
      'Complete all boxes first.',
      name: 'completeAllBoxesFirst',
      desc: '',
      args: [],
    );
  }

  /// `New cycle started (#{cycle}). Good luck!`
  String newCycleStarted(Object cycle) {
    return Intl.message(
      'New cycle started (#$cycle). Good luck!',
      name: 'newCycleStarted',
      desc: '',
      args: [cycle],
    );
  }

  /// `Treasure Boxes`
  String get treasureBoxesCard {
    return Intl.message(
      'Treasure Boxes',
      name: 'treasureBoxesCard',
      desc: '',
      args: [],
    );
  }

  /// `Bronze • Silver • Gold`
  String get treasureBoxesLevels {
    return Intl.message(
      'Bronze • Silver • Gold',
      name: 'treasureBoxesLevels',
      desc: '',
      args: [],
    );
  }

  /// `#{number}`
  String boxNumber(Object number) {
    return Intl.message(
      '#$number',
      name: 'boxNumber',
      desc: '',
      args: [number],
    );
  }

  /// `Reward + {points} pts`
  String rewardPoints(Object points) {
    return Intl.message(
      'Reward + $points pts',
      name: 'rewardPoints',
      desc: '',
      args: [points],
    );
  }

  /// `Need {current}/{required} pts`
  String needPoints2(Object current, Object required) {
    return Intl.message(
      'Need $current/$required pts',
      name: 'needPoints2',
      desc: '',
      args: [current, required],
    );
  }

  /// `Need {current}/{required} pts`
  String needPointsRemaining(Object current, Object required) {
    return Intl.message(
      'Need $current/$required pts',
      name: 'needPointsRemaining',
      desc: '',
      args: [current, required],
    );
  }

  /// `Ads {current}/{required}`
  String adsProgress(Object current, Object required) {
    return Intl.message(
      'Ads $current/$required',
      name: 'adsProgress',
      desc: '',
      args: [current, required],
    );
  }

  /// `Watch Ad`
  String get watchAd {
    return Intl.message('Watch Ad', name: 'watchAd', desc: '', args: []);
  }

  /// `Open`
  String get open {
    return Intl.message('Open', name: 'open', desc: '', args: []);
  }

  /// `🎉 Congratulations`
  String get congratulations {
    return Intl.message(
      '🎉 Congratulations',
      name: 'congratulations',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message('OK', name: 'ok', desc: '', args: []);
  }

  /// `Cannot start a new cycle`
  String get cannotStartNewCycle {
    return Intl.message(
      'Cannot start a new cycle',
      name: 'cannotStartNewCycle',
      desc: '',
      args: [],
    );
  }

  /// `Your balance is above 25,000 points. Please submit a transfer request first before starting a new cycle.`
  String get mustTransferPointsFirst {
    return Intl.message(
      'Your balance is above 25,000 points. Please submit a transfer request first before starting a new cycle.',
      name: 'mustTransferPointsFirst',
      desc: '',
      args: [],
    );
  }

  /// `Welcome Challenge Instructions`
  String get intro_appBarTitle {
    return Intl.message(
      'Welcome Challenge Instructions',
      name: 'intro_appBarTitle',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to VoNinja! This is a welcome challenge:`
  String get intro_title {
    return Intl.message(
      'Welcome to VoNinja! This is a welcome challenge:',
      name: 'intro_title',
      desc: '',
      args: [],
    );
  }

  /// `Answer all the challenge questions.`
  String get intro_bullet_all_questions {
    return Intl.message(
      'Answer all the challenge questions.',
      name: 'intro_bullet_all_questions',
      desc: '',
      args: [],
    );
  }

  /// `You have only 5 minutes from the moment you start.`
  String get intro_bullet_five_minutes {
    return Intl.message(
      'You have only 5 minutes from the moment you start.',
      name: 'intro_bullet_five_minutes',
      desc: '',
      args: [],
    );
  }

  /// `If you answer all questions correctly before time runs out, you will earn 500 points!`
  String get intro_bullet_reward {
    return Intl.message(
      'If you answer all questions correctly before time runs out, you will earn 500 points!',
      name: 'intro_bullet_reward',
      desc: '',
      args: [],
    );
  }

  /// `Start Challenge`
  String get intro_startButton {
    return Intl.message(
      'Start Challenge',
      name: 'intro_startButton',
      desc: '',
      args: [],
    );
  }

  /// `Congratulations!`
  String get final_congrats_title {
    return Intl.message(
      'Congratulations!',
      name: 'final_congrats_title',
      desc: '',
      args: [],
    );
  }

  /// `You finished all questions correctly within {minutes} minutes. 500 points have been added to your balance.`
  String final_congrats_desc(Object minutes) {
    return Intl.message(
      'You finished all questions correctly within $minutes minutes. 500 points have been added to your balance.',
      name: 'final_congrats_desc',
      desc: '',
      args: [minutes],
    );
  }

  /// `Better luck next time`
  String get final_tryAgain_title {
    return Intl.message(
      'Better luck next time',
      name: 'final_tryAgain_title',
      desc: '',
      args: [],
    );
  }

  /// `You finished before time, but some answers were incorrect.\nTry again!`
  String get final_tryAgain_desc_inTimeWrong {
    return Intl.message(
      'You finished before time, but some answers were incorrect.\nTry again!',
      name: 'final_tryAgain_desc_inTimeWrong',
      desc: '',
      args: [],
    );
  }

  /// `Time ended before completing all answers correctly.\nTry again!`
  String get final_tryAgain_desc_timeOver {
    return Intl.message(
      'Time ended before completing all answers correctly.\nTry again!',
      name: 'final_tryAgain_desc_timeOver',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get final_ok {
    return Intl.message('OK', name: 'final_ok', desc: '', args: []);
  }

  /// `Home`
  String get nav_home {
    return Intl.message('Home', name: 'nav_home', desc: '', args: []);
  }

  /// `Challenges`
  String get nav_challenges {
    return Intl.message(
      'Challenges',
      name: 'nav_challenges',
      desc: '',
      args: [],
    );
  }

  /// `Leaderboard`
  String get nav_leaderboard {
    return Intl.message(
      'Leaderboard',
      name: 'nav_leaderboard',
      desc: '',
      args: [],
    );
  }

  /// `Treasures`
  String get nav_treasure {
    return Intl.message('Treasures', name: 'nav_treasure', desc: '', args: []);
  }

  /// `Settings`
  String get nav_settings {
    return Intl.message('Settings', name: 'nav_settings', desc: '', args: []);
  }

  /// `Could not switch tab`
  String get select_tap_error {
    return Intl.message(
      'Could not switch tab',
      name: 'select_tap_error',
      desc: '',
      args: [],
    );
  }

  /// `Learn`
  String get nav_learn {
    return Intl.message('Learn', name: 'nav_learn', desc: '', args: []);
  }

  /// `Locked`
  String get locked {
    return Intl.message('Locked', name: 'locked', desc: '', args: []);
  }

  /// `About Us`
  String get aboutUs {
    return Intl.message('About Us', name: 'aboutUs', desc: '', args: []);
  }

  /// `Technical Support`
  String get technicalSupport {
    return Intl.message(
      'Technical Support',
      name: 'technicalSupport',
      desc: '',
      args: [],
    );
  }

  /// `📖 About Voninja`
  String get about_title {
    return Intl.message(
      '📖 About Voninja',
      name: 'about_title',
      desc: '',
      args: [],
    );
  }

  /// `Voninja is an innovative learning app for mastering English words and vocabulary in a fun, interactive way.`
  String get about_intro_1 {
    return Intl.message(
      'Voninja is an innovative learning app for mastering English words and vocabulary in a fun, interactive way.',
      name: 'about_intro_1',
      desc: '',
      args: [],
    );
  }

  /// `It combines learning + challenges + real rewards to make your learning experience engaging and exciting.`
  String get about_intro_2 {
    return Intl.message(
      'It combines learning + challenges + real rewards to make your learning experience engaging and exciting.',
      name: 'about_intro_2',
      desc: '',
      args: [],
    );
  }

  /// `Voninja Features:`
  String get features_title {
    return Intl.message(
      'Voninja Features:',
      name: 'features_title',
      desc: '',
      args: [],
    );
  }

  /// `🎯 Interactive lessons: learn new words through short, easy questions.`
  String get feature_interactive_lessons {
    return Intl.message(
      '🎯 Interactive lessons: learn new words through short, easy questions.',
      name: 'feature_interactive_lessons',
      desc: '',
      args: [],
    );
  }

  /// `🏆 Challenges: tasks with specific points to keep you progressing step by step.`
  String get feature_challenges {
    return Intl.message(
      '🏆 Challenges: tasks with specific points to keep you progressing step by step.',
      name: 'feature_challenges',
      desc: '',
      args: [],
    );
  }

  /// `📚 Voninja Library: a collection of PDF files to expand your vocabulary.`
  String get feature_library {
    return Intl.message(
      '📚 Voninja Library: a collection of PDF files to expand your vocabulary.',
      name: 'feature_library',
      desc: '',
      args: [],
    );
  }

  /// `🎁 Treasure Boxes Page: progressive boxes (Bronze – Silver – Gold) that unlock gradually and reward you with points and gifts.`
  String get feature_treasure {
    return Intl.message(
      '🎁 Treasure Boxes Page: progressive boxes (Bronze – Silver – Gold) that unlock gradually and reward you with points and gifts.',
      name: 'feature_treasure',
      desc: '',
      args: [],
    );
  }

  /// `📅 Special Events: time-limited events that boost your engagement and unlock big rewards.`
  String get feature_events {
    return Intl.message(
      '📅 Special Events: time-limited events that boost your engagement and unlock big rewards.',
      name: 'feature_events',
      desc: '',
      args: [],
    );
  }

  /// `Rewards System:`
  String get rewards_title {
    return Intl.message(
      'Rewards System:',
      name: 'rewards_title',
      desc: '',
      args: [],
    );
  }

  /// `With Voninja, every point you learn has real value 💰`
  String get rewards_intro {
    return Intl.message(
      'With Voninja, every point you learn has real value 💰',
      name: 'rewards_intro',
      desc: '',
      args: [],
    );
  }

  /// `When you collect 25,000 points, you can convert them directly to 100 EGP cash.`
  String get rewards_cash {
    return Intl.message(
      'When you collect 25,000 points, you can convert them directly to 100 EGP cash.',
      name: 'rewards_cash',
      desc: '',
      args: [],
    );
  }

  /// `If you use the app for two hours daily, you can reach 25,000 points in a short period of only 3–5 days.`
  String get rewards_time {
    return Intl.message(
      'If you use the app for two hours daily, you can reach 25,000 points in a short period of only 3–5 days.',
      name: 'rewards_time',
      desc: '',
      args: [],
    );
  }

  /// `Our Goal:`
  String get goal_title {
    return Intl.message('Our Goal:', name: 'goal_title', desc: '', args: []);
  }

  /// `Make learning English easy, enjoyable, and financially rewarding at the same time. With Voninja, every minute you learn brings you closer to your language goal—and helps you earn extra income from your effort.`
  String get goal_body {
    return Intl.message(
      'Make learning English easy, enjoyable, and financially rewarding at the same time. With Voninja, every minute you learn brings you closer to your language goal—and helps you earn extra income from your effort.',
      name: 'goal_body',
      desc: '',
      args: [],
    );
  }

  /// `🛠️ Technical Support`
  String get support_title {
    return Intl.message(
      '🛠️ Technical Support',
      name: 'support_title',
      desc: '',
      args: [],
    );
  }

  /// `If you face any issue or have a question about using Voninja, our support team is ready to help anytime.`
  String get support_intro {
    return Intl.message(
      'If you face any issue or have a question about using Voninja, our support team is ready to help anytime.',
      name: 'support_intro',
      desc: '',
      args: [],
    );
  }

  /// `Support Email`
  String get support_email_label {
    return Intl.message(
      'Support Email',
      name: 'support_email_label',
      desc: '',
      args: [],
    );
  }

  /// `voninja15@gmail.com`
  String get support_email_value {
    return Intl.message(
      'voninja15@gmail.com',
      name: 'support_email_value',
      desc: '',
      args: [],
    );
  }

  /// `WhatsApp Support`
  String get support_whatsapp_label {
    return Intl.message(
      'WhatsApp Support',
      name: 'support_whatsapp_label',
      desc: '',
      args: [],
    );
  }

  /// `+20 1034672064`
  String get support_whatsapp_value {
    return Intl.message(
      '+20 1034672064',
      name: 'support_whatsapp_value',
      desc: '',
      args: [],
    );
  }

  /// `You can contact us at any time, and our team will get back to you as soon as possible to solve your problem or answer your questions.`
  String get support_note {
    return Intl.message(
      'You can contact us at any time, and our team will get back to you as soon as possible to solve your problem or answer your questions.',
      name: 'support_note',
      desc: '',
      args: [],
    );
  }

  /// `Frequently Asked Questions`
  String get faq_title {
    return Intl.message(
      'Frequently Asked Questions',
      name: 'faq_title',
      desc: '',
      args: [],
    );
  }

  /// `How fast do you respond?`
  String get faq_q1 {
    return Intl.message(
      'How fast do you respond?',
      name: 'faq_q1',
      desc: '',
      args: [],
    );
  }

  /// `We usually reply within a few hours. During events and peak times, it may take a little longer.`
  String get faq_a1 {
    return Intl.message(
      'We usually reply within a few hours. During events and peak times, it may take a little longer.',
      name: 'faq_a1',
      desc: '',
      args: [],
    );
  }

  /// `What info should I include in my message?`
  String get faq_q2 {
    return Intl.message(
      'What info should I include in my message?',
      name: 'faq_q2',
      desc: '',
      args: [],
    );
  }

  /// `Please share your device type, app version, and a brief description or a screenshot of the issue.`
  String get faq_a2 {
    return Intl.message(
      'Please share your device type, app version, and a brief description or a screenshot of the issue.',
      name: 'faq_a2',
      desc: '',
      args: [],
    );
  }

  /// `Can I contact you outside business hours?`
  String get faq_q3 {
    return Intl.message(
      'Can I contact you outside business hours?',
      name: 'faq_q3',
      desc: '',
      args: [],
    );
  }

  /// `Yes, messages are accepted 24/7. Our team will get back to you in the next available window.`
  String get faq_a3 {
    return Intl.message(
      'Yes, messages are accepted 24/7. Our team will get back to you in the next available window.',
      name: 'faq_a3',
      desc: '',
      args: [],
    );
  }

  /// `Copied`
  String get copied {
    return Intl.message('Copied', name: 'copied', desc: '', args: []);
  }

  /// `Copy`
  String get copy {
    return Intl.message('Copy', name: 'copy', desc: '', args: []);
  }

  /// `User Guide`
  String get userGuide {
    return Intl.message('User Guide', name: 'userGuide', desc: '', args: []);
  }

  /// `Voninja — Learn & Earn`
  String get userGuide_headerTitle {
    return Intl.message(
      'Voninja — Learn & Earn',
      name: 'userGuide_headerTitle',
      desc: '',
      args: [],
    );
  }

  /// `Short lessons, quizzes, challenges, treasure boxes, and real cash rewards.`
  String get userGuide_headerSubtitle {
    return Intl.message(
      'Short lessons, quizzes, challenges, treasure boxes, and real cash rewards.',
      name: 'userGuide_headerSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `What is Voninja?`
  String get ug_1_title {
    return Intl.message(
      'What is Voninja?',
      name: 'ug_1_title',
      desc: '',
      args: [],
    );
  }

  /// `Voninja is an interactive learning app for English using short lessons, quizzes, challenges, and a points system. Every learning activity grants points that can be converted into real cash rewards.`
  String get ug_1_body {
    return Intl.message(
      'Voninja is an interactive learning app for English using short lessons, quizzes, challenges, and a points system. Every learning activity grants points that can be converted into real cash rewards.',
      name: 'ug_1_body',
      desc: '',
      args: [],
    );
  }

  /// `What levels are available?`
  String get ug_2_title {
    return Intl.message(
      'What levels are available?',
      name: 'ug_2_title',
      desc: '',
      args: [],
    );
  }

  /// `The app offers three learning levels:\n• Basic: each lesson = 1 point.\n• Intermediate: each lesson = 2 points.\n• Advanced: each lesson = 3 points.\nAfter every lesson, a short quiz evaluates your recall and adds points automatically.`
  String get ug_2_body {
    return Intl.message(
      'The app offers three learning levels:\n• Basic: each lesson = 1 point.\n• Intermediate: each lesson = 2 points.\n• Advanced: each lesson = 3 points.\nAfter every lesson, a short quiz evaluates your recall and adds points automatically.',
      name: 'ug_2_body',
      desc: '',
      args: [],
    );
  }

  /// `What are "Challenges"?`
  String get ug_3_title {
    return Intl.message(
      'What are "Challenges"?',
      name: 'ug_3_title',
      desc: '',
      args: [],
    );
  }

  /// `Challenges are multi-question tasks. Each correct answer can grant 3, 5, 10, 20, 25 points or more. To join a challenge, you must meet the entry requirement (e.g., have 2,000 points).`
  String get ug_3_body {
    return Intl.message(
      'Challenges are multi-question tasks. Each correct answer can grant 3, 5, 10, 20, 25 points or more. To join a challenge, you must meet the entry requirement (e.g., have 2,000 points).',
      name: 'ug_3_body',
      desc: '',
      args: [],
    );
  }

  /// `What are "Events"?`
  String get ug_4_title {
    return Intl.message(
      'What are "Events"?',
      name: 'ug_4_title',
      desc: '',
      args: [],
    );
  }

  /// `Time-limited events that grant extra rewards, such as:\n• Double Points Day: all points earned double for 24 hours.\n• Kickstart Challenge: earn 1,000 points in your first 48 hours to get +3,000 points.\n• Quiz Master 100: answer 100 questions correctly within 48 hours to get +1,000 points.`
  String get ug_4_body {
    return Intl.message(
      'Time-limited events that grant extra rewards, such as:\n• Double Points Day: all points earned double for 24 hours.\n• Kickstart Challenge: earn 1,000 points in your first 48 hours to get +3,000 points.\n• Quiz Master 100: answer 100 questions correctly within 48 hours to get +1,000 points.',
      name: 'ug_4_body',
      desc: '',
      args: [],
    );
  }

  /// `How do Treasure Boxes work?`
  String get ug_5_title {
    return Intl.message(
      'How do Treasure Boxes work?',
      name: 'ug_5_title',
      desc: '',
      args: [],
    );
  }

  /// `Voninja Treasures include Bronze, Silver, and Gold boxes. Each box requires a minimum points balance and ad views to enter, and grants increasing point rewards.`
  String get ug_5_body {
    return Intl.message(
      'Voninja Treasures include Bronze, Silver, and Gold boxes. Each box requires a minimum points balance and ad views to enter, and grants increasing point rewards.',
      name: 'ug_5_body',
      desc: '',
      args: [],
    );
  }

  /// `Can I boost points with ads?`
  String get ug_6_title {
    return Intl.message(
      'Can I boost points with ads?',
      name: 'ug_6_title',
      desc: '',
      args: [],
    );
  }

  /// `Yes. Watch a short ad to get +10 extra points, or claim bonus points after each quiz via a rewarded ad.`
  String get ug_6_body {
    return Intl.message(
      'Yes. Watch a short ad to get +10 extra points, or claim bonus points after each quiz via a rewarded ad.',
      name: 'ug_6_body',
      desc: '',
      args: [],
    );
  }

  /// `What is the Voninja Library?`
  String get ug_7_title {
    return Intl.message(
      'What is the Voninja Library?',
      name: 'ug_7_title',
      desc: '',
      args: [],
    );
  }

  /// `An in-app library of educational PDF books. You can unlock and read books directly after paying with points.`
  String get ug_7_body {
    return Intl.message(
      'An in-app library of educational PDF books. You can unlock and read books directly after paying with points.',
      name: 'ug_7_body',
      desc: '',
      args: [],
    );
  }

  /// `How does the "Treasure Recycle" work?`
  String get ug_8_title {
    return Intl.message(
      'How does the "Treasure Recycle" work?',
      name: 'ug_8_title',
      desc: '',
      args: [],
    );
  }

  /// `After finishing Bronze + Silver + Gold boxes and reaching 25,000 points, you can request a 100 EGP cashout by entering your wallet number in the transfer screen. Your points then reset to 0 so you can re-enter Voninja Treasures and start the cycle again.`
  String get ug_8_body {
    return Intl.message(
      'After finishing Bronze + Silver + Gold boxes and reaching 25,000 points, you can request a 100 EGP cashout by entering your wallet number in the transfer screen. Your points then reset to 0 so you can re-enter Voninja Treasures and start the cycle again.',
      name: 'ug_8_body',
      desc: '',
      args: [],
    );
  }

  /// `How do I get reward codes from social media?`
  String get ug_9_title {
    return Intl.message(
      'How do I get reward codes from social media?',
      name: 'ug_9_title',
      desc: '',
      args: [],
    );
  }

  /// `Follow our social pages for questions and giveaways. Winners receive a special code. Go to Settings → Social Media and enter your reward code to redeem.`
  String get ug_9_body {
    return Intl.message(
      'Follow our social pages for questions and giveaways. Winners receive a special code. Go to Settings → Social Media and enter your reward code to redeem.',
      name: 'ug_9_body',
      desc: '',
      args: [],
    );
  }

  /// `Social reward code example`
  String get ug_image_alt_social {
    return Intl.message(
      'Social reward code example',
      name: 'ug_image_alt_social',
      desc: '',
      args: [],
    );
  }

  /// `How do I cash out?`
  String get ug_10_title {
    return Intl.message(
      'How do I cash out?',
      name: 'ug_10_title',
      desc: '',
      args: [],
    );
  }

  /// `Every 25,000 points = 100 EGP, processed within 24–48 hours after submitting a request. Go to Settings → “Get your coins now”, enter your wallet or a contact number, and track the transfer via the WhatsApp number listed under Technical Support. Cashouts are currently available for Egyptian wallets/numbers only, with plans to expand globally.`
  String get ug_10_body {
    return Intl.message(
      'Every 25,000 points = 100 EGP, processed within 24–48 hours after submitting a request. Go to Settings → “Get your coins now”, enter your wallet or a contact number, and track the transfer via the WhatsApp number listed under Technical Support. Cashouts are currently available for Egyptian wallets/numbers only, with plans to expand globally.',
      name: 'ug_10_body',
      desc: '',
      args: [],
    );
  }

  /// `Cashout flow example`
  String get ug_image_alt_cashout {
    return Intl.message(
      'Cashout flow example',
      name: 'ug_image_alt_cashout',
      desc: '',
      args: [],
    );
  }

  /// `Why choose Voninja?`
  String get ug_11_title {
    return Intl.message(
      'Why choose Voninja?',
      name: 'ug_11_title',
      desc: '',
      args: [],
    );
  }

  /// `Voninja combines fun learning with real incentives. Three lesson levels suit all learners; challenges, events, and treasure boxes keep you motivated; and points convert quickly into real rewards.`
  String get ug_11_body {
    return Intl.message(
      'Voninja combines fun learning with real incentives. Three lesson levels suit all learners; challenges, events, and treasure boxes keep you motivated; and points convert quickly into real rewards.',
      name: 'ug_11_body',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to start a new cycle? This action will reset all boxes.`
  String get confirmNewCycleDesc {
    return Intl.message(
      'Are you sure you want to start a new cycle? This action will reset all boxes.',
      name: 'confirmNewCycleDesc',
      desc: '',
      args: [],
    );
  }

  /// `You must complete a withdrawal transaction before starting a new cycle.`
  String get mustTransferPointsFirst2 {
    return Intl.message(
      'You must complete a withdrawal transaction before starting a new cycle.',
      name: 'mustTransferPointsFirst2',
      desc: '',
      args: [],
    );
  }

  /// `No email provided`
  String get no_email_provided {
    return Intl.message(
      'No email provided',
      name: 'no_email_provided',
      desc: '',
      args: [],
    );
  }

  /// `Success`
  String get success {
    return Intl.message('Success', name: 'success', desc: '', args: []);
  }

  /// `Operation successful`
  String get operationSuccessful {
    return Intl.message(
      'Operation successful',
      name: 'operationSuccessful',
      desc: '',
      args: [],
    );
  }

  /// `Operation failed`
  String get operationFailed {
    return Intl.message(
      'Operation failed',
      name: 'operationFailed',
      desc: '',
      args: [],
    );
  }

  /// `Try again`
  String get tryAgain {
    return Intl.message('Try again', name: 'tryAgain', desc: '', args: []);
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
