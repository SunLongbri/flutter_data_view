/// Bar chart example
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:fluttermarketingplus/model/ordinal_sales.dart';

//实收金额表组件
class DollarHorizontalBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  DollarHorizontalBarChart(this.seriesList, {this.animate});

  /// Creates a stacked [BarChart] with sample data and no transition.
  factory DollarHorizontalBarChart.withSampleData(List<OrdinalSales> list) {
    return new DollarHorizontalBarChart(
      _createSampleData(list),
      // Disable animations for image tests.
      animate: false,
    );
  }


  @override
  Widget build(BuildContext context) {
    // For horizontal bar charts, set the [vertical] flag to false.
    return new charts.BarChart(
      seriesList,
      animate: animate,
      barGroupingType: charts.BarGroupingType.stacked,
      vertical: false,
    );
  }

  /// Create series list with multiple series
  static List<charts.Series<OrdinalSales, String>> _createSampleData(List<OrdinalSales> list) {
    final desktopSalesData = list;

//    final tableSalesData = [
//      new OrdinalSales('2014', 25),
//      new OrdinalSales('2015', 50),
//      new OrdinalSales('2016', 10),
//      new OrdinalSales('2017', 20),
//    ];
//
//    final mobileSalesData = [
//      new OrdinalSales('2014', 10),
//      new OrdinalSales('2015', 15),
//      new OrdinalSales('2016', 50),
//      new OrdinalSales('2017', 45),
//    ];

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Desktop',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: desktopSalesData,
      ),
//      new charts.Series<OrdinalSales, String>(
//        id: 'Tablet',
//        domainFn: (OrdinalSales sales, _) => sales.year,
//        measureFn: (OrdinalSales sales, _) => sales.sales,
//        data: tableSalesData,
//      ),
//      new charts.Series<OrdinalSales, String>(
//        id: 'Mobile',
//        domainFn: (OrdinalSales sales, _) => sales.year,
//        measureFn: (OrdinalSales sales, _) => sales.sales,
//        data: mobileSalesData,
//      ),
    ];
  }
}