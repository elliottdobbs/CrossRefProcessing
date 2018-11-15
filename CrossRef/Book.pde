


class Book{
  
  String name;
  int referenced;
  int numberOfVerses;
  Vector verses;
  
  Book(String n){
    name = n;
    referenced = 0;
    numberOfVerses = 0;
    verses = new Vector(100, 100);
  }
  
}
