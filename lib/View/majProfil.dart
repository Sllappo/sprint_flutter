import 'package:flutter/material.dart';
import 'formRegister.dart';
import '../Controller/getUser.dart';
import '../Model/user.dart';

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

  User userProfil = await getUser('encore@mail');

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
              decoration: const InputDecoration(
                labelText: 'E-mail',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(
                labelText: 'Âge',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _adresseController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Adresse Postale',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showAddressDialog(context),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Ma motivation',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  // lorsqu'on appui sur le crayon cela ouvre le showdialog
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showOptionDialog(context),
                ),
              ),
              controller: TextEditingController(text: _selectedOption),
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
    // _tempAddressController.text = _adresseController.text;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Modifier mon adresse postale'),
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

  // Dialog pour modifier la motivation avec menu déroulant
  void _showOptionDialog(BuildContext context) {
    String? tempSelectedOption = _selectedOption;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Modifier ma motivation'),
          content: DropdownButton<String>(
            value: tempSelectedOption,
            isExpanded: true,
            onChanged: (String? newValue) {
              setState(() {
                tempSelectedOption = newValue;
              });
            },
            items: _options.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
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
                      tempSelectedOption; // Met à jour la sélection
                });
                Navigator.of(context).pop(); // Ferme le dialogue
              },
              //lorsque j'appuie sur enregistrer l'option est sauvegarder dans _selectedOption
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }
}
