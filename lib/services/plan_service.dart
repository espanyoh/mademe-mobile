import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PlanService {
  PlanService({@required this.uid}) : assert(uid != null);
  final String uid;
  Plan current;

  Stream<Plan> planStream() {
    final ref = Firestore.instance
        .collection('profiles/$uid/plans')
        .where("active", isEqualTo: true)
        .orderBy("created_at", descending: true)
        .limit(1);

    final plan = ref.snapshots().map((snapshot) {
      return snapshot.documents
          .map((doc) {
            final plan = Plan.fromSnapshot(doc, uid);
            if (plan.active == true) {
              this.current = plan;
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
        return Plan.fromSnapshot(doc, uid);
      }).toList();
    }).asBroadcastStream();
  }
}

class Plan {
  final String id;
  final String uid;
  final String title;
  final String description;
  final int createdAt;
  final bool active;

  Plan(this.id, this.uid, this.title, this.description, this.createdAt,
      this.active);

  // factory Plan.fromMap(Map<String, dynamic> data) {
  //   if (data == null) {
  //     return null;
  //   }
  //   final String id = "id";
  //   final String title = data['title'] ?? '';
  //   final String description = data['description'] ?? '';
  //   final String createdAt = data['createdAt'] ?? '';
  //   final bool active = data['active'] ?? false;
  //   return Plan(id, title, description, createdAt, active);
  // }
  static Plan fromSnapshot(DocumentSnapshot snap, String uid) {
    return Plan(
      snap.documentID,
      uid,
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
  // factory Ingredient.fromMap(Map<String, dynamic> data) {
  //   if (data == null) {
  //     return null;
  //   }
  //   final String title = data['title'] ?? '';
  //   final String description = data['description'] ?? '';
  //   return Ingredient(title, description);
  // }
}
