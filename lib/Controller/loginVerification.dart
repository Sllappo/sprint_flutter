import 'package:mongo_dart/mongo_dart.dart';
import '../database.dart';

// fonction Login User
Future<bool> loginUser(String email, String password) async {
  final db = await connectToDb();  // lance la Bdd grace a la fonction connectTodb
  final collection = db.collection('users');  // recupére toute les infos de Users

  final user = await collection.findOne({
    'email': email,
    'password': password,
  }); // compare si un User a le meme Email ET le meme password qu'on a donner dans la fonction

  await db.close();
  return user != null;
}
