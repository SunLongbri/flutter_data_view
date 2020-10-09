/// Bar chart example
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:fluttermarketingplus/model/ordinal_sales.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';

//快递单量图表组件
class ExpressHorizontalBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  ExpressHorizontalBarChart(this.seriesList, {this.animate});

  /// Creates a stacked [BarChart] with sample data and no transition.
  factory ExpressHorizontalBarChart.withSampleData(List<OrdinalSales> list) {
    return ExpressHorizontalBarChart(
      _createSampleData(list),
      // Disable animations for image tests.
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    // For horizontal bar charts, set the [vertical] flag to false.
    return Container(
      child: charts.BarChart(
        seriesList,
        animate: animate,
        barGroupingType: charts.BarGroupingType.stacked,
        vertical: false,
      ),
    );
  }

  /// Create series list with multiple series
  static List<charts.Series<OrdinalSales, String>> _createSampleData(List<OrdinalSales> list) {
    final desktopSalesData = list;

    return [
      charts.Series<OrdinalSales, String>(
        id: 'Desktop',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: desktopSalesData,
      ),
//      new charts.Series<OrdinalSales, String>(
//        id: 'Tablet',
//        domainFn: (OrdinalSales sales, _) => sales.year,
//        measureFn: (OrdinalSales sales, _) => sales.sales,
//        data: desktopSalesData,
//      ),
//      new charts.Series<OrdinalSales, String>(
//        id: 'Mobile',
//        domainFn: (OrdinalSales sales, _) => sales.year,
//        measureFn: (OrdinalSales sales, _) => sales.sales,
//        data: desktopSalesData,
//      ),
    ];
  }
}

