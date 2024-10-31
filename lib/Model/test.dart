import 'candidate.dart';

class Test {
  final String id;  // Id unique pour chaque test
  final String discipline;
  final List<Question> questions;
  int score = 0;

  Test(this.discipline, this.questions, {String? id})
      : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();
}