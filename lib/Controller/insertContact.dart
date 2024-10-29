import 'package:mongo_dart/mongo_dart.dart';
import '../Model/user.dart';
import '../database.dart';

Future<void> insertUser(User user) async {
  Db db = await connectToDb();
  try {
    var collection = db.collection('users');
    await collection.insert(user.toJson());
    print('Utilisateur ajouté avec succès');
  } catch (e) {
    print('Erreur lors de l\'ajout de l\'utilisateur : $e');
  } finally {
    await db.close();
  }
}
