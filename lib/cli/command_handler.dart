import 'dart:io';
import '../models/vegetable.dart';
import '../managers/thoga_kade_manager.dart';
import '../services/report_service.dart';

class CommandHandler {
  final ThogaKadeManager manager;

  CommandHandler(this.manager);

  void displayMenu() {
    print('\n===== THOGA KADE MANAGEMENT SYSTEM =====');
    print('1. View Inventory');
    print('2. Add Vegetable');
    print('3. Remove Vegetable');
    print('4. Update Stock');
    print('5. Process Order');
    print('6. Generate Report');
    print('7. View Reports');
    print('8. Exit');
    print('===============================');
    print('Enter your choice: ');
  }

  void handleUserInput() {
    while (true) {
      displayMenu();
      final input = stdin.readLineSync()?.trim();

      switch (input) {
        case '1':
          manager.displayInventory();
          break;
        case '2':
          _addVegetablePrompt();
          break;
        case '3':
          _removeVegetablePrompt();
          break;
        case '4':
          _updateStockPrompt();
          break;
        case '5':
          _processOrderPrompt();
          break;
        case '6':
          _generateReportPrompt();
          break;
        case '7':
          _viewReportsPrompt();
          break;
        case '8':
          print('Exiting Thoga Kade Management System. Goodbye!');
          return;
        default:
          print('Invalid choice. Please try again.');
      }

      print('\nPress Enter to continue...');
      stdin.readLineSync();
    }
  }

  void _addVegetablePrompt() {
    try {
      print('Enter Vegetable Name: ');
      final name = stdin.readLineSync()?.trim() ?? '';

      print('Enter Price per KG: ');
      final price = double.parse(stdin.readLineSync() ?? '0');

      print('Enter Available Quantity: ');
      final quantity = double.parse(stdin.readLineSync() ?? '0');

      print('Select Category (0:Leafy, 1:Root, 2:Fruit, 3:Other): ');
      final categoryIndex = int.parse(stdin.readLineSync() ?? '3');
      final category = VegetableCategory.values[categoryIndex];

      print('Enter Expiry Date (YYYY-MM-DD): ');
      final expiryDate = DateTime.parse(stdin.readLineSync() ?? DateTime.now().toString());

      final vegetable = Vegetable(
        name: name,
        pricePerKg: price,
        availableQuantity: quantity,
        category: category,
        expiryDate: expiryDate,
      );

      manager.addVegetable(vegetable);
      print('Vegetable added successfully!');
    } catch (e) {
      print('Error adding vegetable: $e');
    }
  }

  void _removeVegetablePrompt() {
    print('Enter Vegetable ID to remove: ');
    final id = stdin.readLineSync()?.trim() ?? '';
    
    try {
      manager.removeVegetable(id);
      print('Vegetable removed successfully!');
    } catch (e) {
      print('Error removing vegetable: $e');
    }
  }

  void _updateStockPrompt() {
    print('Enter Vegetable ID to update: ');
    final id = stdin.readLineSync()?.trim() ?? '';

    print('Enter New Quantity: ');
    final quantity = double.parse(stdin.readLineSync() ?? '0');

    try {
      manager.updateStock(id, quantity);
      print('Stock updated successfully!');
    } catch (e) {
      print('Error updating stock: $e');
    }
  }

  void _processOrderPrompt() {
    final orderItems = <String, double>{};

    while (true) {
      print('Enter Vegetable ID (or press Enter to finish): ');
      final id = stdin.readLineSync()?.trim();
      
      if (id == null || id.isEmpty) break;

      print('Enter Quantity: ');
      final quantity = double.parse(stdin.readLineSync() ?? '0');

      orderItems[id] = quantity;
    }

    try {
      final order = manager.processOrder(orderItems);
      print('Order processed successfully!');
      print('Total Amount: \Rs.${order.totalAmount.toStringAsFixed(2)}');
    } catch (e) {
      print('Error processing order: $e');
    }
  }

  void _generateReportPrompt() {
    try {
      final report = manager.generateReport();
      print('Report generated successfully!');
      print('Total Sales: \Rs.${report.summary['totalSales']}');
      print('Total Orders: ${report.summary['totalOrders']}');
    } catch (e) {
      print('Error generating report: $e');
    }
  }

  void _viewReportsPrompt() {
    final reportService = ReportService(
      inventory: manager.inventory,
      orderHistory: manager.orderHistory,
    );
    reportService.displayAllReports();
  }
}