import 'package:flutter/material.dart';

class ManagementTests extends StatelessWidget {
  const ManagementTests({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin - Gestion des tests'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: const Text('Ici, vous pouvez gérer les tests.'),
      ),
    );
  }
}
