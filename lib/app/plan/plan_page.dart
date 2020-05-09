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
      // backgroundColor: Color(0xFFE6DBDD),
      backgroundColor: Color(0xFFE6DBDD),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Find Your next meal",
                        style: TextStyle(
                            color: Colors.black54.withOpacity(0.8),
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        plan.title,
                        style: TextStyle(
                            color: Colors.black26.withOpacity(0.8),
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ],
              ),
              navigatorBar.currentIndex == 1 ? PlanIngredientPage() : Text(''),
              navigatorBar.currentIndex == 0 ? PlanRecipePage() : Text(''),
            ],
          ),
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
