import 'data_storage.dart';

class MemoryStorage implements DataStorage {
  String _data = "";
  @override
  Future<void> saveBook(String data) async {
  
    print("Saving data.....");
    await Future.delayed(const Duration(seconds: 2));
    _data = data;
    print("Library data saved to memory storage.");
  }

  @override
  Future<String> load() async {
    print("Loading books from memory storage...");
    await Future.delayed(const Duration(seconds: 3));
    
    return _data;

}
}