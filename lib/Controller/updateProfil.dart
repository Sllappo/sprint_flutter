import 'package:mongo_dart/mongo_dart.dart';
import '../Model/user.dart';
import '../database.dart';

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
