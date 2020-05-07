import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:mademe/services/navigation_bar_provider.dart';
import 'package:mademe/services/plan_ingredient_service.dart';
import 'package:mademe/services/plan_recipe_service.dart';
import 'package:mademe/services/plan_service.dart';
import 'package:provider/provider.dart';

class PlanHomePage extends StatelessWidget {
  PlanHomePage({Key key, this.plan}) : super(key: key);
  final Plan plan;

  @override
  Widget build(BuildContext context) {
    //print('......build _PlanHomePageState - later check when rebuild');
    final pidService =
        Provider.of<PlanIngredientService>(context, listen: false);
    final prpService = Provider.of<PlanRecipeService>(context, listen: false);

    // Won't set listen to false since rebuild is needed
    final navigatorBar = Provider.of<BottomNavigationBarProvider>(context);

    return Scaffold(
      backgroundColor: Color(0xFFE6DBDD),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            navigatorBar.currentIndex == 1
                ? Container(
                    child: StreamBuilder<List<PlanIngredient>>(
                      stream: pidService.planListStream(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<PlanIngredient>> snapshot) {
                        if (snapshot.hasError)
                          return new Text('Error......: ${snapshot.error}');
                        if (!snapshot.hasData) return new Text('Loading....');
                        return new ListView(
                          shrinkWrap: true,
                          children: snapshot.data.map((PlanIngredient doc) {
                            return new Card(
                              child: ListTile(
                                leading: doc.photos.length > 0
                                    ? Image.network(
                                        doc.photos[0],
                                      )
                                    : Text('WAIT FOR IMAGE'),
                                title: Text(doc.title),
                                subtitle: Text(doc.description),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  )
                : Text(''),
            navigatorBar.currentIndex == 0
                ? Container(
                    child: StreamBuilder<List<PlanRecipe>>(
                      stream: prpService.planListStream(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<PlanRecipe>> snapshot) {
                        if (snapshot.hasError)
                          return new Text('Error......: ${snapshot.error}');
                        if (!snapshot.hasData) return new Text('Loading....');
                        return new ListView(
                          shrinkWrap: true,
                          children: snapshot.data.map((PlanRecipe doc) {
                            return new Card(
                              child: ListTile(
                                leading: doc.photos.length > 0
                                    ? Image.network(
                                        doc.photos[0],
                                      )
                                    : Text('WAIT FOR IMAGE'),
                                title: Text(doc.title),
                                subtitle: Text(doc.description),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  )
                : Text(''),
          ],
        ),
      ),
      bottomNavigationBar: FFNavigationBar(
        theme: FFNavigationBarTheme(
          barBackgroundColor: Colors.white,
          selectedItemBorderColor: Colors.transparent,
          selectedItemBackgroundColor: Colors.green,
          selectedItemIconColor: Colors.white,
          selectedItemLabelColor: Colors.black,
          showSelectedItemShadow: false,
          barHeight: 70,
        ),
        selectedIndex: navigatorBar.currentIndex,
        onSelectTab: (index) {
          // setState(() {
          //   selectedIndex = index;
          // });
          navigatorBar.currentIndex = index;
        },
        items: [
          FFNavigationBarItem(
            iconData: Icons.book,
            label: 'Recipe',
          ),
          FFNavigationBarItem(
            iconData: Icons.kitchen,
            label: 'Ingredient',
            selectedBackgroundColor: Colors.red,
          ),
        ],
      ),
    );
  }
}
