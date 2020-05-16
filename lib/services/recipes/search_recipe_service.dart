import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elastic_client/console_http_transport.dart';
import 'package:elastic_client/elastic_client.dart' as elastic;
import 'package:flutter/material.dart';
import 'package:mademe/app/recipe/recipe_detail_page.dart';
import 'package:mademe/models/recipe_detail_model.dart';
import 'package:mademe/models/recipe_preview_model.dart';

class SearchRecipeService with ChangeNotifier {
  List<RecipePreviewModel> recipePreviewResult = new List<RecipePreviewModel>();
  SearchRecipeService(recipePreviewResult) {
    if (recipePreviewResult == null) {
      this.recipePreviewResult = new List<RecipePreviewModel>();
      return;
    }
    this.recipePreviewResult = recipePreviewResult;
  }

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
    this.recipePreviewResult = new List<RecipePreviewModel>();
    if (rs.totalCount > 0) {
      rs.hits.forEach((data) {
        this
            .recipePreviewResult
            .add(RecipePreviewModel.fromElasticSearch(data.id, data.doc));
      });
    }
    await transport.close();
    notifyListeners();
  }

  Future<RecipeDetailModel> getRecipeDetail(String id) {
    // print('getRecipeDetail: start id:' + id);
    final recipeDoc = Firestore.instance.collection('recipes').document(id);
    return recipeDoc.get().then((doc) {
      // print('getRecipeDetail: done inner2');
      // print(doc);
      // print(doc.documentID);
      return RecipeDetailModel.fromSnapshot(doc.documentID, doc.data);
    });
  }

  //   Stream<List<PlanRecipe>> streamRecipes(String planID) {
  //   final planCollection =
  //       Firestore.instance.collection('profiles/$uid/plans/$planID/recipes');

  //   return planCollection.snapshots().map((snapshot) {
  //     return snapshot.documents.map((doc) {
  //       return PlanRecipe.fromSnapshot(doc);
  //     }).toList();
  //   }).asBroadcastStream();
  // }

}
