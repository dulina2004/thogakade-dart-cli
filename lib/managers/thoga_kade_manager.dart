import 'package:thoga_kade/models/report.dart';
import 'package:thoga_kade/services/report_service.dart';

import '../models/vegetable.dart';
import '../models/order.dart';
import '../services/file_service.dart';
import '../exceptions.dart';

class ThogaKadeManager {
  List<Vegetable> _inventory = [];
  List<Order> _orderHistory = [];

  ThogaKadeManager() {
    
    _inventory = FileService.loadInventoryFromFile();
    _orderHistory = FileService.loadOrderHistory();
  }

  List<Vegetable> get inventory => List.unmodifiable(_inventory);
  List<Order> get orderHistory => List.unmodifiable(_orderHistory);

  void addVegetable(Vegetable vegetable) {
    final existingIndex = _inventory.indexWhere((v) => v.name == vegetable.name);
    
    if (existingIndex != -1) {
      _inventory[existingIndex].availableQuantity += vegetable.availableQuantity;
    } else {
      _inventory.add(vegetable);
    }
    FileService.saveInventoryToFile(_inventory);
  }
  void removeVegetable(String id) {
    _inventory.removeWhere((veg) => veg.id == id);
    FileService.saveInventoryToFile(_inventory);
  }
  void updateStock(String id, double quantity) {
    final index = _inventory.indexWhere((veg) => veg.id == id);
    
    if (index == -1) {
      throw InventoryException('Vegetable with ID $id not found');
    }

    _inventory[index].availableQuantity = quantity;
    FileService.saveInventoryToFile(_inventory);
  }
  Order processOrder(Map<String, double> orderItems) {
    final orderDetails = <String, double>{};
    double totalAmount = 0.0;
    for (var entry in orderItems.entries) {
      final vegetable = _inventory.firstWhere(
        (veg) => veg.id == entry.key,
        orElse: () => throw InventoryException('Vegetable not found'),
      );

      if (vegetable.availableQuantity < entry.value) {
        throw InventoryException('Insufficient stock for ${vegetable.name}');
      }
      final itemTotal = vegetable.pricePerKg * entry.value;
      orderDetails[entry.key] = entry.value;
      totalAmount += itemTotal;
      if (entry.value > 50) {
        totalAmount *= 0.9; 
      }
      vegetable.availableQuantity -= entry.value;
    }
    final order = Order(
      items: orderDetails,
      totalAmount: totalAmount,
    );
    _orderHistory.add(order);
    FileService.saveInventoryToFile(_inventory);
    FileService.saveOrderHistory(_orderHistory);

    return order;
  }
  Report generateReport() {
    final reportService = ReportService(
      inventory: _inventory,
      orderHistory: _orderHistory,
    );
    return reportService.generateReport();
  }
  void displayInventory() {
    print('\n===== CURRENT INVENTORY =====');
    if (_inventory.isEmpty) {
      print('No vegetables in stock.');
      return;
    }

    for (var veg in _inventory) {
      print('${veg.name} (${veg.category}):');
      print('  Price: \Rs.${veg.pricePerKg}/kg');
      print('  Available: ${veg.availableQuantity} kg');
      print('  Expires: ${veg.expiryDate}');
      print('--------------------');
    }
  }

  void inventoryay() {}
}