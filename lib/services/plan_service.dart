import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PlanService {
  PlanService({@required this.uid}) : assert(uid != null);
  final String uid;

  Stream<Plan> planStream() {
    final planCollection = Firestore.instance
        .collection('profiles/$uid/plans')
        .document('QMBx6z4QHvCb6KKngqGR');
    final ref = planCollection.snapshots();
    return ref.map((snapshot) => Plan.fromMap(snapshot.data));
  }

  Stream<List<Plan>> planListStream() {
    final planCollection = Firestore.instance
        .collection('profiles/$uid/plans')
        .orderBy("created_at");
    return planCollection.snapshots().map((snapshot) {
      return snapshot.documents.map((doc) => Plan.fromSnapshot(doc)).toList();
    });
  }
}

class Plan {
  final String title;
  final String description;
  final String createdAt;

  Plan(this.title, this.description, this.createdAt);

  factory Plan.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String title = data['title'] ?? '';
    final String description = data['description'] ?? '';
    final String createdAt = data['createdAt'] ?? '';
    return Plan(title, description, createdAt);
  }
  static Plan fromSnapshot(DocumentSnapshot snap) {
    return Plan(
      snap.data['title'],
      snap.data['description'],
      snap.data['created_at'] ?? '',
    );
  }
}

class Ingredient {
  final String title;
  final String description;
  // final List<String> photos;
  String number;

  Ingredient(this.title, this.description);
  factory Ingredient.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String title = data['title'] ?? '';
    final String description = data['description'] ?? '';
    return Ingredient(title, description);
  }
}
