import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sprint_flutter/View/majProfil.dart';
import 'View/formRegister.dart';
import 'View/adminCenter.dart';
import 'View/managementQuestions.dart';
import 'View/managementTests.dart';
import 'View/resultsPage.dart';
import 'View/quiz_page.dart';
import 'View/categorySelectionPage.dart';
import 'Model/candidate.dart';
import 'View/formLogin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // Instance de Candidat à utiliser dans les routes
  final Candidat candidat = Candidat("Candidat");

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/form/login',
      routes: {
        '/form/register': (context) => const FormRegister(),
        '/form/login': (context) => const FormLogin(),
        '/admin': (context) => const AdminCenter(),
        '/admin/management-questions': (context) => const ManagementQuestions(),
        '/admin/management-tests': (context) => const ManagementTests(),
        '/admin/show-results': (context) => ResultsPage(),
        '/form/profil': (context) => const ProfilePage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/quiz') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => QuizPage(
              category: args['category'],
              candidat: args['candidat'],
            ),
          );
        } else if (settings.name == '/categories') {
          final Candidat candidat = settings.arguments as Candidat;
          return MaterialPageRoute(
            builder: (context) => CategorySelectionPage(candidat: candidat),
          );
        }
        return null; // Retourne null si la route n'est pas gérée ici
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
