import 'package:mongo_dart/mongo_dart.dart';
import '../Model/user.dart';
import '../database.dart';

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