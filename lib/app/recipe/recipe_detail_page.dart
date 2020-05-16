import 'package:flutter/material.dart';
import 'package:mademe/services/search_recipe_service.dart';

import 'recipe_ingredient_tile.dart';

class RecipeDetail extends StatelessWidget {
  final RecipePreview recipePreview;
  RecipeDetail({@required this.recipePreview});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE6DBDD), //0xFF433C3E
      body: Column(
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
                    recipePreview.photos[0],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                left: 10.0,
                top: 40.0,
                child: RawMaterialButton(
                  shape: CircleBorder(),
                  elevation: 0.1,
                  fillColor: Colors.brown,
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 16.0,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
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
                width: MediaQuery.of(context).size.width - 80,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      recipePreview.title,
                      style: TextStyle(
                        color: Colors.brown,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      recipePreview.description,
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
          Row(
            children: <Widget>[
              SizedBox(width: 30.0),
              Text('Ingredients',
                  style: TextStyle(
                    color: Colors.brown,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ))
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: 30.0,
              ),
              Container(
                color: Colors.blueAccent,
                height: 80.0,
                width: MediaQuery.of(context).size.width - 80,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return RecipeIngredientTile(
                      photo:
                          "https://www.verywellfamily.com/thmb/xPbyHn675F8_Tu-JWP6otQD5Uhs=/3995x2996/smart/filters:no_upscale()/GettyImages-149107499MultibitsPhotolibraryGarlic-56a0b9733df78cafdaa461e1.jpg",
                      title: "กระเทียม",
                    );
                  },
                  //   itemBuilder: (Builder) {
                  //   return RecipeIngredientTile(
                  //     photo: "https://www.verywellfamily.com/thmb/xPbyHn675F8_Tu-JWP6otQD5Uhs=/3995x2996/smart/filters:no_upscale()/GettyImages-149107499MultibitsPhotolibraryGarlic-56a0b9733df78cafdaa461e1.jpg",
                  //     title: "กระเทียม",
                  //   );
                  // }
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
