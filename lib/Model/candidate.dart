import 'package:mongo_dart/mongo_dart.dart';
import '../database.dart';

class Candidat {
  final String nom;
  final Map<String, int> scores = {};
  final Set<String> testsEffectues = {};

  Candidat(this.nom);

  bool peutPasserTest(String discipline) => !testsEffectues.contains(discipline);

  Future<void> ajouterScore(String discipline, int score) async {
    scores[discipline] = score;
    testsEffectues.add(discipline);

    final db = await connectToDb();
    final resultsCollection = db.collection('results');

    bool success = score >= 2;

    try {
      await resultsCollection.insertOne({
        'candidateMail': nom,
        'category': discipline,
        'score': score,
        'success': success,
        'date': DateTime.now().toIso8601String(),
      });
      print('Score enregistré dans la base de données');
    } catch (e) {
      print('Erreur lors de l\'insertion dans la BDD: $e');
    } finally {
      await db.close();
    }
  }
}

class Question {
  final String enonce;
  final List<String> options;
  final int bonneReponse;
  final int tempsLimite;

  Question(this.enonce, this.options, this.bonneReponse, this.tempsLimite);
}