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
              onTap: () => _showAddressDialog(
                  context), // Appel de la fonction de dialogue
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
                controller: TextEditingController(text: _selectedOption),
                decoration: const InputDecoration(
                  labelText: 'Mon option',
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
    String? selectedOption = _selectedOption; // Conserver la valeur actuelle

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Modifier l\'Option'),
          content: DropdownButtonFormField<String>(
            value: selectedOption,
            items: _options.map((String option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(option),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedOption = newValue; // Met à jour la sélection
              });
            },
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
                      selectedOption; // Enregistre la nouvelle option
                });
                Navigator.of(context).pop();
              },
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }
}
