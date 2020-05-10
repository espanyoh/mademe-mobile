import 'package:mademe/app/home/new_drawer.dart';
import 'package:mademe/app/plan/plan_page.dart';
import 'package:mademe/services/navigation_bar_provider.dart';
import 'package:mademe/services/plan_ingredient_service.dart';
import 'package:mademe/services/plan_recipe_service.dart';
import 'package:mademe/services/plan_service.dart';
import 'package:flutter/material.dart';
import 'package:mademe/services/search_ingredient_service.dart';
import 'package:mademe/services/search_recipe_service.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: NewDrawer(),
      backgroundColor: Color(0xFFE6DBDD),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 60.0, left: 20.0),
                child: GestureDetector(
                  child: Container(
                    child: Icon(
                      Icons.menu,
                      color: Colors.black,
                    ),
                  ),
                  onTap: () => _scaffoldKey.currentState.openDrawer(),
                ),
              ),
            ],
          ),
          //_buildPlanList(context: context),
          _buildPlan(context: context),
          // Expanded(
          //   child: PlanHomePage(),
          // ),
        ],
      ),
    );
  }
}

Widget _buildPlanList({BuildContext context}) {
  final planService = Provider.of<PlanService>(context, listen: false);
  return StreamBuilder<List<Plan>>(
    stream: planService.planListStream(),
    builder: (BuildContext context, AsyncSnapshot<List<Plan>> plan) {
      if (plan.hasError) return new Text('Error......: ${plan.error}');
      if (!plan.hasData) return new Text('Loading....');
      return new ListView(
        shrinkWrap: true,
        children: plan.data.map((Plan doc) {
          return new ListTile(
            title: new Text(doc.title),
            subtitle: new Text(doc.description),
          );
        }).toList(),
      );
    },
  );
}

Widget _buildPlan({BuildContext context}) {
  final planService = Provider.of<PlanService>(context, listen: false);
  return StreamBuilder<Plan>(
    stream: planService.planStream(),
    builder: (BuildContext context, AsyncSnapshot<Plan> plan) {
      if (plan.hasError) return new Text('Error.....: ${plan.error}');
      if (!plan.hasData) return new Text('Loading....');
      print('..rebuild plan!');

      return Expanded(
        child: MultiProvider(
          providers: [
            Provider<SearchRecipeService>(
                create: (_) => new SearchRecipeService()),
            Provider<SearchIngredientService>(
                create: (_) => new SearchIngredientService()),
            Provider<PlanIngredientService>(
                create: (BuildContext context) => PlanIngredientService(
                    uid: plan.data.uid, planID: plan.data.id)),
            Provider<PlanRecipeService>(
                create: (_) => PlanRecipeService(
                    uid: plan.data.uid, planID: plan.data.id)),
            ChangeNotifierProvider<BottomNavigationBarProvider>(
                create: (BuildContext context) =>
                    BottomNavigationBarProvider()),
          ],
          child: PlanHomePage(
            plan: plan.data,
          ),
        ),
      );
    },
  );
}
