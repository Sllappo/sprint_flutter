import 'dart:ffi';
import 'package:flutter/material.dart';

class User {
  final String nom;
  final String prenom;
  final String email ;
  final int? age;
  final String adresse;
  final String password;
  final String motivation;
  final bool admin;
  final List<Map<String, dynamic>> score;
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
    "nom":nom,
    "prenom":prenom,
    "email":email,
    "age":age,
    "adresse":adresse,
    "password":password,
    "motivation":motivation,
    "admin": false,
    "score": [{
      "java": "0",
      "algo": "0",
      "html": "0",
      "css": "0",
    }],
  };
}

