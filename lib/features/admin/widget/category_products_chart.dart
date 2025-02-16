import "package:amazon_clone/features/admin/models/sales.dart";
import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";

class CategoryProductsChart<T extends SalesBase> extends StatelessWidget {
  final List<T> salesData;
  final int Function(T) valueExtractor;
  final Color barColor;
  const CategoryProductsChart(
      {super.key,
      required this.salesData,
      required this.valueExtractor,
      required this.barColor});

  List<BarChartGroupData> _buildBarGroups() {
    return List.generate(salesData.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: valueExtractor(salesData[index]).toDouble(),
            width: 16,
            color: barColor,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5.0), topRight: Radius.circular(5.0)),
          ),
        ],
      );
    });
  }

  Widget leftTitles(double value, TitleMeta meta) {
    if (value == meta.max) {
      return Container();
    }
    const style = TextStyle(
      fontSize: 10,
    );
    return SideTitleWidget(
      axisSide: AxisSide.left,
      child: Text(
        meta.formattedValue,
        style: style,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: salesData.isNotEmpty
            ? salesData
                    .map((e) => valueExtractor(e))
                    .reduce((a, b) => a > b ? a : b) +
                1000
            : 1000, // Auto-scale Y-axis
        barGroups: _buildBarGroups(),
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: leftTitles,
              reservedSize: 40,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, _) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    salesData[value.toInt()].label, // Show category names
                    style: const TextStyle(fontSize: 12),
                  ),
                );
              },
              reservedSize: 40,
            ),
          ),
        ),
      ),
    );
  }
}
