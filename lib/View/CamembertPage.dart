import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../Controller/allResultsControllerCamembert.dart';

class CamembertPage extends StatefulWidget {
  @override
  _CamembertPageState createState() => _CamembertPageState();
}

class _CamembertPageState extends State<CamembertPage> {
  // variables pour stocker plusieurs données
  Map<String, Map<int, Map<String, double>>> successRates = {};
  String? selectedCategory;
  int? selectedYear;
  List<int> years = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    // variable qui obtiens le pourcentages
    var pourcentage = await getCategorySuccessRate();
    setState(() {
      successRates = pourcentage;
      years = successRates.values.expand((yearMap) => yearMap.keys).toSet().toList()..sort();
      selectedYear = years.isNotEmpty ? years.first : null;
      // si successRates est pas vide on prend la premiere category sinon c'est vide
      selectedCategory = successRates.keys.isNotEmpty ? successRates.keys.first : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Taux de Réussite par Catégorie"),
      ),
      body: successRates.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // Dropdown pour choisir la catégorie
          DropdownButton<String>(
            value: selectedCategory,
            hint: Text("Choisissez une catégorie"),
            onChanged: (newValue) {
              setState(() {
                selectedCategory = newValue;
              });
            },
            // recupere toutes les categories grace a la key de successRates
            items: successRates.keys.map((category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              );
            }).toList(),
          ),
          // Dropdown pour choisir l'année
          DropdownButton<int>(
            value: selectedYear,
            hint: Text("Choisissez une année"),
            onChanged: (newValue) {
              setState(() {
                selectedYear = newValue;
              });
            },
            // recupere toutes les années grace a la key de successRates
            items: years.map((year) {
              return DropdownMenuItem<int>(
                value: year,
                child: Text(year.toString()),
              );
            }).toList(),
          ),
          // Vérifier si une catégorie et une année sont choisi
          if (selectedCategory != null && selectedYear != null)
            Expanded(
              child: ListView(
                children: [
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      selectedCategory!,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    child: PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                            color: Colors.green,
                            // on recupere le pourcentage reussi de la fonction getcategorySuccessRate
                            value: successRates[selectedCategory]![selectedYear]!['successRate'] ?? 0.0,
                            title: '${successRates[selectedCategory]![selectedYear]!['successRate']!.toStringAsFixed(1)}% Réussite',
                            radius: 50,
                            titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          PieChartSectionData(
                            color: Colors.red,
                            // on recupere le pourcentage rater de la fonction getcategorySuccessRate
                            value: successRates[selectedCategory]![selectedYear]!['failureRate'] ?? 0.0,
                            title: '${successRates[selectedCategory]![selectedYear]!['failureRate']!.toStringAsFixed(1)}% Échec',
                            radius: 50,
                            titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                        centerSpaceRadius: 40,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
