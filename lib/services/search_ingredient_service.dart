import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mademe/utilities/constants.dart';

class SearchIngredientService {
  Future<List<Ingredient>> getIngredients() async {
    List<Ingredient> list = [];
    final cols = await Firestore.instance
        .collection('ingredients')
        .orderBy('photos')
        .limit(searchLimit)
        .getDocuments();
    cols.documents.forEach((doc) {
      list.add(Ingredient.fromMap(doc.data));
    });
    return list;
  }
}

class Ingredient {
  final String title;
  final String description;
  final List<String> photos;
  final String status;

  Ingredient(this.title, this.description, this.photos, this.status);

  factory Ingredient.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    List photoJson = data['photos'] ?? [];
    final photoArray = photoJson.map((f) => f.toString()).toList();

    final String title = data['title'] ?? '';
    final String description = data['description'] ?? '';
    final List<String> photos = photoArray ?? [];
    final String status = data['status'] ?? '';
    return Ingredient(title, description, photos, status);
  }
  static Ingredient fromSnapshot(DocumentSnapshot snap) {
    List photoJson = snap.data['photos'];
    final photoArray = photoJson.map((f) => f.toString()).toList();
    return Ingredient(
      snap.data['title'],
      snap.data['description'],
      photoArray ?? [],
      snap.data['status'] ?? '',
    );
  }
}
