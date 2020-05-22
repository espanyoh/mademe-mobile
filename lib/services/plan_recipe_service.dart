import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
    rawRecipe.get().then((doc) {
      Firestore.instance
          .collection('profiles/$uid/plans/$planID/recipes')
          .add(doc.data);
    }).catchError((onError) {
      printT(onError);
    });

    recipe.ingredientIDs.forEach((ingredient) async {
      var planIngredient = await Firestore.instance
          .collection('profiles/$uid/plans/$planID/ingredients')
          .document(ingredient)
          .get();

      if (planIngredient.exists) {
        var recipeMap = {
          recipe.id: {"title": recipe.title, "amount": "some number"}
        };
        Firestore.instance
            .collection('profiles/$uid/plans/$planID/ingredients')
            .document(ingredient)
            .updateData({
          "recipes": FieldValue.arrayUnion([recipeMap]),
          "recipeIDs": FieldValue.arrayUnion([recipe.id]),
        });
      } else {
        var raw = await Firestore.instance
            .collection('ingredients')
            .document(ingredient)
            .get();
        var obj = raw.data;
        var recipeMap = {
          recipe.id: {"title": recipe.title, "amount": "some number"}
        };
        obj.addAll({
          "recipes": [recipeMap],
          "recipeIDs": [recipe.id],
        });
        Firestore.instance
            .collection('profiles/$uid/plans/$planID/ingredients')
            .document(ingredient)
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

class PlanRecipe {
  final String id;
  final String recipeID;
  final String title;
  final String description;
  final List<String> photos;
  final String status;

  PlanRecipe(this.id, this.recipeID, this.title, this.description, this.photos,
      this.status);

  // factory PlanRecipe.fromMap(Map<String, dynamic> data) {
  //   if (data == null) {
  //     return null;
  //   }
  //   final String id = "xxx";
  //   final String title = data['title'] ?? '';
  //   final String description = data['description'] ?? '';
  //   final List<String> photos = data['photos'] ?? [];
  //   final String status = data['status'] ?? '';
  //   return PlanRecipe(id, title, description, photos, status);
  // }

  static PlanRecipe fromSnapshot(DocumentSnapshot snap) {
    List photoJson = snap.data['photos'];
    final photoArray = photoJson.map((f) => f.toString()).toList();
    return PlanRecipe(
      snap.documentID,
      snap.data['id'],
      snap.data['title'],
      snap.data['description'],
      photoArray ?? [],
      snap.data['status'] ?? '',
    );
  }
}
