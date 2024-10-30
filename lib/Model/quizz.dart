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
    return Quiz(
      category: json["category"],
      questions: List<Question>.from(
        json["questions"].map((q) => Question(
          text: q["text"] ?? "",
          choices: List<String>.from(q["choices"] ?? []),
          answer: q["answer"] ?? "",
        )),
      ),
    );
  }

}

class Question {
  String text;
  List<String> choices;
  String answer;

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
}


