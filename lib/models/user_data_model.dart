class UserDataModel {
  final String? userId;
  String? firstName;
  String? lastName;
  String? userName;
  String? userNameLowerCase;
  String? userPhoneNumber;
  String? userAvatar;
  final String? userEmail;
  final String? referLink;
  final bool? isReferred;
  double? pointsNumber;
  final String? fcmToken;
  final String? role;

  final double? rankNumber;
  final String? versionNumber;
  final double? userBalance;
  final DateTime ? lastRewardDate;
  final DateTime ? lastDailyReward;
  UserDataModel(
      {this.userId,
      this.firstName,
      this.lastName,
      this.referLink,
      this.isReferred,
      this.userPhoneNumber,
      this.userEmail,
      this.userName,
      this.userNameLowerCase,
      this.userAvatar,
      this.userBalance,
      this.pointsNumber,
      this.versionNumber,
      this.rankNumber,
      this.fcmToken,
        this.lastRewardDate,
        this.lastDailyReward,
      this.role});
  factory UserDataModel.fromJson(Map<String, dynamic> json) {
    return UserDataModel(
      userId: json['userId'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      userName: json['username'] as String? ?? '', // Mapped correctly
      userNameLowerCase:
          json['userNameLowerCase'] as String? ?? '', // Mapped correctly
      userPhoneNumber: json['phoneNumber'] as String? ?? '', // Mapped correctly
      userEmail: json['email'] as String? ?? '',
      referLink: json['userId'] as String? ?? '',
      userAvatar: json['userAvatar'] as String? ?? '',
      isReferred: json['isReferred'] as bool? ?? true,
      pointsNumber: double.tryParse(json['pointsNumber'].toString()) ?? 0,
      fcmToken: json['fcmToken'] as String? ?? '',
      lastRewardDate: json['lastAdDate']?.toDate(),
      lastDailyReward: json['lastDailyReward']?.toDate(),
    );
  }
  // Simulated JSON response
  // Map<String, dynamic> userJson = {
  //   "userId": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
  //   "firstName": "string",
  //   "lastName": "string",
  //   "username": "string",
  //   "phoneNumber": 0123456789.0,
  //   "email": "string",
  //   "referLink": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
  //   "isReferred": true
  // };

  UserDataModel copyWith({
    String? userId,
    String? firstName,
    String? lastName,
    String? userName,
    String? userNameLowerCase,
    String? userPhoneNumber,
    String? userAvatar,
    String? userEmail,
    String? referLink,
    bool? isReferred,
    double? pointsNumber,
    String? fcmToken,
    String? role,
    double? rankNumber,
    String? versionNumber,
    double? userBalance,
    DateTime? lastRewardDate,
  }) {
    return UserDataModel(
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      userName: userName ?? this.userName,
      userNameLowerCase: userNameLowerCase ?? this.userNameLowerCase,
      userPhoneNumber: userPhoneNumber ?? this.userPhoneNumber,
      userAvatar: userAvatar ?? this.userAvatar,
      userEmail: userEmail ?? this.userEmail,
      referLink: referLink ?? this.referLink,
      isReferred: isReferred ?? this.isReferred,
      pointsNumber: pointsNumber ?? this.pointsNumber,
      fcmToken: fcmToken ?? this.fcmToken,
      role: role ?? this.role,
      rankNumber: rankNumber ?? this.rankNumber,
      versionNumber: versionNumber ?? this.versionNumber,
      userBalance: userBalance ?? this.userBalance,
      lastRewardDate: lastRewardDate ?? this.lastRewardDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'firstName': firstName?.trim(),
      'lastName': lastName?.trim(),
      'username': userName?.trim(),
      'userNameLowerCase': userName?.toLowerCase().trim(),
      'phoneNumber': userPhoneNumber?.trim(),
      'email': userEmail?.trim(),
      'userAvatar': userAvatar,
      'isReferred': false,
      'pointsNumber': 0,
      'fcmToken': '',
      'role': 'USER',
      'createdAt':DateTime.now()
    };
  }
}
