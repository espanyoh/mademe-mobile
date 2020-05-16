import 'dart:async';

import 'package:elastic_client/console_http_transport.dart';
import 'package:elastic_client/elastic_client.dart' as elastic;
import 'package:flutter/material.dart';

class SearchRecipeService with ChangeNotifier {
  List<RecipePreview> recipePreviewResult = new List<RecipePreview>();
  SearchRecipeService(recipePreviewResult) {
    if (recipePreviewResult == null) {
      this.recipePreviewResult = new List<RecipePreview>();
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
    this.recipePreviewResult = new List<RecipePreview>();
    if (rs.totalCount > 0) {
      rs.hits.forEach((data) {
        this
            .recipePreviewResult
            .add(RecipePreview.fromElasticSearch(data.id, data.doc));
      });
    }
    await transport.close();
    notifyListeners();
  }
}

class RecipePreview {
  final String id;
  final String title;
  final String description;
  final List<String> photos;
  final List<String> ingredientIDs;
  final String status;

  RecipePreview(this.id, this.title, this.description, this.photos,
      this.ingredientIDs, this.status);

  factory RecipePreview.fromElasticSearch(
      String id, Map<String, dynamic> data) {
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
    return RecipePreview(id, title, description, photos, ingredientIDs, status);
  }

  // static RecipePreview fromSnapshot(DocumentSnapshot snap) {
  //   List photoJson = snap.data['photos'];
  //   final photoArray = photoJson.map((f) => f.toString()).toList();
  //   List ingredientJson = snap.data['ingredientIDs'];
  //   final ingredientArray = ingredientJson.map((f) => f.toString()).toList();
  //   return RecipePreview(
  //     snap.documentID,
  //     snap.data['title'],
  //     snap.data['description'],
  //     photoArray ?? [],
  //     ingredientArray ?? [],
  //     snap.data['status'] ?? '',
  //   );
  // }
}
