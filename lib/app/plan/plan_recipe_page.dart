import 'package:flutter/material.dart';
import 'package:mademe/app/plan/recipe_tile_widget.dart';
import 'package:mademe/services/plan_recipe_service.dart';
import 'package:provider/provider.dart';

class PlanRecipePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prpService = Provider.of<PlanRecipeService>(context, listen: false);
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            height: 50,
            decoration: BoxDecoration(
                color: Color(0xffEFEFEF),
                borderRadius: BorderRadius.circular(14)),
            child: Row(
              children: <Widget>[
                Icon(Icons.search),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Search",
                  style: TextStyle(color: Colors.grey, fontSize: 19),
                )
              ],
            ),
          ),
          Container(
            height: 500.0,
            child: StreamBuilder<List<PlanRecipe>>(
              stream: prpService.planListStream(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<PlanRecipe>> snapshot) {
                if (snapshot.hasError)
                  return new Text('Error......: ${snapshot.error}');
                if (!snapshot.hasData) return new Text('Loading....');
                return new ListView(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  children: snapshot.data.map((PlanRecipe doc) {
                    return ReceipeTile(
                      title: doc.title,
                      description: doc.description,
                      imgAssetPath: doc.photos,
                    );
                    // return Text(doc.title);
                  }).toList(),
                );
              },
            ),
          ),
          // ReceipeTile(
          //   title: "yoh",
          //   description: "desc",
          //   imgAssetPath: [
          //     "https://image.makewebeasy.net/makeweb/0/RuMJ6hQav/00ProductPhoto/Nami.jpg"
          //   ],
          // )
        ],
      ),
    );
  }
}
