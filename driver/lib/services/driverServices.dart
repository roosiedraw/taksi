import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class DriverService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List driverList = [];
  List talepList = [];
  List konumList = [];
  final geo = Geoflutterfire();
  final CollectionReference collectionRef =
      FirebaseFirestore.instance.collection("driver");
  final CollectionReference collectiontalep =
      FirebaseFirestore.instance.collection("Taksirequest");
  Future getData() async {
    try {
      //to get data from a single/particular document alone.
      // var temp = await collectionRef.doc("<your document ID here>").get();

      // to get data from all documents sequentially
      await collectionRef.get().then((querySnapshot) {
        for (var result in querySnapshot.docs) {
          driverList.add(result.data());
        }
      });

      return driverList;
    } catch (e) {
      debugPrint("Error - $e");
      return e;
    }
  }

  Future getTalep() async {
    try {
      //to get data from a single/particular document alone.
      // var temp = await collectionRef.doc("<your document ID here>").get();

      // to get data from all documents sequentially
      await collectiontalep.get().then((querySnapshot) {
        for (var result in querySnapshot.docs) {
          talepList.add(result.data());
        }
      });

      return talepList;
    } catch (e) {
      debugPrint("Error - $e");
      return e;
    }
  }

  updateData() async {
    var c = await _firestore
        .collection("Taksirequest")
        .doc("status")
        .update({"taxirequest": true});
    return c;
  }

  updateReverseData() {
    var c = _firestore
        .collection("Taksirequest")
        .doc("status")
        .update({"taxirequest": false});
    return c;
  }

  Future getLocation() async {
    var ref = _firestore.collection('Taksirequest').snapshots();
    return ref;
  }
}
