import 'package:mongo_dart/mongo_dart.dart';
import '../database.dart';

Future<List<Map<String, dynamic>>> getAllQuizz() async {
  var db = await connectToDb(); // je me connecte a la base de donnée
  var collection = db.collection('quizz'); // je me connecte a la collection "users"
  var quizzDocuments = await collection.find().toList(); // je recupere toutes les données de "users"
  print(quizzDocuments);

  return quizzDocuments;
}
