import '../models/vegetable.dart';
import '../services/file_service.dart';
import '../exceptions.dart';

class InventoryRepository {
  List<Vegetable> _vegetables = [];

  InventoryRepository() {
    _vegetables = FileService.loadInventoryFromFile();
  }

  List<Vegetable> get vegetables => List.unmodifiable(_vegetables);

  void add(Vegetable vegetable) {
    final existingIndex = _vegetables.indexWhere((v) => v.id == vegetable.id);
    
    if (existingIndex != -1) {
      _vegetables[existingIndex].availableQuantity += vegetable.availableQuantity;
    } else {
      _vegetables.add(vegetable);
    }

    FileService.saveInventoryToFile(_vegetables);
  }

  void remove(String id) {
    _vegetables.removeWhere((veg) => veg.id == id);
    FileService.saveInventoryToFile(_vegetables);
  }

  void updateStock(String id, double quantity) {
    final index = _vegetables.indexWhere((veg) => veg.id == id);
    
    if (index == -1) {
      throw InventoryException('Vegetable with ID $id not found');
    }

    _vegetables[index].availableQuantity = quantity;
    FileService.saveInventoryToFile(_vegetables);
  }

  Vegetable findById(String id) {
    return _vegetables.firstWhere(
      (veg) => veg.id == id,
      orElse: () => throw InventoryException('Vegetable not found'),
    );
  }

  bool exists(String id) {
    return _vegetables.any((veg) => veg.id == id);
  }
}