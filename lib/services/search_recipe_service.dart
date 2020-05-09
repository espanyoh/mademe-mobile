import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class SearchRecipeService {
  Future<List<Recipe>> getRecipes() async {
    List<Recipe> list = [];
    final cols = await Firestore.instance.collection('recipes').getDocuments();
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

    print(photoArray);
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
