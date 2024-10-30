// lib/View/FormLogin.dart
import 'package:flutter/material.dart';
import 'package:sprint_flutter/Controller/getUser.dart';
import '../Controller/loginVerification.dart';
import '../Model/user.dart';

class FormLogin extends StatefulWidget {
  const FormLogin({super.key});

  @override
  State<FormLogin> createState() => _FormLoginState();
}

class _FormLoginState extends State<FormLogin> {
  final _formKey = GlobalKey<FormState>();

  // Variable des données des inputs
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Soumission du formulaire
  void _submitLogin() async {
    print('Début de la fonction');

    //if (_formKey.currentState!.validate()) {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    print('On continue');

    // on appel la fonction LoginUser qui renvoie Faux ou True si c'est True ça veut dire que le User existe
    bool isLoggedIn = await loginUser(email, password);

    print("Le user existe ? " + isLoggedIn.toString());

    if (isLoggedIn) {
      print('Connexion réussie pour $email');
      final User currentUser = await getUser(email);
      userId = currentUser.email;
      print(userId);
      if (currentUser.admin){
        Navigator.pushReplacementNamed(context, '/admin'); // Redirige vers la page admin
      } else {
        Navigator.pushReplacementNamed(context, '/form/profil'); // Redirige vers la page profil
      }
    } else {
      print('Email ou mot de passe incorrect');
    }
    //}
  }
  // Le form
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connexion'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Mot de passe',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre mot de passe';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitLogin,
                child: const Text('Se connecter'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/form/register');
                },
                child: const Text(
                  "Pas de compte ? Va t'en créer un !",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
