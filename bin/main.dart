import '../lib/entities/student.dart';
import '../lib/services/library.dart';
import '../lib/storage/memory_storage.dart';
import '../lib/entities/regular_book_entity.dart';
import '../lib/entities/reference_book_entity.dart';
Future<void> main() async {
{
  final storage = MemoryStorage();
  final library = Library(storage);
  
  final student1 = Student(1, "Alice"); 
  final student2 = Student(2, "Bob");
  
  final book1 = RegularBook(1, "The Great Gatsby", "F. Scott Fitzgerald");
  final book2 = RegularBook(2, "To Kill a Mockingbird", "Harper Lee");
  final book3 = ReferenceBook(3, "1984", "George Orwell");

  library.addStudent(student1);
  library.addStudent(student2);

  library.addBook(book1);
  library.addBook(book2);
  library.addBook(book3);   

  library.viewBooks();
//
  library.borrowBook(1, 1);
  library.borrowBook(3, 2);

  library.viewBooks();
  library.saveLibrary();

  library.loadLibrary();

}
}