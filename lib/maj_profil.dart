import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Page de Profil',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _adresseController = TextEditingController();

  String? _selectedOption; // Variable pour stocker l'option sélectionnée
  final List<String> _options = ['Option 1', 'Option 2', 'Option 3'];

  @override
  void initState() {
    super.initState();
    _selectedOption = _options[0]; // Initialiser avec la première option
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            TextField(
              controller: _nomController,
              decoration: const InputDecoration(
                labelText: 'Nom',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _prenomController,
              decoration: const InputDecoration(
                labelText: 'Prénom',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'E-mail',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Âge',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => _showEditAddressDialog(context),
              child: TextField(
                controller: _adresseController,
                decoration: const InputDecoration(
                  labelText: 'Adresse Postale',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.edit),
                ),
                readOnly:
                    true, // Le champ est en lecture seule pour désactiver la saisie directe
              ),
            ),
            const SizedBox(height: 10),
            // Section pour le menu déroulant et l'icône de crayon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedOption,
                    decoration: const InputDecoration(
                      labelText: 'Choisir une Option',
                      border: OutlineInputBorder(),
                    ),
                    items: _options.map((String option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedOption =
                            newValue; // Met à jour l'option sélectionnée
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _showEditOptionDialog(
                        context); // Ouvrir le dialogue pour modifier l'option
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // Fonction pour afficher le dialog de modification d'adresse
  void _showEditAddressDialog(BuildContext context) {
    final TextEditingController _tempAdresseController =
        TextEditingController();
    _tempAdresseController.text =
        _adresseController.text; // Préremplir avec l'adresse actuelle

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Modifier l\'Adresse Postale'),
          content: TextField(
            controller: _tempAdresseController,
            decoration: const InputDecoration(
              labelText: 'Nouvelle Adresse',
              border: OutlineInputBorder(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Ferme le dialogue
              },
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _adresseController.text = _tempAdresseController
                      .text; // Met à jour l'adresse principale
                });
                Navigator.of(context).pop(); // Ferme le dialogue
              },
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  // Fonction pour afficher le dialog de modification de l'option
  void _showEditOptionDialog(BuildContext context) {
    final TextEditingController _tempOptionController = TextEditingController();
    _tempOptionController.text =
        _selectedOption ?? ''; // Préremplir avec l'option actuelle

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Modifier l\'Option'),
          content: Column(
            mainAxisSize:
                MainAxisSize.min, // Permet de redimensionner le dialogue
            children: [
              DropdownButtonFormField<String>(
                value: _tempOptionController.text.isNotEmpty
                    ? _tempOptionController.text
                    : null,
                items: _options.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  _tempOptionController.text =
                      newValue!; // Met à jour l'option temporaire
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Ferme le dialogue
              },
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedOption = _tempOptionController
                      .text; // Met à jour l'option principale
                });
                Navigator.of(context).pop(); // Ferme le dialogue
              },
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }
}
