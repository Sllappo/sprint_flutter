import 'package:mongo_dart/mongo_dart.dart';
import '../Model/quizz.dart';
import '../database.dart';

Future<void> insertQuestion(Quiz quiz) async{
  Db db = await connectToDb();
  try{
    var collection = db.collection('quizz');
    await collection.insert(quiz.toJson());
    print("Question insérée avec succès");
  }catch(e){
    print('Erreur lors de l\'ajout de la question : $e');

  }
}