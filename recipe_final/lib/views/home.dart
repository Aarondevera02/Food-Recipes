import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recipe_final/models/recipe_model.dart';
import 'package:recipe_final/views/recipe_tile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'favorite_screen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<RecipeModel> recipes = [];
  final recipeController = TextEditingController();
  bool isPlaceholderVisible = true; 

 Future<void> getRecipes(String query) async {
  String url =
      "https://api.edamam.com/search?q=$query&app_id=924e7ed8&app_key=59360cc171fd1e5c2f509d40b42cd5b3";

  var response = await http.get(Uri.parse(url));
  Map<String, dynamic> jsonData = jsonDecode(response.body);
  List<RecipeModel> newRecipes = [];

  SharedPreferences prefs = await SharedPreferences.getInstance();

 jsonData["hits"].forEach((element) {
    RecipeModel recipeModel = RecipeModel.fromMap(element["recipe"]);
    bool isFavorite = prefs.getBool(recipeModel.url) ?? false;
    recipeModel.isFavorite = isFavorite;
    newRecipes.add(recipeModel);
  });

  setState(() {
    recipes = newRecipes;
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown.shade400,
        centerTitle: true,
        title: RichText(
          text: const TextSpan(
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                text: 'Foo',
                style: TextStyle(color: Colors.brown),
              ),
              TextSpan(
                text: 'dies',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoriteScreen(favoriteRecipes: recipes),
                ),
              );
            },
            icon: Icon(Icons.favorite),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.brown.shade300,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text(
                      "What food do you want to cook?",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Input the ingredients you have and we will show the best recipes for you.",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: recipeController,
                                  onChanged: (value) {
                                    setState(() {
                                      isPlaceholderVisible = value.isEmpty;
                                      if (value.isEmpty) {
                                        recipes = [];
                                      }
                                    });
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Input Ingredient",
                                    hintStyle: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white.withOpacity(0.5),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                      vertical: 12.0,
                                    ),
                                    isCollapsed: true,
                                    border: const OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white)),
                                  ),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),        
                            ],
                          ),
                          const SizedBox(height: 8),
                           ElevatedButton(onPressed: (){
                      setState(() {
                         if (recipeController.text.isNotEmpty) {
                                getRecipes(recipeController.text);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Please Input Ingridient')));
                              }
                      });
                    }, child: Text('Search',style:  TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),),
                        style: ElevatedButton.styleFrom(
                        primary: Colors.brown,
                        elevation: 4,
                        ),),
                        ],
                      ),
                    ),            
                    if (isPlaceholderVisible)
                      const SizedBox(height: 50),
                    if (isPlaceholderVisible)
                      const Text(
                        "Input ingredients",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding:const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(),
                    child: GridView.builder(
                      gridDelegate:const SliverGridDelegateWithMaxCrossAxisExtent(
                        mainAxisSpacing: 2,
                        maxCrossAxisExtent: 200.0,
                      ),
                      shrinkWrap: true,
                      physics:const ClampingScrollPhysics(),
                      itemCount: recipes.length,
                      itemBuilder: (context, index) {
                        return GridTile(
                          child: RecipeTile(
                            recipe: recipes[index],
                            onFavoriteChanged: (isFavorite) {
                              setState(() {
                                recipes[index].toggleFavorite();
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
