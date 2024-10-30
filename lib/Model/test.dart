import 'candidate.dart';

class Test {
  final String id;  // Identifiant unique pour chaque test (peut-être généré automatiquement)
  final String discipline;
  final List<Question> questions;
  int score = 0;

  Test(this.discipline, this.questions, {String? id})
      : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();
}
