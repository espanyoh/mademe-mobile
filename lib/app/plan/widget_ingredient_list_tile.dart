import 'package:flutter/material.dart';

class PlanIngredientTile extends StatelessWidget {
  final String id;
  final String recipeID;
  final String title;
  final String description;
  PlanIngredientTile(
      {@required this.id,
      @required this.recipeID,
      @required this.title,
      @required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
        decoration: BoxDecoration(
            color: Color(0xffFFEEE0), borderRadius: BorderRadius.circular(15)),
        // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 17,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 130.0,
                  child: Text(title,
                      style: TextStyle(color: Color(0xffFC9535), fontSize: 14),
                      overflow: TextOverflow.ellipsis),
                ),
                SizedBox(
                  height: 2,
                ),
                Container(
                  width: 130.0,
                  child: Text(
                    description,
                    style: TextStyle(fontSize: 11),
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
            Spacer(),
            Container(
              child: IconButton(
                icon: Icon(Icons.remove_circle),
                color: Colors.redAccent,
                onPressed: () {
                  print('try to delete');
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
