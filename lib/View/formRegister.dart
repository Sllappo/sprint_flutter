import 'package:flutter/material.dart';
import '../Controller/insertContact.dart';
import '../Controller/emailVerification.dart';
import '../Model/user.dart';

class FormRegister extends StatefulWidget {
  const FormRegister({super.key});

  @override
  State<FormRegister> createState() => _FormRegisterState();
}

class _FormRegisterState extends State<FormRegister> {
  final _formKey = GlobalKey<FormState>();

  // variable qui prend en compte les infos des inputs du form
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _adresseController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // list pour le menu deroulant
  String? _motivation;
  final List<String> _motivations = [
    'Poursuite d’étude',
    'Reconversion pro',
    'Réorientation'
  ];

  // Fonction qui soumet le formulaire
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final String email = _emailController.text;

      // Vérifiez si l'email deja existant
      bool emailAvailable = await isEmailAvailable(email);
      if (!emailAvailable) {
        print('Cet email est déjà utilisé. Veuillez en choisir un autre.');
        return;
      }

      // variable dans tous les input
      final String nom = _nomController.text;
      final String prenom = _prenomController.text;
      final int? age = int.tryParse(_ageController.text);
      final String adresse = _adresseController.text;
      final String password = _passwordController.text;
      final String? motivation = _motivation;

      // create new user a partir de la fonction et de la class
      User newUser = User(
        nom: nom,
        prenom: prenom,
        email: email,
        age: age,
        adresse: adresse,
        password: password,
        motivation: motivation ?? '',
        admin: false,
      );

      try {
        insertUser(newUser);
        print('Inscription réussie pour $nom avec la motivation $_motivation');
        Navigator.pushReplacementNamed(context, '/form/profil'); // redirige page profil si il le try marche
      } catch (e) {
        print(e);
      }
    } else {
      print('Veuillez remplir tous les champs');
    }
  }


  // Regex pour validation email et mot de passe
  final RegExp emailRegex = RegExp(r".+@.+");
  final RegExp passwordRegex = RegExp(r"^(?=.*[A-Z])(?=.*[!@#\$&*~]).{6,}$");

  // Validator sous chaque Label pour verifier si c'est vide ou si le type est respecter
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inscription'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _nomController,
                    decoration: const InputDecoration(
                      labelText: 'Nom',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre nom';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _prenomController,
                    decoration: const InputDecoration(
                      labelText: 'Prénom',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre prénom';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
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
                      } else if (!emailRegex.hasMatch(value)) {
                        return 'Veuillez entrer un email valide';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _ageController,
                    decoration: const InputDecoration(
                      labelText: 'Âge',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre âge';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Veuillez entrer un âge valide';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _adresseController,
                    decoration: const InputDecoration(
                      labelText: 'Adresse Postale',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre adresse postale';
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
                        return 'Veuillez entrer un mot de passe';
                      } else if (!passwordRegex.hasMatch(value)) {
                        return 'Le mot de passe ne correspond pas aux normes';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Motivation',
                      border: OutlineInputBorder(),
                    ),
                    value: _motivation,
                    onChanged: (String? newValue) {
                      setState(() {
                        _motivation = newValue;
                      });
                    },
                    items: _motivations.map<DropdownMenuItem<String>>((String value) {
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
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('S\'inscrire'),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/form/login');
                },
                child: const Text('Déjà inscrit ? Connectez-vous'), // redirige vers la page Login
              ),
            ),
          ],
        ),
      ),
    );
  }
}
