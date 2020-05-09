import 'package:flutter/material.dart';
import 'package:mademe/app/plan/plan_recipe_tile_widget.dart';
import 'package:mademe/app/plan/recipe_tile_widget.dart';
import 'package:mademe/services/plan_recipe_service.dart';
import 'package:mademe/services/search_recipe_service.dart';
import 'package:provider/provider.dart';

class PlanRecipePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prpService = Provider.of<PlanRecipeService>(context, listen: false);
    final searchRecipeService =
        Provider.of<SearchRecipeService>(context, listen: false);
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(),
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
            // Container(
            //   // color: Colors.blueAccent,
            //   height: 205.0,
            //   child: StreamBuilder<List<PlanRecipe>>(
            //     stream: prpService.planListStream(),
            //     builder: (BuildContext context,
            //         AsyncSnapshot<List<PlanRecipe>> snapshot) {
            //       if (snapshot.hasError)
            //         return new Text('Error......: ${snapshot.error}');
            //       if (!snapshot.hasData) return new Text('Loading....');
            //       return new ListView(
            //         shrinkWrap: true,
            //         physics: ClampingScrollPhysics(),
            //         scrollDirection: Axis.horizontal,
            //         children: snapshot.data.map((PlanRecipe doc) {
            //           return ReceipeTile(
            //             title: doc.title,
            //             description: doc.description,
            //             imgAssetPath: doc.photos,
            //           );
            //           // return Text(doc.title);
            //         }).toList(),
            //       );
            //     },
            //   ),
            // ),
            Container(
              height: 220.0,
              child: FutureBuilder<List<Recipe>>(
                  future: searchRecipeService.getRecipes(),
                  builder: (context, AsyncSnapshot<List<Recipe>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text('waiting');
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        // return Text("1");
                        return ReceipeTile(
                          title: snapshot.data[index].title,
                          description: snapshot.data[index].description,
                          imgAssetPath: snapshot.data[index].photos,
                        );
                      },
                    );
                  }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Queue",
                      style: TextStyle(
                          color: Colors.black54.withOpacity(0.8),
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              // color: Colors.amber,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  StreamBuilder<List<PlanRecipe>>(
                    stream: prpService.planListStream(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<PlanRecipe>> snapshot) {
                      if (snapshot.hasError)
                        return new Text('Error......: ${snapshot.error}');
                      if (!snapshot.hasData) return new Text('Loading....');
                      return new ListView(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        children: snapshot.data.map((PlanRecipe doc) {
                          return PlanReceipeTile(
                            title: doc.title,
                            description: doc.description,
                            imgAssetPath: doc.photos,
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
