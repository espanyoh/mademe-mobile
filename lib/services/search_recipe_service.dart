import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elastic_client/console_http_transport.dart';
import 'package:elastic_client/elastic_client.dart' as elastic;
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

  // void search(String keyword) async {
  //   recipeResult = new List<Recipe>();
  //   var query = Firestore.instance.collection('recipes').orderBy('photos');
  //   if (keyword != null) {
  //     query = query.where("tags", arrayContains: keyword);
  //   }
  //   final cols = await query.limit(searchLimit).getDocuments();

  //   cols.documents.forEach((doc) {
  //     this.recipeResult.add(Recipe.fromMap(doc.data));
  //   });
  //   notifyListeners();
  // }

  // Future<List<Recipe>> getRecipes() async {
  //   List<Recipe> list = [];
  //   final cols = await Firestore.instance
  //       .collection('recipes')
  //       .orderBy('photos')
  //       .limit(searchLimit)
  //       .getDocuments();
  //   cols.documents.forEach((doc) {
  //     list.add(Recipe.fromMap(doc.data));
  //   });
  //   return list;
  // }

  Future<void> searchElastic(String keyword) async {
    print('searchElastic...:' + keyword);
    final transport = ConsoleHttpTransport(
        Uri.parse(
            'https://7b543b21eb66462c9e8d952474d6479f.asia-southeast1.gcp.elastic-cloud.com:9243/'),
        basicAuth: BasicAuth("gcpf", "espany9h1"));
    final client = elastic.Client(transport);
    final rs = await client.search(
        'mademe', 'recipes', elastic.Query.term('tags', [keyword]),
        source: true);
    this.recipeResult = new List<Recipe>();
    if (rs.totalCount > 0) {
      rs.hits.forEach((data) {
        this.recipeResult.add(Recipe.fromElasticSearch(data.id, data.doc));
      });
    }
    await transport.close();
    notifyListeners();
  }
}

class Recipe {
  final String id;
  final String title;
  final String description;
  final List<String> photos;
  final List<String> ingredientIDs;
  final String status;

  Recipe(this.id, this.title, this.description, this.photos, this.ingredientIDs,
      this.status);

  // factory Recipe.fromMap(Map<String, dynamic> data) {
  //   if (data == null) {
  //     return null;
  //   }
  //   List photoJson = data['photos'] ?? [];
  //   final photoArray = photoJson.map((f) => f.toString()).toList();

  //   List ingredientJson = data['ingredientIDs'] ?? [];
  //   final ingredientArray = ingredientJson.map((f) => f.toString()).toList();

  //   final String id = 'fake';
  //   final String title = data['title'] ?? '';
  //   final String description = data['description'] ?? '';
  //   final List<String> photos = photoArray ?? [];
  //   final List<String> ingredientIDs = ingredientArray ?? [];
  //   final String status = data['status'] ?? '';
  //   return Recipe(id, title, description, photos, ingredientIDs, status);
  // }

  factory Recipe.fromElasticSearch(String id, Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    List photoJson = data['photos'] ?? [];
    final photoArray = photoJson.map((f) => f.toString()).toList();

    List ingredientJson = data['ingredientIDs'] ?? [];
    final ingredientArray = ingredientJson.map((f) => f.toString()).toList();

    final String title = data['title'] ?? '';
    final String description = data['description'] ?? '';
    final List<String> photos = photoArray ?? [];
    final List<String> ingredientIDs = ingredientArray ?? [];
    final String status = data['status'] ?? '';
    return Recipe(id, title, description, photos, ingredientIDs, status);
  }

  static Recipe fromSnapshot(DocumentSnapshot snap) {
    List photoJson = snap.data['photos'];
    final photoArray = photoJson.map((f) => f.toString()).toList();
    List ingredientJson = snap.data['ingredientIDs'];
    final ingredientArray = ingredientJson.map((f) => f.toString()).toList();
    return Recipe(
      snap.documentID,
      snap.data['title'],
      snap.data['description'],
      photoArray ?? [],
      ingredientArray ?? [],
      snap.data['status'] ?? '',
    );
  }
}
