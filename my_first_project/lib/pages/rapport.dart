import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'acceuil.dart'; // à adapter selon ton arborescence

class RapportsPage extends StatelessWidget {
  const RapportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<CategoryData> categories = [
      CategoryData('Shopping', 256, Icons.shopping_bag, Colors.orange),
      CategoryData('Factures', 80, Icons.receipt_long, Colors.red),
      CategoryData('Alimentation', 45.5, Icons.restaurant, Colors.green),
      CategoryData('Transport', 60, Icons.directions_car, Colors.blue),
      CategoryData('Loisirs', 90, Icons.videogame_asset, Colors.purple),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rapports & Statistiques'),
        centerTitle: true,
        backgroundColor: const Color(0xFF3C8CE7),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Dépenses par Catégorie',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 300,
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text('${value.toInt()} DT', style: const TextStyle(fontSize: 10));
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(categories[value.toInt()].name,
                              style: const TextStyle(fontSize: 10));
                        },
                      ),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  barGroups: List.generate(categories.length, (index) {
                    final cat = categories[index];
                    return BarChartGroupData(x: index, barRods: [
                      BarChartRodData(
                        toY: cat.amount,
                        color: cat.color,
                        width: 20,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ]);
                  }),
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Résumé des dépenses',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            ...categories.map((cat) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  leading: Icon(cat.icon, color: cat.color),
                  title: Text(cat.name),
                  trailing: Text(
                    '-${cat.amount.toStringAsFixed(2)} DT',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        currentIndex: 1, // Page actuelle = Statistiques
        onTap: (index) {
          navigateTo(context, index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.chartPie),
            label: 'Statistiques',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.savings),
            label: 'Objectifs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Compte',
          ),
        ],
      ),
    );
  }

  // Fonction de navigation
  void navigateTo(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AcceuilPage()), // Naviguer vers la page Accueil
        );
        break;
      case 1:
        // Déjà sur Statistiques, donc pas besoin de naviguer
        break;
      case 2:
        Navigator.pushNamed(context, '/objectif'); // Assurez-vous d'avoir défini la route '/objectif' dans MaterialApp
        break;
      case 3:
        Navigator.pushNamed(context, '/compte'); // Assurez-vous d'avoir défini la route '/compte' dans MaterialApp
        break;
      default:
        break;
    }
  }
}

class CategoryData {
  final String name;
  final double amount;
  final IconData icon;
  final Color color;

  CategoryData(this.name, this.amount, this.icon, this.color);
}
