import 'package:mongo_dart/mongo_dart.dart';
import '../Model/user.dart';
import '../database.dart';

// Fonction pour vérifier si l'email est déjà utilisé
Future<bool> isEmailAvailable(String email) async {
  final db = await connectToDb(); // je me connecte a la base de donnée
  final collection = db.collection('users'); // je récupére les données de la collection de "users"

  final user = await collection.findOne(where.eq('email', email)); // je fais une verification des mails avec l'email test
  await db.close();
  return user == null;
}
