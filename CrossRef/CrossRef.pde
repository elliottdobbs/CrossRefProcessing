import java.lang.String;
import java.util.Map;
import java.util.Vector;
import processing.svg.PGraphicsSVG;
int numberOfPoints = 31102;
int circleRad = 5950;
int bookLineLength = 200;

int maxReferencedBookNum = 38363;

JSONObject json;
Verse[] verses;
Book[] books;


void setup() {
  size(12500, 12500);
  
  verses = new Verse[31103];
  for (int i = 1; i < 31103; i++){
    verses[i] = new Verse();
  }
  
  books = new Book[66];
  
  loadData();
  
  calculateBookReferencedNumbers();
  printBookReferencedValues();
  
  String currentBook = "GEN";
  //drawRefs(currentBook);
  drawBookNumsRefs();
  
  String saveName = currentBook + ".jpg";
  save(saveName);
}



void drawBookNumsRefs(){
  background(255);
  
  int x = 0;
  int rectWidth = width/66 + 1;
  int rectHeight;
  int labelOffset = 500;
  int letterSize = rectWidth - 50;
  
  textSize(letterSize);
  fill(0);
  int numberOfLines = 39, lineHeight;
  for (int i = 0; i < numberOfLines; ++i){
    lineHeight = height - 500 - ((i * 1000) * (height - labelOffset) / maxReferencedBookNum);
    
    if (i % 5 == 0){
      strokeWeight(5);
    }
    else{
      strokeWeight(1);
    }
    
    line(0, lineHeight, width, lineHeight);
  }
  
  fill(0, 0, 0, 93);
  for (int i = 0; i < 66; ++i){
    rectHeight = int((float)books[i].referenced * (height - labelOffset) / maxReferencedBookNum);
    rect(x, height - rectHeight - labelOffset, rectWidth, rectHeight);
    
    pushMatrix();
    translate(x + letterSize/2 - 45, height - labelOffset + labelOffset/10);
    rotate(PI/2.0);
    text(books[i].name, 0, 0); 
    popMatrix();
    
    x += rectWidth;
  }
}



void drawRefs(String n) {
  background(255);
  
  String prevBook = "", currentBook;
  
  //Iterates through all the verses
  for (int i = 1; i < 31103; i++){
    
    //Making a 1 pixel point for every verse
    fill(0);
    stroke(0, 0, 0, 8);
    strokeWeight(1);
    point((float)(verses[i].x), (float)(verses[i].y));
    
    //Progress Tracking
    if (i % 1000 == 0){
      print("Drawing Reference Lines for each Verse: ", str(i), "\n"); 
    }
    
    //Checking if we are at a new book
    currentBook = verses[i].name.substring(0, 3);
    if (!currentBook.equals(prevBook)){
      prevBook = currentBook;
      
      //Creating a Book marker line
      stroke(0, 0, 0, 255);
      strokeWeight(6);
      line((float)verses[i].x, 
           (float)verses[i].y, 
           (float)(cos(i * 2 * PI/numberOfPoints)*(circleRad + bookLineLength) + width/2),
           (float)(sin(i * 2 * PI/numberOfPoints)*(circleRad + bookLineLength) + height/2));
    }
    
    if (verses[i].name.substring(0, 3).equals(n)){
      stroke(0, 0, 0, 8);
      strokeWeight(1);
    
      //Iterates through the cross references for this verse
      for (Map.Entry howdy : verses[i].crossRef.entrySet()){
        line( (float)verses[i].x, 
              (float)verses[i].y, 
              (float)verses[Integer.parseInt(howdy.getKey().toString())].x, 
              (float)verses[Integer.parseInt(howdy.getKey().toString())].y);
      }
    }
  }
}



void calculateBookReferencedNumbers(){
  
  print("Calculating Book Reference Numbers");
  
  for (int i = 1; i < 31103; ++i){
    books[verses[i].book].referenced += verses[i].referenced;
  }
  
}



void printBookReferencedValues(){
  
  for (int i = 0; i < 66; ++i){
    print(books[i].name, ": ", books[i].referenced, "\n");
  }
}



 void loadData() {
  json = loadJSONObject("fullJson.json");
  
  String prevBook = "", currentBook;
  int bookItr = -1;

  for (int i = 1; i < 31103; ++i){
    if (i % 1000 == 0){
      print("Getting verses: ", str(i), "\n"); 
    }
    JSONObject verseData = json.getJSONObject(str(i));
    verses[i].name = verseData.getString("v");
    verses[i].x = cos(i * 2 * PI/numberOfPoints)*circleRad + width/2;
    verses[i].y = sin(i * 2 * PI/numberOfPoints)*circleRad + height/2;
    
    currentBook = verses[i].name.substring(0, 3);
    if (!currentBook.equals(prevBook)){
      prevBook = currentBook;
      ++bookItr;
           
      books[bookItr] = new Book(currentBook);
    }
    
    //Adds verse to the corresponding book
    books[bookItr].verses.addElement(new Integer(i));
    ++books[bookItr].numberOfVerses;
    verses[i].book = bookItr;

    JSONObject refs = verseData.getJSONObject("r");

    //If there are cross references present...
    if (verseData.getJSONObject("r") != null){
      for (int j = 1 ; j < 31103; ++j){
        
        //Cross reference found
        if (refs.getString(str(j)) != null){
          ++verses[j].referenced;
          verses[i].crossRef.put(str(j), refs.getString(str(j)));
        }
      }
    }
  }
 }
 
 
 
 
 
 
 
