import 'package:mongo_dart/mongo_dart.dart';
import '../Model/user.dart';
import '../database.dart';
import '../Model/results.dart';

// fonction récupéré les données de l'utilisateur
Future<User> getUser(String mail) async {
  final db = await connectToDb(); // je me connecte a la base de donnée
  final collection = db.collection(
      'users'); // je récupére les données de la collection de "users"

  // Ajoutez cette ligne pour déboguer

  final userGet = await collection.findOne(where.eq('email', mail));
  print('Utilisateur récupéré : $userGet'); // Vérifiez ce qui est récupéré

  User returnedUser = User.fromJson(userGet!);

  await db.close();

  return returnedUser;
}

Future<List<Results>> getAllUserScores(String candidateMail) async {
  final db = await connectToDb();
  final collection = db.collection('results');

  try {
    // Récupérer tous les résultats pour l'adresse candidateMail spécifiée
    final results = await collection.find(where.eq('candidateMail', candidateMail)).toList();
    print(results);

    // Mapper les résultats vers une liste d'objets Results
    return results.map((result) => Results.fromJson(result)).toList();
  } catch (e) {
    // Gérer les erreurs ici
    print('Erreur lors de la récupération des scores: $e');
    return []; // Retourner une liste vide en cas d'erreur
  }
}
