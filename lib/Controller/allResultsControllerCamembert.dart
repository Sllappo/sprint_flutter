import '../Model/results.dart';
import '../database.dart';

Future<Map<String, Map<int, Map<String, double>>>> getCategorySuccessRate() async {
  // Je me connecte à la base de données et je récupère tout ce qu'il y a dans results
  var db = await connectToDb();
  var collection = db.collection('results');
  var resultDocuments = await collection.find().toList();

  // Je crée des maps pour stocker les succès et les totaux par catégorie et par année
  Map<String, Map<int, int>> successCount = {};
  Map<String, Map<int, int>> totalCount = {};

  // Je parcours les données récupérées
  for (var doc in resultDocuments) {
    String category = doc['category'];
    bool success = doc['success'];
    // je recupère l'année en string et je la reconvertie
    String dateString = doc['date'];
    DateTime date = DateTime.parse(dateString);
    int year = date.year;

    //  je verifie si la category est deja presente
    if (!successCount.containsKey(category)) {
      successCount[category] = {};
      totalCount[category] = {};
    }
    // je verifie si la category et l'année est deja presente
    if (!successCount[category]!.containsKey(year)) {
      successCount[category]![year] = 0;
      totalCount[category]![year] = 0;
    }

    // si le bool est true ca veut dire qu'il a reussi donc + 1
    if (success) {
      successCount[category]![year] = successCount[category]![year]! + 1;
    }
    // dans tous les cas ca rajoute un count au total
    totalCount[category]![year] = totalCount[category]![year]! + 1;
  }

  // Création d'une nouvelle map pour stocker les pourcentages de réussite et d'échec
  Map<String, Map<int, Map<String, double>>> successRates = {};

  // Pour chaque catégorie, on calcule les taux de réussite et d'échec par année
  for (var category in totalCount.keys) {
    successRates[category] = {};
    for (var year in totalCount[category]!.keys) {
      int total = totalCount[category]![year]!;
      int successes = successCount[category]![year]!;

      // Calcul des pourcentages
      double successRate = (total > 0) ? (successes / total) * 100 : 0;
      double failureRate = (total > 0) ? ((total - successes) / total) * 100 : 0;

      successRates[category]![year] = {
        'successRate': successRate,
        'failureRate': failureRate,
      };
    }
  }

  return successRates;
}
