import 'package:flutter/material.dart';
import './managementQuestions.dart';
import './managementTests.dart';
import './resultsPage.dart';

class AdminCenter extends StatelessWidget {
  const AdminCenter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ButtonsList(context), // Liste des boutons
            ),
          ],
        ),
      ),
    );
  }
}

Widget ButtonsList(BuildContext context) {
  final List<Map<String, dynamic>> buttons = [
    {
      'label': 'Gérer les Questions',
      'onPressed': () {
        Navigator.pushNamed(context, '/admin/management-questions');
      },
    },
    {
      'label': 'Gérer les Tests',
      'onPressed': () {
        Navigator.pushNamed(context, '/admin/management-tests');
      },
    },
    {
      'label': 'Visualiser les Résultats',
      'onPressed': () {
        Navigator.pushNamed(context, '/admin/show-results');
      },
    },
  ];

  return ListView.builder(
    itemCount: buttons.length,
    itemBuilder: (context, index) {
      final button = buttons[index];
      return Column(
        children: [
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: button['onPressed'],
              child: Text(button['label']),
            ),
          ),
          const SizedBox(height: 16),
        ],
      );
    },
  );
}
