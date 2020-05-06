import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:mademe/services/plan_service.dart';
import 'package:provider/provider.dart';

class PlanHomePage extends StatefulWidget {
  PlanHomePage({Key key, this.plan}) : super(key: key);
  final Plan plan;

  @override
  _PlanHomePageState createState() => _PlanHomePageState();
}

class _PlanHomePageState extends State<PlanHomePage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE6DBDD),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.plan.title,
            ),
            Text(
              'at tab $selectedIndex',
            ),
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
        selectedIndex: selectedIndex,
        onSelectTab: (index) {
          setState(() {
            selectedIndex = index;
          });
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
