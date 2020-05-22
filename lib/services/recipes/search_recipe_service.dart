import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:http_auth/http_auth.dart';
import 'package:mademe/models/recipe_detail_model.dart';
import 'package:mademe/models/recipe_preview_model.dart';
import 'package:mademe/utilities/log.dart';

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
    var client = BasicAuthClient("gcpf", "espany9h1");
    final url =
        'https://7b543b21eb66462c9e8d952474d6479f.asia-southeast1.gcp.elastic-cloud.com:9243/mademe/recipes/_search';
    String requestBody =
        '{"query":{"multi_match":{"query":"$keyword", "fields":["tags"], "fuzziness":"AUTO"}}}';
    Map<String, String> headers = {"Content-type": "application/json"};

    await client.post(url, body: requestBody, headers: headers).then((res) {
      final responseJson = json.decode(res.body);
      final returnCount = responseJson['hits']['total']['value'];
      this.recipePreviewResult = new List<RecipePreviewModel>();
      if (returnCount > 0) {
        //print('total > 0: ' + returnCount.toString());
        List searchResult = responseJson['hits']['hits'];
        searchResult.forEach((element) {
          final source = element['_source'];
          //print('Each item source:' + source.toString());
          this.recipePreviewResult.add(
              RecipePreviewModel.fromElasticSearch(element['_id'], source));
        });
      }
    });
    notifyListeners();
  }

  Future<RecipeDetailModel> getRecipeDetail(
      String recipeID, String uid, String planID) async {
    printT('getRecipeDetail with recipeID:$recipeID, uid:$uid, planID:$planID');
    final recipeDoc =
        await Firestore.instance.collection('recipes').document(recipeID).get();
    var detail =
        RecipeDetailModel.fromSnapshot(recipeDoc.documentID, recipeDoc.data);

    final planRecipe = await Firestore.instance
        .collection('profiles/$uid/plans/$planID/recipes')
        .where("id", isEqualTo: recipeID)
        .getDocuments();
    printT('result search in plan:' + planRecipe.documents.length.toString());
    if (planRecipe.documents.length == 0) {
      detail.status = "";
    } else {
      detail.status = planRecipe.documents[0]['status'] ?? 'ADDED';
    }
    printT('status for this detail' + detail.status);
    return detail;
    // return recipeDoc.get().then((doc) {
    //   return RecipeDetailModel.fromSnapshot(doc.documentID, doc.data);
    // });
  }
}
