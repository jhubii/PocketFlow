import 'package:cloud_firestore/cloud_firestore.dart';

class Transactions {
  final String id;
  final String userID;
  final String title;
  final String category;
  final String transactionType;
  final Timestamp transactionDate;
  final Timestamp dateAdded;
  final double amount;

  Transactions({
    required this.id,
    required this.userID,
    required this.title,
    required this.category,
    required this.transactionType,
    required this.transactionDate,
    required this.dateAdded,
    required this.amount,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'category': category,
        'transactionType': transactionType,
        'userID': userID,
        'title': title,
        'transactionDate': transactionDate,
        'dateAdded': dateAdded,
        'amount': amount,
      };

  static Transactions fromJson(Map<String, dynamic> json) => Transactions(
        id: json['id'],
        userID: json['userID'],
        title: json['title'],
        category: json['category'],
        transactionType: json['transactionType'],
        transactionDate: json['transactionDate'],
        dateAdded: json['dateAdded'],
        amount: json['amount'],
      );
}
