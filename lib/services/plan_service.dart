import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PlanService {
  PlanService({@required this.uid}) : assert(uid != null);
  final String uid;

  Stream<Plan> planStream() {
    final ref = Firestore.instance
        .collection('profiles/$uid/plans')
        .where("active", isEqualTo: true)
        .orderBy("created_at", descending: true);

    final plan = ref.snapshots().map((snapshot) {
      return snapshot.documents
          .map((doc) {
            final plan = Plan.fromSnapshot(doc);
            if (plan.active == true) {
              return plan;
            }
            return null;
          })
          .toList()
          .first;
    });
    return plan;
  }

  Stream<List<Plan>> planListStream() {
    final planCollection = Firestore.instance
        .collection('profiles/$uid/plans')
        .orderBy("created_at", descending: true);

    return planCollection.snapshots().map((snapshot) {
      return snapshot.documents.map((doc) {
        return Plan.fromSnapshot(doc);
      }).toList();
    }).asBroadcastStream();
  }
}

class Plan {
  final String title;
  final String description;
  final String createdAt;
  final bool active;

  Plan(this.title, this.description, this.createdAt, this.active);

  factory Plan.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String title = data['title'] ?? '';
    final String description = data['description'] ?? '';
    final String createdAt = data['createdAt'] ?? '';
    final bool active = data['active'] ?? false;
    return Plan(title, description, createdAt, active);
  }
  static Plan fromSnapshot(DocumentSnapshot snap) {
    return Plan(
      snap.data['title'],
      snap.data['description'],
      snap.data['created_at'] ?? '',
      snap.data['active'] ?? false,
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
