import 'package:flutter/material.dart';
import '../Controller/getUser.dart';
import '../Model/user.dart';
import '../Controller/updateProfil.dart';
import '../Model/results.dart';

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

  List<String> userScores =[]; // Liste pour stocker les résultats de l'utilisateur

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

    // Récuperation des données utilisateur et de ses scores
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    //Fonction permettant de récupérer les données de l'utilisateur ainsi que ses résultats
    try {
      User? userProfil = await getUser(userId);//on récupère les données de l'utilisateur connecté
      userScores = await getAllUserScores(userId);//on récupère les résultats de l'utilisateur connecté

      print('Scores utilisateur chargés : $userScores');

      setState(() {
        //On met à jour l'état de userScore sinon l'affichage des scores ne se fait pas
        userScores;
        print('Scores utilisateur chargés : $userScores');
      });

      if (userProfil != null) {
        _nomController.text = userProfil.nom ?? '';
        _prenomController.text = userProfil.prenom ?? '';
        _emailController.text = userProfil.email ?? '';
        _ageController.text = userProfil.age?.toString() ?? '';
        _adresseController.text = userProfil.adresse ?? '';
        _selectedOption = userProfil.motivation ?? _options[0];

      } else {
        //Affiche l'erreur dans une snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Aucun utilisateur trouvé avec cet e-mail.')),
        );
      }
    } catch (e) {
      //Affiche l'erreur dans une snackbar
      print('Erreur lors du chargement du profil : $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du chargement du profil: $e')),
      );
    }
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
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Nom',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _prenomController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Prénom',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'E-mail',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _ageController,
              readOnly: true,
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
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showOptionDialog(context),
                ),
              ),
              controller: TextEditingController(text: _selectedOption),
            ),
            const SizedBox(height: 20),
            // Afficher les scores avec une meilleure présentation
            Text(
              'Vos scores :',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Utiliser une liste pour afficher les scores
            ListView.builder(
              shrinkWrap: true,//les dimensions de la liste dépende du nombre d'éléments à afficher
              physics:
                  const NeverScrollableScrollPhysics(), // Enlevé le scroll des scores
              itemCount: userScores.length,
              itemBuilder: (context, index) {
                final score = userScores[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                      '${score}',
                      style: TextStyle(fontSize: 14),
                    ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  //Popup permettant de modifier l'addresse de l'utilisateur
  void _showAddressDialog(BuildContext context) {
    final TextEditingController _tempAddressController =
        TextEditingController();

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
              onPressed: () =>
                  Navigator.of(context).pop(), // Fermer le dialogue
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  // Appeler la fonction pour mettre à jour l'utilisateur
                  await updateUser(
                      _adresseController.text, _tempAddressController.text);

                  // Mettre à jour l'état local
                  setState(() {
                    _adresseController.text = _tempAddressController.text;
                  });

                  Navigator.of(context).pop(); // Fermer le dialogue
                } catch (e) {
                  // Afficher un message d'erreur si la mise à jour échoue
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Erreur lors de la mise à jour de l\'adresse: $e')),
                  );
                }
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
    // Initialisez avec la valeur actuelle de l'option sélectionnée
    String? tempSelectedOption = _selectedOption;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Modifier ma motivation'),
          content: DropdownButton<String>(
            value: _options.contains(tempSelectedOption)
                ? tempSelectedOption
                : _options[0],
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
                Navigator.of(context).pop(); // Fermer le dialogue
              },
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                updateUserMotivation(tempSelectedOption!);
                setState(() {
                  _selectedOption =
                      tempSelectedOption; // Met à jour la sélection
                });

                // Appelez ici la fonction pour mettre à jour la motivation en base de données

                Navigator.of(context).pop(); // Fermer le dialogue
              },
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }
}
