import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
}

class PlanRecipe {
  final String title;
  final String description;
  final List<String> photos;
  final String status;

  PlanRecipe(this.title, this.description, this.photos, this.status);

  factory PlanRecipe.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String title = data['title'] ?? '';
    final String description = data['description'] ?? '';
    final List<String> photos = data['photos'] ?? [];
    final String status = data['status'] ?? '';
    return PlanRecipe(title, description, photos, status);
  }
  static PlanRecipe fromSnapshot(DocumentSnapshot snap) {
    List photoJson = snap.data['photos'];
    final photoArray = photoJson.map((f) => f.toString()).toList();
    return PlanRecipe(
      snap.data['title'],
      snap.data['description'],
      photoArray ?? [],
      snap.data['status'] ?? '',
    );
  }
}
