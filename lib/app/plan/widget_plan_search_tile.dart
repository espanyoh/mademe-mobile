import 'package:flutter/material.dart';
import 'package:mademe/services/plan_recipe_service.dart';
import 'package:mademe/services/plan_service.dart';
import 'package:mademe/services/search_recipe_service.dart';
import 'package:provider/provider.dart';

class PlanSearchTile extends StatelessWidget {
  final Recipe recipe;
  PlanSearchTile({@required this.recipe});

  @override
  Widget build(BuildContext context) {
    final planRecipeService =
        Provider.of<PlanRecipeService>(context, listen: false);
    final planService = Provider.of<PlanService>(context, listen: false);

    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
      padding: EdgeInsets.only(top: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                width: 160.0,
                decoration: BoxDecoration(
                  color: Color(0xFF32A060),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 30.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Hero(
                          tag: 'heroID-${recipe.title}',
                          child: recipe.photos.length > 0
                              ? Image.network(
                                  recipe.photos[0],
                                  fit: BoxFit.fitHeight,
                                  height: 160.0,
                                  width: 160.0,
                                )
                              : Text('WAIT FOR IMAGE'),
                        ),
                      ),
                      Positioned(
                        left: 10.0,
                        bottom: 10.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              recipe.title,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w600,
                                shadows: <Shadow>[
                                  Shadow(
                                    offset: Offset(2.0, 2.0),
                                    blurRadius: 4.0,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 3.0,
                right: 0.0,
                child: RawMaterialButton(
                  // padding: EdgeInsets.only(right: 5.0),
                  shape: CircleBorder(),
                  elevation: 0.1,
                  fillColor: Colors.black,
                  child: Icon(
                    Icons.add_shopping_cart,
                    color: Colors.white,
                    size: 20.0,
                  ),
                  onPressed: () {
                    planRecipeService.addRecipe(planService.current.id, recipe);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
