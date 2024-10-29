import 'package:flutter/material.dart';
import '../Controller/insertContact.dart';
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

  // Fonction qui soumet le formulaire il se base par rapport au variable precedente
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final String nom = _nomController.text;
      final String prenom = _prenomController.text;
      final String email = _emailController.text;
      final int? age = int.tryParse(_ageController.text);
      final String adresse = _adresseController.text;
      final String password = _passwordController.text;
      final String? motivation = _motivation;

      User newUser = User(
        nom: nom,
        prenom: prenom,
        email: email,
        age: age,
        adresse: adresse,
        password: password,
        motivation: motivation ?? '',
        admin: false,
        score: [],
        html: '',
        css: '',
        java: '',
        algo: '',
      );
      try {
        insertUser(newUser);
        print('Inscription réussie pour $nom avec la motivation $_motivation');
      }catch(e){
        print(e);
      }
    } else {
      print('Veuillez remplir tous les champs');
    }
  }

  // Validator sous chaque Label pour verifier si c'est vide ou si le type est respecter
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inscription'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
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
      ),
    );
  }
}
