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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCompletedCategories();
  }

  Future<void> _loadCompletedCategories() async {
    // Charge les tests déjà complétés depuis la BDD
    await widget.candidat.chargerTestsEffectues();

    // Met à jour l'état pour reconstruire l'interface avec les données chargées
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      // Affiche un indicateur de chargement pendant le chargement des catégories
      return Scaffold(
        appBar: AppBar(
          title: const Text("Sélection de catégorie"),
          backgroundColor: Colors.teal,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sélection de catégorie"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 1.2,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            String category = categories[index];
            bool isCompleted = !widget.candidat.peutPasserTest(category);

            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: InkWell(
                onTap: isCompleted
                    ? null
                    : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizPage(
                        category: category,
                        candidat: widget.candidat,
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: isCompleted ? Colors.grey.shade300 : Colors.teal.shade100,
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.quiz,
                        size: 40,
                        color: isCompleted ? Colors.grey : Colors.teal,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        category,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isCompleted ? Colors.grey : Colors.teal,
                        ),
                      ),
                      if (isCompleted)
                        const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            "Déjà complété",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
