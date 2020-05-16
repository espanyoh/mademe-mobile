import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mademe/services/search_recipe_service.dart';

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

  void addRecipe(String planID, RecipePreview recipe) async {
    var rawRecipe =
        Firestore.instance.collection('recipes').document(recipe.id);
    rawRecipe.get().then((doc) {
      Firestore.instance
          .collection('profiles/$uid/plans/$planID/recipes')
          .add(doc.data);
    });

    recipe.ingredientIDs.forEach((ingredient) async {
      var ingredientDoc =
          Firestore.instance.collection('ingredients').document(ingredient);
      ingredientDoc.get().then((onValue) {
        if (onValue.data != null) {
          Firestore.instance
              .collection('profiles/$uid/plans/$planID/ingredients')
              .add(onValue.data);
        }
      });
    });
  }

  void removeRecipe(String planID, String recipeID) async {
    await Firestore.instance
        .collection('profiles/$uid/plans/$planID/recipes')
        .document(recipeID)
        .delete();
  }
}

class PlanRecipe {
  final String id;
  final String title;
  final String description;
  final List<String> photos;
  final String status;

  PlanRecipe(this.id, this.title, this.description, this.photos, this.status);

  factory PlanRecipe.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String id = "xxx";
    final String title = data['title'] ?? '';
    final String description = data['description'] ?? '';
    final List<String> photos = data['photos'] ?? [];
    final String status = data['status'] ?? '';
    return PlanRecipe(id, title, description, photos, status);
  }

  static PlanRecipe fromSnapshot(DocumentSnapshot snap) {
    List photoJson = snap.data['photos'];
    final photoArray = photoJson.map((f) => f.toString()).toList();
    return PlanRecipe(
      snap.documentID,
      snap.data['title'],
      snap.data['description'],
      photoArray ?? [],
      snap.data['status'] ?? '',
    );
  }
}
