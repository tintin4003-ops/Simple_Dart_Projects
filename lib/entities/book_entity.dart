abstract class BookEntity {
int id;
String title;
String author;
bool _isAvailable=true;

BookEntity(this.id,this.title,this.author);
bool get isAvailable => _isAvailable;
bool borrow();
void returnBook()
{
  _isAvailable=true;
}

void borrowBook()
{
  _isAvailable=false;
}

void displayInfo()
{
  print("Book ID: $id");
  print("Title: $title");
  print("Author: $author");
  print("Available: $isAvailable");

}
}