import 'package:intl/intl.dart';

class Rating {
  final String userId;
  final String userName;
  final String providerId;
  final double rating;
  final String comment;
  final String id;
  final String createdAt;

  Rating({
    required this.userId,
    required this.providerId,
    required this.rating,
    required this.comment,
    required this.id,
    required this.userName,
    required this.createdAt,
  });

  String get formattedDate {
    return DateFormat.yMMMd().add_jm().format(DateTime.parse(createdAt));
  }

  factory Rating.fromMap(Map<String, dynamic> map) {
    return Rating(
      userId: map['userId'],
      providerId: map['providerId'],
      rating: map['rating'],
      comment: map['comment'],
      id: map['id'],
      userName: map['userName'],
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'providerId': providerId,
      'rating': rating,
      'comment': comment,
      'id': id,
      'createdAt': createdAt,
      'userName': userName
    };
  }
}
