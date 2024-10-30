import 'package:mongo_dart/mongo_dart.dart';
import '../Model/user.dart';
import '../database.dart';

// Récupérer les utilisateurs
Future<List<User>> getUsers() async {
  final db = await connectToDb(); // Connexion à la Bdd
  final usersCollection = db.collection('users'); // Récupérer les données de la collection "users"

  // Récupérer tous les utilisateurs
  final usersData = await usersCollection.find().toList();

  // Convertir les documents en objets User
  List<User> users = usersData.map((userJson) {
    return User(
      nom: userJson['nom'],
      prenom: userJson['prenom'],
      email: userJson['email'],
      age: userJson['age'],
      adresse: userJson['adresse'],
      password: userJson['password'],
      motivation: userJson['motivation'],
      admin: userJson['admin'],
    );
  }).toList();

  await db.close(); // Fermer la connexion à la Bdd
  return users; // Retourner la liste des utilisateurs
}