import 'dart:io';
import 'dart:convert';
import '../models/vegetable.dart';
import '../models/order.dart';
import '../models/report.dart';
import '../exceptions.dart';

class FileService {
  static const String dataDir = 'data';

  static void _ensureDataDirectory() {
    final dir = Directory(dataDir);
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
  }

  static void saveInventoryToFile(List<Vegetable> vegetables) {
    _ensureDataDirectory();
    final file = File('$dataDir/inventory.json');
    try {
      final jsonData = vegetables.map((v) => v.toJson()).toList();
      file.writeAsStringSync(jsonEncode(jsonData));
    } catch (e) {
      throw StorageException('Failed to save inventory: ${e.toString()}');
    }
  }

  static List<Vegetable> loadInventoryFromFile() {
    _ensureDataDirectory();
    final file = File('$dataDir/inventory.json');
    
    if (!file.existsSync()) return [];

    try {
      final jsonString = file.readAsStringSync();
      final List<dynamic> jsonData = jsonDecode(jsonString);
      return jsonData.map((json) => Vegetable.fromJson(json)).toList();
    } catch (e) {
      throw StorageException('Failed to load inventory: ${e.toString()}');
    }
  }

  static void saveOrderHistory(List<Order> orders) {
    _ensureDataDirectory();
    final file = File('$dataDir/orders.json');
    try {
      final jsonData = orders.map((o) => o.toJson()).toList();
      file.writeAsStringSync(jsonEncode(jsonData));
    } catch (e) {
      throw StorageException('Failed to save order history: ${e.toString()}');
    }
  }

  static List<Order> loadOrderHistory() {
    _ensureDataDirectory();
    final file = File('$dataDir/orders.json');
    
    if (!file.existsSync()) return [];

    try {
      final jsonString = file.readAsStringSync();
      final List<dynamic> jsonData = jsonDecode(jsonString);
      return jsonData.map((json) => Order.fromJson(json)).toList();
    } catch (e) {
      throw StorageException('Failed to load order history: ${e.toString()}');
    }
  }

  static void saveReportsToFile(List<Report> reports) {
    _ensureDataDirectory();
    final file = File('$dataDir/reports.json');
    try {
      final jsonData = reports.map((r) => r.toJson()).toList();
      file.writeAsStringSync(jsonEncode(jsonData));
    } catch (e) {
      throw StorageException('Failed to save reports: ${e.toString()}');
    }
  }

  static List<Report> loadReportsFromFile() {
    _ensureDataDirectory();
    final file = File('$dataDir/reports.json');
    
    if (!file.existsSync()) return [];

    try {
      final jsonString = file.readAsStringSync();
      final List<dynamic> jsonData = jsonDecode(jsonString);
      return jsonData.map((json) => Report.fromJson(json)).toList();
    } catch (e) {
      throw StorageException('Failed to load reports: ${e.toString()}');
    }
  }
}