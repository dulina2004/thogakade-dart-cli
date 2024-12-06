class InventoryException implements Exception {
  final String message;
  InventoryException(this.message);

  @override
  String toString() => 'InventoryException: $message';
}

class OrderProcessingException implements Exception {
  final String message;
  OrderProcessingException(this.message);

  @override
  String toString() => 'OrderProcessingException: $message';
}

class StorageException implements Exception {
  final String message;
  StorageException(this.message);

  @override
  String toString() => 'StorageException: $message';
}