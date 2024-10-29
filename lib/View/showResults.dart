import 'package:flutter/material.dart';

class ShowResults extends StatelessWidget {
  const ShowResults({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin - Visualisation des résultats'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: const Text('Ici, vous pouvez visualiser les résultats.'),
      ),
    );
  }
}
