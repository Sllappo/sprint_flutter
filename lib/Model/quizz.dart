import 'package:flutter/material.dart';

class Quiz {
  String category;
  List<Question> questions;

  Quiz({required this.questions, required this.category});

  Map<String, dynamic> toJson() {
    return {
      "category": category,
      "questions": questions.map((q) => q.toJson()).toList(),
    };
  }

  factory Quiz.fromJson(Map<String, dynamic> json) {
    // Vérifiez que les clés existent et sont du bon type
    if (!json.containsKey('category') || !(json['category'] is String)) {
      throw FormatException("Invalid or missing 'category'");
    }

    if (!json.containsKey('questions') || !(json['questions'] is List)) {
      throw FormatException("Invalid or missing 'questions'");
    }

    return Quiz(
      category: json["category"] ?? "",
      questions: List<Question>.from(
          (json["questions"] as List).map((q) {
            if (!(q is Map<String, dynamic>)) {
              throw FormatException("Invalid question format");
            }
            return Question.fromJson(q); // Appel à la méthode fromJson pour Question
          })),
    );
  }
}

class Question {
  String text;
  List<String> choices;
  List<int> answer; // Maintenant un tableau d'entiers

  Question({
    required this.text,
    required this.choices,
    required this.answer,
  });

  Map<String, dynamic> toJson() {
    return {
      "text": text,
      "choices": choices,
      "answer": answer,
    };
  }

  factory Question.fromJson(Map<String, dynamic> json) {
    // Vérifiez que les clés existent et sont du bon type
    if (!json.containsKey('text') || !(json['text'] is String)) {
      throw FormatException("Invalid or missing 'text'");
    }

    if (!json.containsKey('choices') || !(json['choices'] is List)) {
      throw FormatException("Invalid or missing 'choices'");
    }

    if (!json.containsKey('answer') || !(json['answer'] is List)) {
      throw FormatException("Invalid or missing 'answer'");
    }

    return Question(
      text: json["text"] ?? "",
      choices: List<String>.from(
          (json["choices"] as List).map((choice) {
            if (choice is String) {
              return choice;
            } else {
              return choice.toString(); // Convertir en String si nécessaire
            }
          })),
      answer: List<int>.from(
          (json["answer"] as List).map((a) {
            if (a is int) {
              return a;
            } else {
              throw FormatException("Invalid answer format"); // Gérer les erreurs de type
            }
          })),
    );
  }
}
