import 'package:flutter/material.dart';
import '../Model/results.dart';
import '../Controller/allResult.dart';
import '../Controller/getAllUsers.dart';

class ResultsPage extends StatefulWidget {
  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  List<Results> resultsList = [];
  List<Results> filteredResultsList = []; // Liste filtrée
  Map<String, Map<String, String>> userNames = {};

  String selectedYear = 'Tous';
  String selectedCategory = 'Tous';
  String selectedPrenom = 'Tous';

  @override
  void initState() {
    super.initState();
    getResultsAndName();
  }
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
      resultsList = results;
      filteredResultsList = results; // Initialement, tous les résultats sont affichés
    });
  }

  void applyFilter() {
    setState(() {
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
    // Créer les options de filtrage
    final years = {'Tous', ...resultsList.map((r) => r.date.year.toString())};
    final categories = {'Tous', ...resultsList.map((r) => r.category)};
    final prenoms = {'Tous', ...userNames.values.map((u) => u['prenom'] ?? '')};
    return Scaffold(
      appBar: AppBar(
        title: Text("Tous les Résultats"),
      ),
      body: Column(
        children: [
          // Filtres
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
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
          // Liste de résultats
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

                return ListTile(
                  title: Text(result.category),
                  subtitle: Text(
                    "Candidat: $nom $prenom\n"
                        "Score: ${result.score} - Succès: ${result.success ? "Oui" : "Non"}",
                  ),
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
