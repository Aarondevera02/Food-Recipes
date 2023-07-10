import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipe_final/views/recipe_view_screen.dart';

import '../models/recipe_model.dart';


class RecipeTile extends StatefulWidget {
  final RecipeModel recipe;
  final ValueChanged<bool> onFavoriteChanged;

  RecipeTile({required this.recipe, required this.onFavoriteChanged});

  @override
  _RecipeTileState createState() => _RecipeTileState();
}

class _RecipeTileState extends State<RecipeTile> {
   bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.recipe.isFavorite;
  }
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        GestureDetector(
          onTap: () {
            print(widget.recipe.url + " this is what we are going to see");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecipeView(
                  postUrl: widget.recipe.url,
                ),
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.all(5),
            child: Stack(
              children: [
                Image.network(
                  widget.recipe.image,
                  height: 180,
                  width: 300,
                  fit: BoxFit.cover,
                ),
                Container(
                  alignment: Alignment.bottomLeft,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white30, Colors.white],
                      begin: FractionalOffset.centerRight,
                      end: FractionalOffset.centerLeft,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.recipe.label,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.recipe.source,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Color.fromARGB(255, 133, 132, 132),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 1,
                  child: IconButton(
                    onPressed: () async {
                      setState(() {
                        widget.recipe.toggleFavorite();
                      });
                      await widget.recipe.saveFavoriteStatus();
                    },
                    icon: Icon(
                      widget.recipe.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
