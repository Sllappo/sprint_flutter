import 'package:flutter/material.dart';
import '../Model/results.dart';
import '../Controller/allResult.dart';
import '../Controller/getAllUsers.dart';

class ResultsPage extends StatefulWidget {
  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  // je créer deux liste de resultat une avec tous les resultats une qui va etre trier
  List<Results> resultsList = [];
  List<Results> filteredResultsList = [];
  Map<String, Map<String, String>> userNames = {};// + une map avec tous les users

  // pour le dropDown par defaut ca sera a tous
  String selectedYear = 'Tous';
  String selectedCategory = 'Tous';
  String selectedPrenom = 'Tous';

  @override
  void initState() {
    super.initState();
    getResultsAndName();
  }
// je recupére tout les resultats et pareil pour les emails et a partir des emails je recupere les prenoms
  Future<void> getResultsAndName() async {
    var results = await getAllResults();
    var users = await getAllUsers();
    for (var user in users) {
      userNames[user['email']] = {
        'nom': user['nom'],
        'prenom': user['prenom'],
      };
    }
    setState(() {
      resultsList = results; // j'initialise les deux list au resultat pour l'instant
      filteredResultsList = results;
    });
  }

  void applyFilter() {
    setState(() {
      // permet de filtrer la list en fonction de la donnée dans la dropDown
      filteredResultsList = resultsList.where((result) {
        final yearMatch = selectedYear == 'Tous' || result.date.year.toString() == selectedYear;
        final categoryMatch = selectedCategory == 'Tous' || result.category == selectedCategory;
        final prenomMatch = selectedPrenom == 'Tous' || userNames[result.candidateMail]?['prenom'] == selectedPrenom;
        return yearMatch && categoryMatch && prenomMatch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Creer des maps composer de "Tous" et l'entierter des category + User
    final years = {'Tous', ...resultsList.map((result) => result.date.year.toString())};
    final categories = {'Tous', ...resultsList.map((category) => category.category)};
    final prenoms = {'Tous', ...userNames.values.map((user) => user['prenom'] ?? '')};
    return Scaffold(
      appBar: AppBar(
        title: Text("Tous les Résultats"),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // dans les dropDown la valeur par defaut est "Tous" mais change en fonction
              //du choix de l'admin grâce au Onchaned plus bas
              DropdownButton<String>(
                value: selectedYear,
                items: years.map((year) {
                  return DropdownMenuItem(
                    value: year,
                    child: Text(year),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedYear = value!;
                  });
                  applyFilter();
                },
              ),
              DropdownButton<String>(
                value: selectedCategory,
                items: categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                  });
                  applyFilter();
                },
              ),
              DropdownButton<String>(
                value: selectedPrenom,
                items: prenoms.map((prenom) {
                  return DropdownMenuItem(
                    value: prenom,
                    child: Text(prenom),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedPrenom = value!;
                  });
                  applyFilter();
                },
              ),
            ],
          ),
          Expanded(
            child: filteredResultsList.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: filteredResultsList.length,
              itemBuilder: (context, index) {
                final result = filteredResultsList[index];
                final userInfo = userNames[result.candidateMail];
                final nom = userInfo?['nom'] ?? 'Inconnu';
                final prenom = userInfo?['prenom'] ?? '';
                // juste la maniere d'afficher avec titre + sous titre
                return ListTile(
                  title: Text(result.category),
                  subtitle: Text(
                    "Candidat: $nom $prenom\n"
                        "Score: ${result.score} - Succès: ${result.success ? "Oui" : "Non"}",
                  ),
                  //trailing permet de mettre a droite une variate de subtile etc
                  trailing: Text(result.date.toLocal().toString().split(' ')[0]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
