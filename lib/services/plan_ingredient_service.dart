import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PlanIngredientService {
  PlanIngredientService({@required this.uid}) : assert(uid != null);
  final String uid;

  Stream<List<PlanIngredient>> streamIngredients(String planID) {
    final planCollection = Firestore.instance
        .collection('profiles/$uid/plans/$planID/ingredients');

    return planCollection.snapshots().map((snapshot) {
      return snapshot.documents.map((doc) {
        return PlanIngredient.fromSnapshot(doc);
      }).toList();
    }).asBroadcastStream();
  }
}

class PlanIngredient {
  final String title;
  final String description;
  final List<String> photos;
  final String status;

  PlanIngredient(this.title, this.description, this.photos, this.status);

  factory PlanIngredient.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String title = data['title'] ?? '';
    final String description = data['description'] ?? '';
    final List<String> photos = data['photos'] ?? [];
    final String status = data['status'] ?? '';
    return PlanIngredient(title, description, photos, status);
  }
  static PlanIngredient fromSnapshot(DocumentSnapshot snap) {
    List photoJson = snap.data['photos'] ?? [""];
    final photoArray = photoJson.map((f) => f.toString()).toList();
    return PlanIngredient(
      snap.data['title'] ?? '-',
      snap.data['description'] ?? '-',
      photoArray ?? [],
      snap.data['status'] ?? '',
    );
  }
}
