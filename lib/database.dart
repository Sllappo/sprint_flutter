import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<Db> connectToDb() async {
  var password = 'root';
  var encryptedPassword = Uri.encodeComponent(password);

  var db = await Db.create('mongodb+srv://sllappo:$encryptedPassword@flutter.4y7dj.mongodb.net/sprintFlutter?retryWrites=true&w=majority&appName=flutter');
  try {
    await db.open();
    print('Connexion établie');
  }catch(e){
    print('Connexion error $e');
  }
  return db;
}