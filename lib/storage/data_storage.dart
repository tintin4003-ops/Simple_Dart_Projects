abstract interface class DataStorage {
  Future<void> saveBook(String data);

  Future<String> load();

}