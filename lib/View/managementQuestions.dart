import 'package:flutter/material.dart';

class ManagementQuestions extends StatelessWidget {
  const ManagementQuestions({super.key});
  final String tab = "HTML";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin - Gestions des questions'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("aaa"),
            NavBar(tab),
          ],
        ),
      ),
    );
  }
}

Widget NavBar(String tab) {
  final List<Map<String, dynamic>> buttons = [
    { 'label': 'HTML' , 'onPressed': () => {tab='HTML'} },
    { 'label': 'CSS' , 'onPressed': () => {tab='CSS'} },
    { 'label': 'Java' , 'onPressed': () => {tab='JAVA'} },
    { 'label': 'Algo' , 'onPressed': () => {print(tab)} },
  ];

  // Utilisation d'une Column pour afficher les boutons
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: buttons.map((button) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
        child: ElevatedButton(
          onPressed: button['onPressed'],
          child: Text(button['label']),
        ),
      );
    }).toList(),
  );
}

Future<Widget> fetchQuizz() async {
  return Text("Wsh");
}
