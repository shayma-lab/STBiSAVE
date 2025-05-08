import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:my_first_project/models/category.dart';
import 'package:my_first_project/widgets/appbar_widget.dart';

class RapportsPage extends StatelessWidget {
  static const routeName = "/RapportsPage";
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
      appBar: appBar(context, "Rapports & Statistiques"),
      body: SafeArea(
        child: SingleChildScrollView(
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
                            return Text('${value.toInt()} DT',
                                style: const TextStyle(fontSize: 10));
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
                      topTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
              }),
            ],
          ),
        ),
      ),
    );
  }
}
