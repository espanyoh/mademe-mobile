import 'dart:async';

import 'package:mademe/app/home/about_page.dart';
import 'package:mademe/app/home/new_drawer.dart';
import 'package:mademe/services/plan_service.dart';
import 'package:mademe/services/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<FirebaseAuthService>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e);
    }
  }

  Future<void> _onAbout(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => AboutPage(),
      ),
    );
  }

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
          _buildPlanList(context: context),
          _buildPlan(context: context),
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
      return Text('Active plan:' + plan.data.title);
    },
  );
}
