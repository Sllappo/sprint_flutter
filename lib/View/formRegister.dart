import 'package:flutter/material.dart';
import '../Controller/insertContact.dart';
import '../Controller/emailVerification.dart';
import '../Model/user.dart';
import '../Model/candidate.dart';

class FormRegister extends StatefulWidget {
  const FormRegister({super.key});

  @override
  State<FormRegister> createState() => _FormRegisterState();
}

class _FormRegisterState extends State<FormRegister> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _adresseController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _motivation;
  final List<String> _motivations = [
    'Poursuite d’étude',
    'Reconversion pro',
    'Réorientation'
  ];

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final String email = _emailController.text;
      userId = email;

      bool emailAvailable = await isEmailAvailable(email);
      if (!emailAvailable) {
        print('Cet email est déjà utilisé. Veuillez en choisir un autre.');
        return;
      }

      final String nom = _nomController.text;
      final String prenom = _prenomController.text;
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
      );

      try {
        insertUser(newUser);
        print('Inscription réussie pour $nom avec la motivation $_motivation');

        Candidat candidat = Candidat(nom);

        Navigator.pushReplacementNamed(context, '/categories', arguments: candidat);
      } catch (e) {
        print(e);
      }
    } else {
      print('Veuillez remplir tous les champs');
    }
  }

  final RegExp emailRegex = RegExp(r".+@.+");
  final RegExp passwordRegex = RegExp(r"^(?=.*[A-Z])(?=.*[!@#\$&*~]).{6,}$");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inscription'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'Rejoignez Le Quiz de Compétences !',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _nomController,
                          decoration: InputDecoration(
                            labelText: 'Nom',
                            labelStyle: TextStyle(color: Colors.teal.shade700),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
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
                          decoration: InputDecoration(
                            labelText: 'Prénom',
                            labelStyle: TextStyle(color: Colors.teal.shade700),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
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
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(color: Colors.teal.shade700),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: const Icon(Icons.email, color: Colors.teal),
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
                          decoration: InputDecoration(
                            labelText: 'Âge',
                            labelStyle: TextStyle(color: Colors.teal.shade700),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: const Icon(Icons.calendar_today, color: Colors.teal),
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
                          decoration: InputDecoration(
                            labelText: 'Adresse Postale',
                            labelStyle: TextStyle(color: Colors.teal.shade700),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: const Icon(Icons.home, color: Colors.teal),
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
                          decoration: InputDecoration(
                            labelText: 'Mot de passe',
                            labelStyle: TextStyle(color: Colors.teal.shade700),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: const Icon(Icons.lock, color: Colors.teal),
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
                          decoration: InputDecoration(
                            labelText: 'Motivation',
                            labelStyle: TextStyle(color: Colors.teal.shade700),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
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
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'S\'inscrire',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/form/login');
                  },
                  child: const Text(
                    'Déjà inscrit ? Connectez-vous',
                    style: TextStyle(color: Colors.teal),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
