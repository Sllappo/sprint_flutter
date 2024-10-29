import 'package:flutter/material.dart';

class ManagementQuestions extends StatelessWidget {
  const ManagementQuestions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin - Gestions des questions'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: const Text('Ici, vous pouvez gérer les questions.'),
      ),
    );
  }
}
