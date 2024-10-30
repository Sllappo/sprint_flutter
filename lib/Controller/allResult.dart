import 'package:mongo_dart/mongo_dart.dart';
import '../Model/results.dart';
import '../database.dart';

Future<List<Results>> getAllResults() async {
  var db = await connectToDb(); // je me connecte a la base de donné

    var collection = db.collection('results');

    var resultDocuments = await collection.find().toList(); // je recupere tous les données de results et je les mets dans une liste

    List<Results> resultsList = resultDocuments.map((doc) {
      return Results( // le return me permet de les afficher plus tard
        candidateMail: doc['candidateMail'],
        category: doc['category'],
        score: doc['score'],
        success: doc['success'],
        date: DateTime.parse(doc['date']),
      );
    }).toList();

    return resultsList;
}
