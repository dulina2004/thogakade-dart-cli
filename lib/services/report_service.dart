import '../models/vegetable.dart';
import '../models/order.dart';
import '../models/report.dart';
import '../services/file_service.dart';

class ReportService {
  final List<Vegetable> inventory;
  final List<Order> orderHistory;

  ReportService({
    required this.inventory,
    required this.orderHistory,
  });

  Report generateReport() {
    final totalSales = orderHistory.fold(0.0, (sum, order) => sum + order.totalAmount);
    final totalOrders = orderHistory.length;

    final lowStockVegetables = inventory
        .where((veg) => veg.availableQuantity < 10)
        .map((veg) => {
          'name': veg.name,
          'currentStock': veg.availableQuantity,
        })
        .toList();

    final summary = {
      'totalSales': totalSales,
      'totalOrders': totalOrders,
      'lowStockVegetables': lowStockVegetables,
    };

    final report = Report(summary: summary);

    final currentReports = FileService.loadReportsFromFile();
    currentReports.add(report);
    FileService.saveReportsToFile(currentReports);

    return report;
  }

  void displayAllReports() {
    final reports = FileService.loadReportsFromFile();
    
    if (reports.isEmpty) {
      print('No reports available.');
      return;
    }

    print('\n===== REPORTS HISTORY =====');
    for (var report in reports) {
      print('\nReport ID: ${report.reportID}');
      print('Generated Date: ${report.generatedDate}');
      print('Total Sales: \$${report.summary['totalSales']}');
      print('Total Orders: ${report.summary['totalOrders']}');
      
      print('Low Stock Vegetables:');
      final lowStock = report.summary['lowStockVegetables'];
      if (lowStock.isEmpty) {
        print('  - No low stock vegetables');
      } else {
        for (var veg in lowStock) {
          print('  - ${veg['name']}: ${veg['currentStock']} kg');
        }
      }
      print('--------------------');
    }
  }
}