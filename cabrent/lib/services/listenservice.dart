import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class listenService {
  Stream<QuerySnapshot> getStatus() {
    var ref = firestore.collection("Taksirequest").snapshots();

    return ref;
  }
}
