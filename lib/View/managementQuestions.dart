import 'package:sprint_flutter/Controller/getAllQuizz.dart';
import 'package:flutter/material.dart';
import 'package:sprint_flutter/Model/quizz.dart';
import '../Controller/createNewQuestion.dart';

// Fonction pour récupérer les quizz dans la table quiz
Future<List<Quiz>> fetchQuizz() async {
  List<Map<String, dynamic>> quizzListJson = await getAllQuizz();
  List<Quiz> quizList = quizzListJson.map((json) => Quiz.fromJson(json)).toList();
  print(quizList);
  return quizList;
}


class ManagementQuestions extends StatefulWidget {
  const ManagementQuestions({super.key});

  @override
  _ManagementQuestionsState createState() => _ManagementQuestionsState();
}


class _ManagementQuestionsState extends State<ManagementQuestions> {
  String selectedCategory = "HTML"; // Stocker la catégorie de question à afficher (HTML par défaut)

  void updateCategory(String category) { // State pour mettre à jour la catégorie à afficher
    setState(() {
      selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) { // Contenue de la page
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestions des questions'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(onPressed: ()=>{showFormCreateQuestion(context)}, icon: Icon(Icons.add))
        ],
      ),
      
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            NavBar(selectedCategory, updateCategory), // Barre de navigation
            Expanded(child: QuizCard(selectedCategory: selectedCategory)), // Liste des questions sous forme de Card
          ],
        ),
      ),
    );
  }
}

// Barre de navigation
Widget NavBar(String selectedCategory, Function(String) updateCategory) {
  // Tableau d'objet
  final List<String> categories = [
    'HTML', 'CSS', 'JAVA', 'ALGO'
  ];

  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: categories.map((category) { // Boucle sur les categories
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
        child: ElevatedButton(
          onPressed: () => updateCategory(category), // Changer la categorie selectionner
          child: Text(category),
          style: ElevatedButton.styleFrom(
            backgroundColor: selectedCategory == category ? Colors.blueAccent : null, // Background de couleur pour la catégorie selectionnée
          ),
        ),
      );
    }).toList(),
  );
}

// Card qui affiche une question et ses réponses
class QuizCard extends StatelessWidget {
  final String selectedCategory; // catégorie selectionnée

  const QuizCard({required this.selectedCategory});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Quiz>>( // Attendre le fetch puis afficher
      future: fetchQuizz(), // Récupérer les questions
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) { // En attendant la requête
          return const Center(child: CircularProgressIndicator()); // icône de chargement
        } else if (snapshot.hasError) { // Si erreur
          print("Erreur dans FutureBuilder: ${snapshot.error}");
          return const Center(child: Text('Erreur lors du chargement du quiz')); // Si erreur
        } else if (snapshot.hasData) {
          // Filtrer les questions selon la catégorie selectionné
          final filteredQuizzes = snapshot.data!
              .where((quiz) => quiz.category == selectedCategory)
              .toList();

          return ListView(
            children: filteredQuizzes.map((item) { // Boucle sur toutes les questions filtrées
              return Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...item.questions.map((question) { // Boucle sur les questions de la catégorie
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text( // Affiche la question
                              question.text,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            ...question.choices.asMap().entries.map((entry) { // Boucle sur les choix possible
                              final int index = entry.key;
                              final String choice = entry.value;

                              // Style en vert si l'index fait partie des réponses
                              final TextStyle choiceStyle = question.answer.contains(index)
                                  ? const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)
                                  : const TextStyle(color: Colors.black);

                              return Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  '- $choice',
                                  style: choiceStyle,
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              );
            }).toList(),
          );
        } else {
          return const Center(child: Text('Aucun quiz disponible'));
        }
      },
    );
  }
}