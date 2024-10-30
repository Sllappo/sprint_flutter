import 'package:flutter/material.dart';
import '../Model/results.dart';
import '../Controller/allResult.dart';
import '../Controller/getAllUsers.dart';

class ResultsPage extends StatefulWidget {
  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  // on créer les variables pour la list de resultats et des noms et prenoms
  List<Results> resultsList = [];
  Map<String, Map<String, String>> userNames = {};

  @override
  void initState() {
    super.initState();
    getResultsAndName();
  }

  // la fonction recuperer tout les resultat avec getAllresult
  // elle recupere aussi tout les Users et elle recupere chaque nom et prenom de chaque User
  Future<void> getResultsAndName() async {
    var results = await getAllResults();

    var users = await getAllUsers();
    for (var user in users) {
      userNames[user['email']] = {
        'nom': user['nom'],
        'prenom': user['prenom'],
      };
    }
    // je mets a jouer la liste avec tous les results
    setState(() {
      resultsList = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tous les Résultats"),
      ),
      body: resultsList.isEmpty // si vide rond qui tourne sinon regarde combien d'element et affiche
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: resultsList.length,
        itemBuilder: (context, index) {
          final result = resultsList[index];
          final userInfo = userNames[result.candidateMail];
          final nom = userInfo?['nom'] ?? 'Inconnu'; // je peux afficher nom et prenom grace a ma variable qui a tout recuperer avant
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
    );
  }
}
