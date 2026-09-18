import '../entities/book_entity.dart';
import '../entities/student.dart';
import '../storage/data_storage.dart';
class Library {
  final List<BookEntity> _books =[];
  final List<Student> _students = [];
  final DataStorage storage;

 Library(this.storage);

  void addBook(BookEntity book) {
    _books.add(book);
    print("${book.title} has been added to the library.");
  }

  void addStudent(Student student) {
    _students.add(student);
    print("${student.name} has been added.");
  }

  void viewBooks() {

    if (_books.isEmpty) {
      print("No books in the library.");
      return;
    }
    print("Books in the library:");
    for (var book in _books) {
      book.displayInfo();
    }
  }

  BookEntity? searchBookByTitle(String title) {
    for (var book in _books) {
      if (book.title.toLowerCase() == title.toLowerCase()) {
        return book;
      }
    }
    return null;
  }
  BookEntity? searchBookByID(int id) {
    for (var book in _books) {
      if (book.id == id) {
        return book;
      }
    }
    return null;
  }
  Student? searchStudentByID(int id) {
    for (var student in _students) {
      if (student.id == id) {
        return student;
      }
    }
    return null;
  }

  void borrowBook(int bookID,int studentID) {

    final book = searchBookByID(bookID);
  
    if (book == null) {
      print("Book with ID $bookID not found.");
      return;
    }
    final student = searchStudentByID(studentID);
    if (student == null) {
      print("Student with ID $studentID not found.");
      return;
    }

    final success = book.borrow();
    if (success) {
      print("${student.name} has borrowed ${book.title}.");
    } else {
      print("${book.title} is currently not available.");
    }
  }

void returnBook(int bookID,int studentID) {
    final book = searchBookByID(bookID);
  
    if (book == null) {
      print("Book with ID $bookID not found.");
      return;
    }
    final student = searchStudentByID(studentID);
    if (student == null) {
      print("Student with ID $studentID not found.");
      return;
    }

    book.returnBook();
    print("${student.name} has returned ${book.title}.");
  }

  Future<void> saveLibrary() async {
    final data = _books.map((book) => '${book.id},${book.title},${book.author},${book.isAvailable}').join('\n');
    await storage.saveBook(data);
  }

  Future<void> loadLibrary() async {
    final data = await storage.load();
    if (data.isEmpty) {
      print("No data found in storage.");
      return;
    }
    print(data);
  }
}