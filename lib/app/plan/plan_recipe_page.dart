import 'package:flutter/material.dart';
import 'package:mademe/services/plan_recipe_service.dart';
import 'package:provider/provider.dart';

class PlanRecipePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prpService = Provider.of<PlanRecipeService>(context, listen: false);
    return Container(
      child: StreamBuilder<List<PlanRecipe>>(
        stream: prpService.planListStream(),
        builder:
            (BuildContext context, AsyncSnapshot<List<PlanRecipe>> snapshot) {
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
    );
  }
}
