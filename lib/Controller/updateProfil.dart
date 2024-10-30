import 'package:mongo_dart/mongo_dart.dart';
import '../Model/user.dart';
import '../database.dart';
import '../Controller/getUser.dart';
import '../Model/user.dart';

// fonction récupéré les données de l'utilisateur
Future<void> updateUser(String adress, String newAdresse) async {
  final db = await connectToDb(); // je me connecte a la base de donnée
  final collection = db.collection(
      'users'); // je récupére les données de la collection de "users"

//met à jour l'adresse d'un utilisateur.
  await collection.updateOne(
      where.eq('adresse', adress), modify.set('adresse', newAdresse));

  await db.close();
}

Future<void> updateUserMotivation(String newMotivation) async {
  final db = await connectToDb(); // Connexion à la base de données
  final collection = db.collection('users');

  String userMail = userId; // Remplacez par l'email de l'utilisateur connecté

  try {
    await collection.updateOne(
      where.eq('email', userMail),
      modify.set('motivation', newMotivation),
    );

    // Affichez le résultat de l'opération
  } catch (e) {
    print('Erreur lors de la mise à jour de la motivation : $e');
  } finally {
    await db.close();
  }
}
