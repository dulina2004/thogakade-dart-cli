import 'managers/thoga_kade_manager.dart';
import 'cli/command_handler.dart';

void main() {
  print('Welcome to Thoga Kade Vegetable Shop Management System');
  
  final manager = ThogaKadeManager();
  final commandHandler = CommandHandler(manager);
  
  commandHandler.handleUserInput();
}