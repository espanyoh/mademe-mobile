import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:mademe/app/plan/plan_ingredient_page.dart';
import 'package:mademe/app/plan/plan_recipe_page.dart';
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
    // print('......build _PlanHomePageState - later check when rebuild');

    // Won't set listen to false since rebuild is needed
    final navigatorBar = Provider.of<BottomNavigationBarProvider>(context);

    return Scaffold(
      backgroundColor: Color(0xFFE6DBDD),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[Text(plan.title)],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            navigatorBar.currentIndex == 1 ? PlanIngredientPage() : Text(''),
            navigatorBar.currentIndex == 0 ? PlanRecipePage() : Text(''),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(navigatorBar),
    );
  }

  Widget _buildBottomNavBar(BottomNavigationBarProvider navigatorBar) {
    return FFNavigationBar(
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
    );
  }
}
