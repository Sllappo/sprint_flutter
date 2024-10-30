import 'package:mongo_dart/mongo_dart.dart';
import '../database.dart';

Future<List<Map<String, dynamic>>> getAllUsers() async { // fonction get allUser
  var db = await connectToDb(); // je me connecte a la base de donnée
  var collection = db.collection('users'); // je me connecte a la collection "users"
  var userDocuments = await collection.find().toList(); // je recupere toutes les données de "users"

  return userDocuments;
}
