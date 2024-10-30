class Results {
  final String candidateMail;
  final String category;
  final int score;
  final bool success;
  final DateTime date;

  Results(
      {required this.candidateMail,
      required this.category,
      required this.score,
      required this.success,
      required this.date});

  Map<String, dynamic> toJson() => {
        "candidateMail": candidateMail,
        "category": category,
        "score": score,
        "success": success,
        "date": DateTime.now(),
      };

  factory Results.fromJson(Map<String, dynamic> userResultMap) {
    return Results(
      candidateMail: userResultMap['candidateMail'],
      category: userResultMap['category'],
      score: userResultMap['score'],
      success: userResultMap['success'],
      date: userResultMap['DateTime'],
    );
  }
}
