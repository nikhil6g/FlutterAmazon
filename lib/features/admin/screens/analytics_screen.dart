import "package:amazon_clone/common/widgets/loader.dart";
import "package:amazon_clone/features/admin/models/sales.dart";
import "package:amazon_clone/features/admin/services/admin_services.dart";
import 'package:amazon_clone/features/admin/widget/category_products_chart.dart';
import "package:flutter/material.dart";

enum ChartType { earnings, salesCount }

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final AdminServices adminServices = AdminServices();
  ChartType selectedChart = ChartType.earnings;
  int? totalEarning;
  int? totalSellingCount;
  List<SalesBase>? salesEarnings;
  List<SalesBase>? salesCounts;

  @override
  void initState() {
    super.initState();
    getEarnings();
  }

  void getEarnings() async {
    var earningData = await adminServices.getEarnings(context);
    totalEarning = earningData['totalEarning'];
    totalSellingCount = earningData['totalSellingCount'];
    salesEarnings = earningData['salesEarning'];
    salesCounts = earningData['salesCount'];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return salesEarnings == null ||
            totalEarning == null ||
            totalSellingCount == null ||
            salesCounts == null
        ? const Loader()
        : Column(
            children: [
              Text(
                'Total Earnings: \$$totalEarning',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Total Selling Count: $totalSellingCount',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: DropdownButton(
                  value: selectedChart,
                  items: const [
                    DropdownMenuItem(
                      value: ChartType.earnings,
                      child: Text("Category-wise Total Earnings"),
                    ),
                    DropdownMenuItem(
                      value: ChartType.salesCount,
                      child: Text("Category-wise Total Sales Count"),
                    ),
                  ],
                  onChanged: (ChartType? newVal) {
                    if (newVal != null) {
                      setState(() {
                        selectedChart = newVal;
                      });
                    }
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.only(right: 5, top: 10),
                height: 400,
                child: selectedChart == ChartType.earnings
                    ? CategoryProductsChart(
                        salesData: salesEarnings!,
                        valueExtractor: (sales) =>
                            (sales as SalesEarning).earning,
                        barColor: Colors.blueAccent,
                      )
                    : CategoryProductsChart(
                        salesData: salesCounts!,
                        valueExtractor: (sales) => (sales as SalesCount).count,
                        barColor: Colors.greenAccent,
                      ),
              )
            ],
          );
  }
}
