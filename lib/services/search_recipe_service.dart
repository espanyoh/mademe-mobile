import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mademe/utilities/constants.dart';

class SearchRecipeService with ChangeNotifier {
  List<Recipe> recipeResult = new List<Recipe>();
  SearchRecipeService(recipeResult) {
    if (recipeResult == null) {
      this.recipeResult = new List<Recipe>();
      return;
    }
    this.recipeResult = recipeResult;
  }

  void search(String keyword) async {
    recipeResult = new List<Recipe>();
    var query = Firestore.instance.collection('recipes').orderBy('photos');
    if (keyword != null) {
      query = query.where("tags", arrayContains: keyword);
    }
    final cols = await query.limit(searchLimit).getDocuments();

    cols.documents.forEach((doc) {
      this.recipeResult.add(Recipe.fromMap(doc.data));
    });
    notifyListeners();
  }

  Future<List<Recipe>> getRecipes() async {
    List<Recipe> list = [];
    final cols = await Firestore.instance
        .collection('recipes')
        .orderBy('photos')
        .limit(searchLimit)
        .getDocuments();
    cols.documents.forEach((doc) {
      list.add(Recipe.fromMap(doc.data));
    });
    return list;
  }
}

class Recipe {
  final String title;
  final String description;
  final List<String> photos;
  final String status;

  Recipe(this.title, this.description, this.photos, this.status);

  factory Recipe.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    List photoJson = data['photos'] ?? [];
    final photoArray = photoJson.map((f) => f.toString()).toList();

    final String title = data['title'] ?? '';
    final String description = data['description'] ?? '';
    final List<String> photos = photoArray ?? [];
    final String status = data['status'] ?? '';
    return Recipe(title, description, photos, status);
  }
  static Recipe fromSnapshot(DocumentSnapshot snap) {
    List photoJson = snap.data['photos'];
    final photoArray = photoJson.map((f) => f.toString()).toList();
    return Recipe(
      snap.data['title'],
      snap.data['description'],
      photoArray ?? [],
      snap.data['status'] ?? '',
    );
  }
}
