import 'package:flutter/material.dart';
import '../Model/quizz.dart';
import '../Controller/questionController.dart';

void showFormCreateQuestion(BuildContext context) {
  final formKey = GlobalKey<FormState>();
  final TextEditingController questionController = TextEditingController();
  final TextEditingController answer1Controller = TextEditingController();
  final TextEditingController answer2Controller = TextEditingController();
  final TextEditingController answer3Controller = TextEditingController();
  final TextEditingController answer4Controller = TextEditingController();
  String? category;

  final List<String> categories = [
    'HTML',
    'CSS',
    'ALGO',
    'JAVA'
  ];

  // Variables d'état pour chaque Checkbox
  bool isAnswer1Correct = false;
  bool isAnswer2Correct = false;
  bool isAnswer3Correct = false;
  bool isAnswer4Correct = false;

  void submitQuestion() async{
    //Fonctions pour soumettre la création de question
    if (formKey.currentState!.validate()) {
      //Après vérification de la validité du formulaire on récupère les valeur de ce dernier
      String question = questionController.text;
      List<int> answers = [];
      List<String> choices = [
        answer1Controller.text,
        answer2Controller.text,
        answer3Controller.text,
        answer4Controller.text
      ];
      if (isAnswer1Correct) {
        answers.add(0);
      }
      if (isAnswer2Correct) {
        answers.add(1);
      }
      if (isAnswer3Correct) {
        answers.add(2);
      }
      if (isAnswer4Correct) {
        answers.add(3);
      }
      List<Question> newQuestion = [];
      newQuestion.add(Question(text: question, choices: choices, answer: answers));
      //On transforme tout ces valeurs en un objet Quiz que l'on pourra envoyer en bdd
      Quiz newQuiz = Quiz(questions: newQuestion, category: category!);

      try {
        //on insère la question
        insertQuestion(newQuiz);
        print('Inscription réussie pour $category');
      } catch (e) {
        print(e);
      }
    }
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Ajouter une nouvelle question'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  value: category,
                  onChanged: (String? newValue) {
                    category = newValue;
                  },
                  items: categories.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez sélectionner une motivation';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: questionController,
                  decoration: const InputDecoration(
                    labelText: 'Question',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer la question!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: answer1Controller,
                        decoration: const InputDecoration(
                          labelText: 'Réponse 1',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer la question!';
                          }
                          return null;
                        },
                      ),
                    ),
                    Checkbox(
                      value: isAnswer1Correct,
                      onChanged: (bool? value) {
                        if(isAnswer1Correct){
                          isAnswer1Correct = false;
                        }else{
                          isAnswer1Correct=true;
                        }                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: answer2Controller,
                        decoration: const InputDecoration(
                          labelText: 'Réponse 2',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer la question!';
                          }
                          return null;
                        },
                      ),
                    ),
                    Checkbox(
                      value: isAnswer2Correct,
                      onChanged: (bool? value) {
                        if(isAnswer2Correct){
                          isAnswer2Correct = false;
                        }else{
                          isAnswer2Correct=true;
                        }                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: answer3Controller,
                        decoration: const InputDecoration(
                          labelText: 'Réponse 3',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer la question!';
                          }
                          return null;
                        },
                      ),
                    ),
                    Checkbox(
                      value: isAnswer3Correct,
                      onChanged: (bool? value) {
                        if(isAnswer3Correct){
                          isAnswer3Correct = false;
                        }else{
                          isAnswer3Correct=true;
                        }                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: answer4Controller,
                        decoration: const InputDecoration(
                          labelText: 'Réponse 4',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer la question!';
                          }
                          return null;
                        },
                      ),
                    ),
                    Checkbox(
                      value: isAnswer4Correct,
                      onChanged: (bool? value) {
                        if(isAnswer4Correct){
                          isAnswer4Correct = false;
                        }else{
                          isAnswer4Correct=true;
                        }
                      },
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    submitQuestion();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Enregistrer'),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}


