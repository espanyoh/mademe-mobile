import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mademe/models/plan_recipe_model.dart';
import 'package:mademe/models/recipe_preview_model.dart';
import 'package:mademe/utilities/log.dart';

class PlanRecipeService {
  PlanRecipeService({@required this.uid}) : assert(uid != null);
  final String uid;

  Stream<List<PlanRecipe>> streamRecipes(String planID) {
    final planCollection =
        Firestore.instance.collection('profiles/$uid/plans/$planID/recipes');

    return planCollection.snapshots().map((snapshot) {
      return snapshot.documents.map((doc) {
        return PlanRecipe.fromSnapshot(doc);
      }).toList();
    }).asBroadcastStream();
  }

  Future<void> addRecipe(String planID, RecipePreviewModel recipe) async {
    var rawRecipe =
        Firestore.instance.collection('recipes').document(recipe.id);
    List ingredientList = [];
    await rawRecipe.get().then((doc) {
      Firestore.instance
          .collection('profiles/$uid/plans/$planID/recipes')
          .add(doc.data);
      ingredientList = doc.data['ingredients'] as List;
    }).catchError((onError) {
      printT(onError);
    });

    ingredientList.forEach((ingredient) async {
      Map ingredientMap = ingredient as Map;
      var title = ingredientMap['ingredientName'];
      var amount = ingredientMap['amount'];

      var planIngredient = await Firestore.instance
          .collection('profiles/$uid/plans/$planID/ingredients')
          .document(title)
          .get();

      if (planIngredient.exists) {
        var recipeMap = {
          recipe.id: {"title": recipe.title, "amount": amount}
        };
        Firestore.instance
            .collection('profiles/$uid/plans/$planID/ingredients')
            .document(title)
            .updateData({
          "recipes": FieldValue.arrayUnion([recipeMap]),
          "recipeIDs": FieldValue.arrayUnion([recipe.id]),
        });
      } else {
        var raw = await Firestore.instance
            .collection('ingredients')
            .document(title)
            .get();
        var obj = raw.data;
        var recipeMap = {
          recipe.id: {"title": recipe.title, "amount": amount}
        };
        if (obj == null) {
          printE('Please add this ingredient to its collection: $title');
          return;
        }

        obj.addAll({
          "recipes": [recipeMap],
          "recipeIDs": [recipe.id],
        });
        Firestore.instance
            .collection('profiles/$uid/plans/$planID/ingredients')
            .document(title)
            .setData(obj);
      }
    });
  }

  void removeRecipe(String planID, String planRecipeID, String recipeID) async {
    //print("UID: $uid, PlanID: $planID, planRecipeID:$planRecipeID");
    await Firestore.instance
        .collection('profiles/$uid/plans/$planID/recipes')
        .document(planRecipeID)
        .delete();
    var recipes = await Firestore.instance
        .collection('profiles/$uid/plans/$planID/ingredients')
        .where("recipeIDs", arrayContains: recipeID)
        .getDocuments();
    recipes.documents.forEach((element) {
      List recipes = element.data['recipeIDs'];
      if (recipes.length <= 1) {
        Firestore.instance
            .collection('profiles/$uid/plans/$planID/ingredients')
            .document(element.documentID)
            .delete();
      } else {
        Firestore.instance
            .collection('profiles/$uid/plans/$planID/ingredients')
            .document(element.documentID)
            .updateData({
          "recipeIDs": FieldValue.arrayRemove([recipeID])
        });
      }
    });
  }
}
