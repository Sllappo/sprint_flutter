import 'package:flutter/material.dart';
import 'dart:async';
import '../Model/candidate.dart';
import '../Model/test.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final candidat = Candidat("Candidat");
  final discipline = "Java";
  late Test test;
  int currentQuestionIndex = 0;
  int remainingTime = 0;
  Timer? timer;
  bool isAnswerSelected = false;

  @override
  void initState() {
    super.initState();
    final questions = [
      Question("test ?", ["test", "bonne reponse", "test", "test"], 1, 5),
      Question("test2 ?", ["test", "test", "bonne reponse", "test"], 2, 5),
    ];
    test = Test(discipline, questions);
    _startTimer();
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
    candidat.ajouterScore(discipline, test.score);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Résultats"),
        content: Text("Score final pour $discipline: ${test.score}/${test.questions.length}"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
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
            Text("Question ${currentQuestionIndex + 1}: ${question.enonce}"),
            const SizedBox(height: 10),
            for (int i = 0; i < question.options.length; i++)
              ListTile(
                title: Text(question.options[i]),
                onTap: () => _answerQuestion(i),
              ),
            const SizedBox(height: 20),
            Text("Temps restant: $remainingTime seconds"),
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
