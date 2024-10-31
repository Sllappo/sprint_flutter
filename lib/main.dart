import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sprint_flutter/View/majProfil.dart';
import 'View/CamembertPage.dart';
import 'View/majProfil.dart';
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      initialRoute: '/form/login',
      routes: {
        '/form/register': (context) => const FormRegister(),
        '/form/login': (context) => FormLogin(onLoginSuccess: (String userId) {
          // Create an instance of Candidat with the correct name and userId after login
          final Candidat loggedInCandidat = Candidat("Candidat", userId);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(candidat: loggedInCandidat),
            ),
          );
        }),
        '/admin': (context) => const AdminCenter(),
        '/admin/management-questions': (context) => const ManagementQuestions(),
        '/admin/management-tests': (context) => const ManagementTests(),
        '/admin/show-results': (context) => ResultsPage(),
        '/admin/camembert-results': (context) => CamembertPage(),
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
        return null;
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  final Candidat candidat;

  const HomeScreen({Key? key, required this.candidat}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const ProfilePage(), // Profil page
      CategorySelectionPage(candidat: widget.candidat),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.teal, // Selected item color
        unselectedItemColor: Colors.grey[700], // Unselected item color
        showSelectedLabels: true, // Show selected labels
        showUnselectedLabels: true, // Show unselected labels
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Quiz',
          ),
        ],
      ),
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
