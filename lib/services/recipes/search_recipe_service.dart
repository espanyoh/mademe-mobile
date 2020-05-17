import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:http_auth/http_auth.dart';
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
          this
              .recipePreviewResult
              .add(RecipePreviewModel.fromElasticSearch(source['id'], source));
        });
      }
    });
    notifyListeners();
  }

  Future<RecipeDetailModel> getRecipeDetail(String id) {
    final recipeDoc = Firestore.instance.collection('recipes').document(id);
    return recipeDoc.get().then((doc) {
      return RecipeDetailModel.fromSnapshot(doc.documentID, doc.data);
    });
  }
}
