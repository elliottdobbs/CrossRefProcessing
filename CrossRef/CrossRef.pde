import java.lang.String;
import java.util.Map;
import processing.svg.PGraphicsSVG;
int numberOfPoints = 31102;
int circleRad = 5950;

JSONObject json;
Verse[] verses;
PGraphics pg;

void setup() {
  size(12000, 12000);
  pg = createGraphics(12000, 12000);
  
  verses = new Verse[31103];
  for (int i = 1; i < 31103; i++){
    verses[i] = new Verse();
  }
  
  loadData();
  
  String prevBook = "", currentBook;
  for (int i = 1; i <= 31102; ++i){
      currentBook = verses[i].name.substring(0, 3);
      if (!currentBook.equals(prevBook)){
        print(currentBook , "\n");
        prevBook = currentBook;
        drawOnce(currentBook);
        String saveName = currentBook + ".jpg";
        save(saveName);
        pg.beginDraw();
        pg.clear();
        pg.endDraw();
      }
  }
}

void drawOnce(String n) {
  background(255);
    
  pg.beginDraw();
  for (int i = 1; i < 31103; i++){
    fill(0);
    pg.point((float)(verses[i].x), (float)(verses[i].y));
    
    if (i % 1000 == 0){
      print("Drawing Reference Lines for each Verse: ", str(i), "\n"); 
    }
    
    if (verses[i].name.substring(0, 3).equals(n)){
    pg.stroke(0, 0, 0, 8);
      for (Map.Entry howdy : verses[i].crossRef.entrySet()){
        pg.line((float)verses[i].x, (float)verses[i].y, (float)verses[Integer.parseInt(howdy.getKey().toString())].x, (float)verses[Integer.parseInt(howdy.getKey().toString())].y);
      }
    }
    
  }
  
  pg.endDraw();
  image(pg, 0, 0); 
  //String saveName = n + ".jpg";
  //save(saveName);
}
 void loadData() {
  // Load JSON file
  json = loadJSONObject("fullJson.json");

  for (int i = 1; i < 31103; ++i){
    if (i % 1000 == 0){
      print("Getting verses: ", str(i), "\n"); 
    }
    JSONObject verseData = json.getJSONObject(str(i));
    verses[i].name = verseData.getString("v");
    verses[i].x = cos(i * 2 * PI/numberOfPoints)*circleRad + width/2;
    verses[i].y = sin(i * 2 * PI/numberOfPoints)*circleRad + height/2;

    JSONObject refs = verseData.getJSONObject("r");

    if (verseData.getJSONObject("r") != null){
      for (int j = 1 ; j < 31103; ++j){
        
        if (refs.getString(str(j)) != null){
           //print("\t", refs.getString(str(j)), "\n");
           verses[i].crossRef.put(str(j), refs.getString(str(j)));
        }
      }
    }
    
    //verses[i] = tempVerse;
    //tempVerse.crossRef.clear();
  }
 }
 
 
 
 
 
 
 
