import 'package:sprint_flutter/Controller/getAllQuizz.dart';
import 'package:flutter/material.dart';
import 'package:sprint_flutter/Model/quizz.dart';

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
  String selectedCategory = "HTML";

  void updateCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin - Gestions des questions'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            NavBar(selectedCategory, updateCategory),
            Expanded(child: QuizCard(selectedCategory: selectedCategory)),
          ],
        ),
      ),
    );
  }
}

Widget NavBar(String selectedCategory, Function(String) updateCategory) {
  final List<Map<String, dynamic>> buttons = [
    {'label': 'HTML', 'value': 'HTML'},
    {'label': 'CSS', 'value': 'CSS'},
    {'label': 'Java', 'value': 'Java'},
    {'label': 'Algo', 'value': 'Algo'},
  ];

  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: buttons.map((button) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
        child: ElevatedButton(
          onPressed: () => updateCategory(button['value']),
          child: Text(button['label']),
          style: ElevatedButton.styleFrom(
            backgroundColor: selectedCategory == button['value'] ? Colors.blueAccent : null,
          ),
        ),
      );
    }).toList(),
  );
}

// Widget QuizCard
class QuizCard extends StatelessWidget {
  final String selectedCategory;

  const QuizCard({required this.selectedCategory});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Quiz>>(
      future: fetchQuizz(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print("Erreur dans FutureBuilder: ${snapshot.error}");
          return const Center(child: Text('Erreur lors du chargement du quiz'));
        } else if (snapshot.hasData) {
          // Filtrer les quizzes en fonction de la catégorie sélectionnée
          final filteredQuizzes = snapshot.data!
              .where((quiz) => quiz.category == selectedCategory)
              .toList();

          return ListView(
            children: filteredQuizzes.map((item) {
              return Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        item.category,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ...item.questions.map((question) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              question.text,
                              style: const TextStyle(fontSize: 18),
                            ),
                            // Affichage des choix avec style conditionnel
                            ...question.choices.asMap().entries.map((entry) {
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