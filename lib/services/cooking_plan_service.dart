import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:mademe/models/avatar_reference.dart';
import 'firestore_path.dart';

class PlanService {
  PlanService({@required this.uid}) : assert(uid != null);
  final String uid;

  // Reads the current avatar download url
  // Stream<Ingredient> planIngredientStream() {
  // final plansPath = FirestorePath.plan(uid);
  //   final plansRef = Firestore.instance
  //       .collection(plansPath)
  //       .where("active", isEqualTo: true);
  //   final activePlan = plansRef.snapshots().first;
  //   activePlan.then((onValue) => {
  //     onValue.documents[0].data

  //   });
  //   return snapshots.map((snapshot) => Ingredient.fromMap(snapshot.data));
  // }

  Stream<QuerySnapshot> planStream() {
    final planCollection = Firestore.instance.collection('profiles/$uid/plans');
    return planCollection.snapshots();
    // print('----- ref ----');

    // print(ref);
    // final list = ref.map(
    //     (snapshot) => snapshot.documents.map((doc) => Plan.fromMap(doc.data)));
    // print(list);
    // // return planCollection.snapshots();
    // return list
    //     // .map((snapshot) => Plan.fromMap(snapshot.data));
    //     ;
  }

  // Stream<List<Plan>> planStream() {
  //   final planCollection = Firestore.instance.collection('profiles/$uid/plans');
  //   final ref = planCollection.snapshots();
  //   print('----- ref ----');

  //   print(ref);
  //   final list = ref.map(
  //       (snapshot) => snapshot.documents.map((doc) => Plan.fromMap(doc.data)));
  //   print(list);
  //   // return planCollection.snapshots();
  //   return list
  //       // .map((snapshot) => Plan.fromMap(snapshot.data));
  //       ;
  // }
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
