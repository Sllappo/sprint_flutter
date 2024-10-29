import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
void main( ){
  print("bonjour");
Future<void> connectToDb() async {
  //String? connectionString = dotenv.env['DATABASE_STRING'];
  //var db = mdb.Db(connectionString!);
  var password = 'root';
  var encryptedPassword = Uri.encodeComponent(password);

  var db = await Db.create('mongodb+srv://sllappo:$encryptedPassword@flutter.4y7dj.mongodb.net/?retryWrites=true&w=majority&appName=flutter');
  try {
    await db.open();
    print('Connexion établie');
  } catch (e) {
    print('Erreur lors de la connexion : $e');
  }
}

connectToDb();
}