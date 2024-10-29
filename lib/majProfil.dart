import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ProfilePage(),
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
  final TextEditingController _motivationController = TextEditingController();

  String? _selectedOption;
  final List<String> _options = [
    'Poursuite d\'études',
    'Réorientation',
    'Reconversion'
  ];

  @override
  void initState() {
    super.initState();
    _selectedOption = _options[0];
    _motivationController.text =
        _selectedOption!; // Initialise le champ de motivation
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
              onTap: () => _showAddressDialog(context),
              child: TextField(
                controller: _adresseController,
                decoration: const InputDecoration(
                  labelText: 'Adresse Postale',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.edit),
                ),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => _showOptionDialog(context),
              child: TextField(
                controller:
                    _motivationController, // Utilise le contrôleur pour motivation
                decoration: const InputDecoration(
                  labelText: 'Ma motivation',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.edit),
                ),
                readOnly: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Dialog pour modifier l'adresse postale
  void _showAddressDialog(BuildContext context) {
    final TextEditingController _tempAddressController =
        TextEditingController();
    _tempAddressController.text = _adresseController.text;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Modifier l\'Adresse Postale'),
          content: TextField(
            controller: _tempAddressController,
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
                  _adresseController.text = _tempAddressController.text;
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

  // Dialog pour modifier l'option
  void _showOptionDialog(BuildContext context) {
    final TextEditingController _tempMotivationController =
        TextEditingController(
            text: _motivationController
                .text); // Utiliser un contrôleur temporaire

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Modifier l\'Option'),
          content: TextField(
            controller: _tempMotivationController,
            decoration: const InputDecoration(
              labelText: 'Nouvelle Motivation',
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
                  _selectedOption =
                      _tempMotivationController.text; // Met à jour la sélection
                  _motivationController.text =
                      _selectedOption!; // Met à jour le champ
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
