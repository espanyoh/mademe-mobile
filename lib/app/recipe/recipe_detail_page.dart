import 'package:flutter/material.dart';
import 'package:mademe/models/recipe_detail_model.dart';

import 'recipe_ingredient_tile.dart';

class RecipeDetail extends StatelessWidget {
  final RecipeDetailModel recipeDetail;
  RecipeDetail({@required this.recipeDetail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE6DBDD), //0xFF433C3E
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 130.0, left: 10.0),
        child: FloatingActionButton(
            backgroundColor: Colors.brown,
            mini: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              size: 20.0,
            )),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      body: Container(
        height: MediaQuery.of(context).size.height - 30,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 40.0),
                    height: 300.0,
                    alignment: Alignment(0.0, 0.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.network(
                        recipeDetail.photos[0],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 5.0,
                    right: 30.0,
                    child: RawMaterialButton(
                      shape: CircleBorder(),
                      elevation: 0.1,
                      fillColor: Colors.green,
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.white,
                        size: 30.0,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  )
                ],
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(width: 30.0),
                  Container(
                    width: MediaQuery.of(context).size.width - 60,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          recipeDetail.title,
                          style: TextStyle(
                            color: Colors.brown,
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          recipeDetail.description,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w400,
                          ),
                          overflow: TextOverflow.clip,
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              _buildTitle('Ingredients'),
              SizedBox(height: 15.0),
              _buildIngredientPanel(context),
              SizedBox(height: 15.0),
              _buildTitle('Instructions'),
              SizedBox(height: 15.0),
              _buildInstructionPanel(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Row(
      children: <Widget>[
        SizedBox(width: 30.0),
        Text(title,
            style: TextStyle(
              color: Colors.brown,
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ))
      ],
    );
  }

  Widget _buildIngredientPanel(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 30.0,
        ),
        Container(
          // color: Colors.blue[50],
          height: 60.0,
          width: MediaQuery.of(context).size.width - 60,
          child: ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: recipeDetail.ingredients.length,
            itemBuilder: (context, index) {
              return RecipeIngredientTile(
                ingredient: recipeDetail.ingredients[index],
              );
            },
          ),
        )
      ],
    );
  }

  Widget _buildInstructionPanel(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: recipeDetail.instructions.length,
      itemBuilder: (context, index) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: 30.0),
            Text(
              recipeDetail.instructions[index].seq.toString() + '. ',
              style: TextStyle(
                color: Colors.black26,
                fontSize: 15.0,
                fontWeight: FontWeight.w900,
              ),
              overflow: TextOverflow.clip,
            ),
            Container(
              width: MediaQuery.of(context).size.width - 100,
              child: Text(
                recipeDetail.instructions[index].detail ?? '',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w400,
                ),
                overflow: TextOverflow.clip,
              ),
            ),
          ],
        );
      },
    );
  }
}
