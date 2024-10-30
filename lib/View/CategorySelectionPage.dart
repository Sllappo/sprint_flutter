import 'package:flutter/material.dart';
import '../Model/candidate.dart';
import 'quiz_page.dart';

class CategorySelectionPage extends StatefulWidget {
  final Candidat candidat;

  const CategorySelectionPage({Key? key, required this.candidat}) : super(key: key);

  @override
  _CategorySelectionPageState createState() => _CategorySelectionPageState();
}

class _CategorySelectionPageState extends State<CategorySelectionPage> {
  final List<String> categories = ["HTML", "CSS", "ALGO", "JAVA"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sélection de catégorie")),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          String category = categories[index];
          bool isCompleted = !widget.candidat.peutPasserTest(category);

          return ListTile(
            title: Text(category),
            trailing: isCompleted ? const Icon(Icons.lock, color: Colors.grey) : null,
            enabled: !isCompleted,
            onTap: isCompleted
                ? null
                : () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizPage(
                    category: category,
                    candidat: widget.candidat, // Passer le candidat ici
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
