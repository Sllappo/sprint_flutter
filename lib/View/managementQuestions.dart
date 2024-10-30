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
        child: Column(
          children: [
            NavBar(),

          ],
        ),
      ),
    );
  }
}

Widget NavBar() {
  final List<Map<String, dynamic>> buttons = [
    { 'label': 'HTML' , 'onPressed': ()=>{} },
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
