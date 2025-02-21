import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionDto {
  String id;
  String userId;
  double price;
  double points;
  String contactPhoneNumber;
  String ?status;
  DateTime ?createdAt;
  DateTime? approvedAt;

  TransactionDto({
    required this.id,
    required this.userId,
    required this.price,
    required this.points,
    required this.contactPhoneNumber,
    this.status,
    this.createdAt,
    this.approvedAt,
  });

  factory TransactionDto.fromJson(Map<String, dynamic> json) {
    return TransactionDto(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      points: (json['points'] as num?)?.toDouble() ?? 0,
      contactPhoneNumber: json['contactPhoneNumber'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate() // Convert Timestamp to DateTime
          : null,
      approvedAt: json['approvedAt'] != null
          ? (json['approvedAt'] as Timestamp).toDate() // Convert Timestamp to DateTime
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'price': price,
      'points':points,
      'contactPhoneNumber': contactPhoneNumber,
      'status': 'Pending',
      'createdAt':DateTime.now(),
      'approvedAt':null,
    };
  }
}