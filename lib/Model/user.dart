//import 'dart:ffi';
import 'package:flutter/material.dart';

late String userId ;

class User {
  final String nom;
  final String prenom;
  final String email;
  final int? age;
  final String adresse;
  final String password;
  final String motivation;
  final bool admin;

  User({
    required this.nom,
    required this.prenom,
    required this.email,
    required this.age,
    required this.adresse,
    required this.password,
    required this.motivation,
    required this.admin,
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
    );
  }
}
