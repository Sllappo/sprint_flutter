import 'dart:ffi';
import 'package:flutter/material.dart';

class User {
  final String nom;
  final String prenom;
  final String email;
  final int? age;
  final String adresse;
  final String password;
  final String motivation;
  final bool admin;
  final Map<String, dynamic> score;
  final String java;
  final String css;
  final String html;
  final String algo;

  User({
    required this.nom,
    required this.prenom,
    required this.email,
    required this.age,
    required this.adresse,
    required this.password,
    required this.motivation,
    required this.admin,
    required this.score,
    required this.java,
    required this.css,
    required this.html,
    required this.algo,
  });
  Map<String, dynamic> toJson() => {
        "nom": nom,
        "prenom": prenom,
        "email": email,
        "age": age,
        "adresse": adresse,
        "password": password,
        "motivation": motivation,
        "admin": false,
        "score": {
          "java": "0",
          "algo": "0",
          "html": "0",
          "css": "0",
        },
      };

  factory User.fromJson(Map<String, dynamic> userMap) {
    return User(
      nom: userMap['nom'],
      prenom: userMap['prenom'],
      email: userMap['email'],
      age: userMap['age'],
      adresse: userMap['adresse'],
      password: userMap['password'],
      motivation: userMap['motivation'],
      admin: userMap['admin'],
      score: Map<String, dynamic>.from(userMap['score']),
      java: userMap['score']['java'] ?? '0',
      css: userMap['score']['css'] ?? '0',
      html: userMap['score']['html'] ?? '0',
      algo: userMap['score']['algo'] ?? '0',
    );
  }
}
