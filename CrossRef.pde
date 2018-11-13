import java.lang.String;
import java.util.Map;
int numberOfPoints = 31102;
int circleRad = 4000;

JSONObject json;
Verse[] verses;

void setup() {
  size(8100, 8100);
  verses = new Verse[31103];
  for (int i = 1; i < 31103; i++){
    verses[i] = new Verse();
  }
  loadData();
  drawOnce();
}

void drawOnce() {
  background(255);
    
  for (int i = 1; i < 31103; i++){
    fill(0);
    point((float)(verses[i].x), (float)(verses[i].y));
    if (i % 1000 == 0){
      print("Howdy2: ", str(i), "\n"); 
    }
    stroke(random(255), random(255), random(255), 8);
    for (Map.Entry howdy : verses[i].crossRef.entrySet()){
      //int ((float)verses[i].x, " : ", (float)verses[i].y, " : ", (float)verses[Integer.parseInt(howdy.getKey().toString())].x, " : ", (float)verses[Integer.parseInt(howdy.getKey().toString())].y, "\n");
      line((float)verses[i].x, (float)verses[i].y, (float)verses[Integer.parseInt(howdy.getKey().toString())].x, (float)verses[Integer.parseInt(howdy.getKey().toString())].y);
    }
  }
  
  save("crossRef.jpg");
}
 void loadData() {
  // Load JSON file
  json = loadJSONObject("fullJson.json");
  Verse tempVerse = new Verse();

  for (int i = 1; i < 31103; ++i){
    if (i % 1000 == 0){
      print("Howdy: ", str(i), "\n"); 
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
 
 
 
 
 
 
 
