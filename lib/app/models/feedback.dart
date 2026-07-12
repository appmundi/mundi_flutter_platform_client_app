class Feedback {
  final int? id;
  final String userName;
  final int? userId;
  final int? entrepreneurId;
  final int? scheduleId;
  final double rating;
  final String comment;

  const Feedback({
    this.id,
    required this.userName,
    required this.userId,
    required this.entrepreneurId,
    required this.scheduleId,
    required this.rating,
    required this.comment,
  });

  factory Feedback.fromMap(Map<String, dynamic> map) {
    return Feedback(
      id: (map['id'] as num?)?.toInt(),
      entrepreneurId: (map['entrepreneurId'] as num?)?.toInt(),
      userName: map['name']?.toString() ?? '',
      userId: (map['userId'] as num?)?.toInt(),
      scheduleId: (map['scheduleId'] as num?)?.toInt(),
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      comment: map['comment']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': userName,
      'userId': userId,
      'entrepreneurId': entrepreneurId,
      'scheduleId': scheduleId,
      'rating': rating,
      'comment': comment,
    };
  }
}
