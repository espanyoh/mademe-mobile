import 'package:flutter/material.dart';
import 'package:mademe/app/plan/widget_plan_list_tile.dart';
import 'package:mademe/app/plan/widget_plan_search_tile.dart';
import 'package:mademe/services/plan_recipe_service.dart';
import 'package:mademe/services/search_recipe_service.dart';
import 'package:provider/provider.dart';

class PlanRecipePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final planRecipeService =
        Provider.of<PlanRecipeService>(context, listen: false);
    final searchRecipeService =
        Provider.of<SearchRecipeService>(context, listen: false);
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _buildSearchBar(),
          _buildSearchResult(searchRecipeService),
          _buildListedTitle(),
          _buildListedRecipe(planRecipeService),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24),
      height: 50,
      decoration: BoxDecoration(
          color: Color(0xffEFEFEF), borderRadius: BorderRadius.circular(14)),
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
    );
  }

  Widget _buildSearchResult(SearchRecipeService service) {
    return Container(
      height: 220.0,
      child: FutureBuilder<List<Recipe>>(
          future: service.getRecipes(),
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
                return PlanSearchTile(
                  title: snapshot.data[index].title,
                  description: snapshot.data[index].description,
                  imgAssetPath: snapshot.data[index].photos,
                );
              },
            );
          }),
    );
  }

  Widget _buildListedTitle() {
    return Row(
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
    );
  }

  Widget _buildListedRecipe(PlanRecipeService service) {
    return Column(
      children: <Widget>[
        StreamBuilder<List<PlanRecipe>>(
          stream: service.planListStream(),
          builder:
              (BuildContext context, AsyncSnapshot<List<PlanRecipe>> snapshot) {
            if (snapshot.hasError)
              return new Text('Error......: ${snapshot.error}');
            if (!snapshot.hasData) return new Text('Loading....');
            // return
            // ListView.builder(
            //     padding: EdgeInsets.zero,
            //     shrinkWrap: true,
            //     itemCount: snapshot.data.length,
            //     itemBuilder: (BuildContext ctxt, int index) {
            //       return Text('snapshot.data[index].title');
            //     });
            // Container(
            //   color: Colors.amber,
            //   child: Text('yoh'),
            // );

            return new ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.vertical,
              children: snapshot.data.map((PlanRecipe doc) {
                //change name here
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
    );
  }
}
