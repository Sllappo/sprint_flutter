import 'package:mongo_dart/mongo_dart.dart';
import '../Model/quizz.dart';
import '../database.dart';

Future<void> insertQuestion(Quiz quiz) async{
  //Fonction pour insérer une question
  Db db = await connectToDb();
  try{
    var collection = db.collection('quizz');
    await collection.insert(quiz.toJson());//Insertion de la question
    print("Question insérée avec succès");
  }catch(e){
    print('Erreur lors de l\'ajout de la question : $e');

  }
}

Future<void> deleteQuestion(Quiz quiz) async{
  //Fonction pour supprimer une question
  Db db = await connectToDb();
  var question = quiz.questions;
  try{
    var collection = db.collection('quizz');
    var quizDocument = await collection.findOne({//Je recupere un document JSON sous le format Map<String, dynamic>
      "questions": {
        "\$elemMatch": {//methode pour récupérer le document avec un champs spécifique de l'objet
          "text": question[0].text
        }
      }
    });
    ObjectId quizId = quizDocument?['_id'] as ObjectId;//On récupère l'id du quizz à supprimer
    collection.deleteOne({'_id': quizId});//On supprime le quizz voulu
    print("Question supprimée avec succès");
  }catch(e){
    print('Erreur lors de la suppression de la question : $e');

  }
}