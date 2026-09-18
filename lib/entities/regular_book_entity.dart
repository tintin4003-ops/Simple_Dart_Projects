import 'book_entity.dart';

class RegularBook extends BookEntity
{
  RegularBook(int id, String title, String author) : super(id, title, author);

  @override
  bool borrow() {
    if (!isAvailable) {
      print("Sorry, this book is currently not available for borrowing.");
      return false; 
    }
 
    borrowBook();
    print("You have successfully borrowed the book: $title by $author.");
    return true;
  }
}