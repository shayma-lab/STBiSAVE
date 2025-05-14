import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:my_first_project/models/transactionByCategory.dart';

class BarchartWidget extends StatelessWidget {
  final List<TransactionByCategory> transactions;
  const BarchartWidget(this.transactions, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: transactions
                  .map((e) => e.totalAmount)
                  .fold<num>(0, (prev, curr) => curr > prev ? curr : prev) *
              1.2,
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()} DT',
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= transactions.length) {
                    return const Text('');
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      transactions[index].category.title,
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                },
              ),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          barGroups: List.generate(transactions.length, (index) {
            final cat = transactions[index];
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: cat.totalAmount.toDouble(),
                  color: cat.category.color,
                  width: 20,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
