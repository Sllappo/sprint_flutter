import 'package:mongo_dart/mongo_dart.dart';
import '../Model/user.dart';
import '../database.dart';
// fonction Insert user
Future<void> insertUser(User user) async {
  Db db = await connectToDb(); // je me connecte a la base de donnée
  try {
    var collection = db.collection('users'); // je peux recupéré les données de la collection 'user'
    await collection.insert(user.toJson()); // j'insert mon user en format Json
    print('Utilisateur ajouté avec succès');
  } catch (e) {
    print('Erreur lors de l\'ajout de l\'utilisateur : $e');
  } finally {
    await db.close();
  }
}
