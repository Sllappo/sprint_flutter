import 'package:mongo_dart/mongo_dart.dart';
import '../database.dart';
import '../Model/user.dart';

class Candidat {
  final String nom;
  String? userId; // Make userId nullable
  final Map<String, int> scores = {};
  final Set<String> testsEffectues = {};

  Candidat(this.nom, [this.userId]);

  /// Initialise les tests déjà effectués depuis la BDD
  Future<void> chargerTestsEffectues() async {
    final db = await connectToDb();
    final resultsCollection = db.collection('results');

    try {
      final tests = await resultsCollection
          .find(where.eq('candidateMail', userId))
          .toList();

      for (var test in tests) {
        testsEffectues.add(test['category']);
      }
    } catch (e) {
      print('Erreur lors de la récupération des tests effectués: $e');
    } finally {
      await db.close();
    }
  }

  bool peutPasserTest(String discipline) => !testsEffectues.contains(discipline);

  /// Ajoute le score pour une discipline et enregistre dans la BDD
  Future<void> ajouterScore(String discipline, int score) async {
    scores[discipline] = score;
    testsEffectues.add(discipline);

    final db = await connectToDb();
    final resultsCollection = db.collection('results');

    bool success = score >= 2;

    try {
      await resultsCollection.insertOne({
        'candidateMail': userId,
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
