import 'package:flutter/material.dart';
import 'package:mademe/services/plan_ingredient_service.dart';
import 'package:provider/provider.dart';

class PlanIngredientPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pidService =
        Provider.of<PlanIngredientService>(context, listen: false);
    return Container(
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
    );
  }
}
