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
        userScores ;
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
          const SnackBar(content: Text('Aucun utilisateur trouvé avec cet e-mail.')),
        );
      }
    } catch (e) {
      print('Erreur lors du chargement du profil : $e'); // Déboguer l'erreur
      //Affiche l'erreur dans une snackbar
      print('Erreur lors du chargement du profil : $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du chargement du profil: $e')),
      );
    }
  }

  Future<void> refreshScore() async{
    try {
      userScores = await getAllUserScores(userId);//on rafraichit les résultats de l'utilisateur connecté

      print('Scores utilisateur chargés : $userScores');
      setState(() {
        //On met à jour l'état de userScore sinon l'affichage des scores ne se fait pas
        userScores ;
        print('Scores utilisateur chargés : $userScores');
      });
    } catch (e) {
      //Affiche l'erreur dans une snackbar
      print('Erreur lors du raffraichissement des résultats : $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du raffraichissement des résultats : $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Profil'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            // Carte d'entête de profil
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 6,
              color: Colors.teal[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      "${_prenomController.text} ${_nomController.text}",
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _emailController.text,
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Formulaire de mise à jour du profil
            _buildProfileField(_nomController, 'Nom', isReadOnly: true),
            const SizedBox(height: 10),
            _buildProfileField(_prenomController, 'Prénom', isReadOnly: true),
            const SizedBox(height: 10),
            _buildProfileField(_emailController, 'E-mail', isReadOnly: true),
            const SizedBox(height: 10),
            _buildProfileField(_ageController, 'Âge', isReadOnly: true),
            const SizedBox(height: 10),

            // Adresse avec option de modification
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

            // Motivation avec option de modification
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

            // Affichage des scores sous forme de carte
            Text(
              'Vos scores :',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,//les dimensions de la liste dépende du nombre d'éléments à afficher
              physics:
                  const NeverScrollableScrollPhysics(), // Enlevé le scroll des scores
              itemCount: userScores.length,
              itemBuilder: (context, index) {
                final score = userScores[index];
                return Card(
                  color: Colors.teal[50],
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                      '${score}',
                      style: TextStyle(fontSize: 14),
                    ),
                );
              },
            ),ElevatedButton(onPressed: () => refreshScore(),
                child: Text("Refresh"))
          ],
        ),
      ),
    );
  }

  // Fonction de champ de profil pour simplifier la mise en page
  Widget _buildProfileField(TextEditingController controller, String label, {bool isReadOnly = false}) {
    return TextField(
      controller: controller,
      readOnly: isReadOnly,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
  //Popup permettant de modifier l'addresse de l'utilisateur

  void _showAddressDialog(BuildContext context) {
    final TextEditingController _tempAddressController = TextEditingController();

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
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                await updateUser(_adresseController.text, _tempAddressController.text);
                setState(() {
                  _adresseController.text = _tempAddressController.text;
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

  // Dialog pour modifier la motivation avec menu déroulant
  void _showOptionDialog(BuildContext context) {
    String? tempSelectedOption = _selectedOption;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Modifier ma motivation'),
          content: DropdownButton<String>(
            value: _options.contains(tempSelectedOption) ? tempSelectedOption : _options[0],
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
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                updateUserMotivation(tempSelectedOption!);
                setState(() {
                  _selectedOption = tempSelectedOption;
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
