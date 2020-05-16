import 'package:flutter/material.dart';

class RecipeIngredientTile extends StatelessWidget {
  final String photo;
  final String title;

  RecipeIngredientTile({@required this.photo, @required this.title});

  @override
  Widget build(BuildContext context) {
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
                width: 60.0,
                decoration: BoxDecoration(
                  color: Color(0xFF32A060),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Hero(
                          tag: 'heroID-$title',
                          child: Image.network(
                            photo,
                            fit: BoxFit.fitHeight,
                            height: 60.0,
                            width: 60.0,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 10.0,
                        bottom: 10.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              title,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 7.0,
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
            ],
          ),
        ],
      ),
    );
  }
}
