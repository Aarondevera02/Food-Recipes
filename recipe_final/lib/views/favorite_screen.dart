import 'package:flutter/material.dart';
import 'package:recipe_final/models/recipe_model.dart';
import 'package:recipe_final/views/recipe_view_screen.dart';


class FavoriteScreen extends StatefulWidget {
  final List<RecipeModel> favoriteRecipes;

  FavoriteScreen({required this.favoriteRecipes});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    List<RecipeModel> filteredRecipes =
        widget.favoriteRecipes.where((recipe) => recipe.isFavorite).toList();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Favorite Recipes'),
        backgroundColor: Colors.brown.shade400,
      ),
      body: Container(
        color: Colors.brown.shade300,
        child: GridView.builder(
          padding: const EdgeInsets.all(10),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 3 / 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: filteredRecipes.length,
          itemBuilder: (ctx, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeView(
                      postUrl: filteredRecipes[index].url,
                    ),
                  ),
                );
              },
              child: GridTile(
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: NetworkImage(filteredRecipes[index].image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 1,
                      right: 1,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                          filteredRecipes[index].toggleFavorite();
                          filteredRecipes[index].saveFavoriteStatus();
                          });
                      
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                filteredRecipes[index].label,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}