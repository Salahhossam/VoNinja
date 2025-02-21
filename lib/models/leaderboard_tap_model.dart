class LeaderboardTap {
  final String? username;
  final String? userAvatar;
  final double? points;
  final double? rank;
  final String? id;

  LeaderboardTap(
      {required this.rank,
      required this.username,
      required this.userAvatar,
      required this.points,
      required this.id});

  // Factory method to create an object from JSON
  factory LeaderboardTap.fromJson(Map<String, dynamic> json) {
    return LeaderboardTap(
      id: json['userId'] as String? ?? '',
      username: json['username'] as String? ?? '',
      userAvatar: json['userAvatar'] as String? ?? '',
      points: (json['pointsNumber'] as num?)?.toDouble() ?? 0,
      rank: (json['rank'] as num?)?.toDouble() ?? 0,
    );
  }

  // Method to convert an object to JSON
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'userAvatar': userAvatar,
      'points': points,
      'rank': rank,
    };
  }
}
