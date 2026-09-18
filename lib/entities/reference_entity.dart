import 'book_entity.dart';

class ReferenceBook extends BookEntity
{
  
  ReferenceBook(int id, String title, String author):super(id,title,author);
  @override
  bool borrow()
  {
    print("Sorry, reference books cannot be borrowed.");
    return false; 
  }
}