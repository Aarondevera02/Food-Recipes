import 'package:shared_preferences/shared_preferences.dart';

class RecipeModel {
  String label;
  String image;
  String source;
  String url;
  bool isFavorite;

  RecipeModel({
    required this.url,
    required this.source,
    required this.image,
    required this.label,
    this.isFavorite = false,
  });

   Future<void> saveFavoriteStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(url, isFavorite);
  }

  Future<void> loadFavoriteStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? loadedFavorite = prefs.getBool(url);
    if (loadedFavorite != null) {
      isFavorite = loadedFavorite;
    }
  }
  factory RecipeModel.fromMap(Map<String, dynamic> parsedJson) {
    RecipeModel recipeModel = RecipeModel(
      url: parsedJson["url"],
      label: parsedJson["label"],
      image: parsedJson["image"],
      source: parsedJson["source"],
    );
    recipeModel.loadFavoriteStatus();
    return recipeModel;
  }

 void toggleFavorite() async {
    isFavorite = !isFavorite;
    await saveFavoriteStatus();
  }

}