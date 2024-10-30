import 'package:flutter/material.dart';
import 'dart:async';
import '../Model/candidate.dart';
import '../Model/test.dart';
import 'categorySelectionPage.dart';

class QuizPage extends StatefulWidget {
  final String category;
  final Candidat candidat;

  const QuizPage({super.key, required this.category, required this.candidat});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late Test test;
  int currentQuestionIndex = 0;
  int remainingTime = 0;
  Timer? timer;
  bool isAnswerSelected = false;

  @override
  void initState() {
    super.initState();
    final questions = _loadQuestionsByCategory(widget.category);
    test = Test(widget.category, questions);
    _startTimer();
  }

  List<Question> _loadQuestionsByCategory(String category) {
    switch (category) {
      case "HTML":
        return [
          Question("Qu'est-ce que HTML signifie ?", ["Hyper Text Markup Language", "Home Tool Markup Language", "Hyperlinks Text Markup Language", "Hyperlinking Text Marking Language"], 0, 10),
          Question("Quel élément HTML définit un titre de niveau 1 ?", ["<head>", "<title>", "<h1>", "<header>"], 2, 10),
        ];
      case "CSS":
        return [
          Question("Qu'est-ce que CSS signifie ?", ["Cascading Style Sheets", "Creative Style Sheets", "Colorful Style Sheets", "Computer Style Sheets"], 0, 10),
          Question("Quel attribut CSS est utilisé pour changer la couleur du texte ?", ["color", "font-color", "text-color", "background-color"], 0, 10),
        ];
      case "ALGO":
        return [
          Question("Quel est le temps de complexité moyen de la recherche binaire ?", ["O(log n)", "O(n)", "O(n log n)", "O(1)"], 0, 10),
          Question("Qu'est-ce qu'un arbre binaire ?", ["Un type de graphe", "Un arbre avec chaque nœud ayant au plus deux enfants", "Un arbre sans cycles", "Un type de liste"], 1, 10),
        ];
      case "JAVA":
        return [
          Question("Java est-il un langage compilé ou interprété ?", ["Compilé", "Interprété", "Les deux", "Aucun"], 2, 10),
          Question("Quelle est la sortie de System.out.println(2+2); ?", ["3", "4", "22", "Erreur"], 1, 10),
        ];
      default:
        return [];
    }
  }

  void _startTimer() {
    setState(() {
      remainingTime = test.questions[currentQuestionIndex].tempsLimite;
    });

    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        if (remainingTime > 0) {
          remainingTime--;
        } else {
          t.cancel();
          _nextQuestion();
        }
      });
    });
  }

  void _answerQuestion(int selectedIndex) {
    if (isAnswerSelected) return;

    setState(() {
      isAnswerSelected = true;
      if (selectedIndex == test.questions[currentQuestionIndex].bonneReponse) {
        test.score++;
      }
    });

    Future.delayed(const Duration(seconds: 1), _nextQuestion);
  }

  void _nextQuestion() {
    setState(() {
      if (currentQuestionIndex < test.questions.length - 1) {
        currentQuestionIndex++;
        isAnswerSelected = false;
        _startTimer();
      } else {
        _showResults();
      }
    });
  }

  void _showResults() {
    timer?.cancel();
    widget.candidat.ajouterScore(widget.category, test.score);

    bool allCategoriesCompleted = widget.candidat.testsEffectues.length == 4;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Résultats"),
        content: Text(
          "Score final pour ${widget.category}: ${test.score}/${test.questions.length}" +
              (allCategoriesCompleted ? "\nScore général : ${widget.candidat.scores.values.reduce((a, b) => a + b)}" : ""),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => CategorySelectionPage(candidat: widget.candidat)),
              );
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = test.questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(title: const Text("Quiz")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Question ${currentQuestionIndex + 1}: ${question.enonce}",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            for (int i = 0; i < question.options.length; i++)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InkWell(
                  onTap: isAnswerSelected ? null : () => _answerQuestion(i),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: isAnswerSelected
                          ? (i == question.bonneReponse ? Colors.green.shade200 : Colors.red.shade200)
                          : Colors.white,
                    ),
                    child: Center(  // Centrer le contenu de la carte
                      child: Text(
                        question.options[i],
                        style: TextStyle(
                          color: isAnswerSelected && i == question.bonneReponse
                              ? Colors.green
                              : isAnswerSelected && i != question.bonneReponse
                              ? Colors.red
                              : Colors.black,
                        ),
                        textAlign: TextAlign.center,  // Alignement centré
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 20),
            Text("Temps restant: $remainingTime secondes",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: remainingTime / test.questions[currentQuestionIndex].tempsLimite,
              backgroundColor: Colors.grey.shade300,
              color: Colors.teal,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
