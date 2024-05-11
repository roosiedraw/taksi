import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;

class WebServices {
  List userList = [];
  List taksiliste = [];
  Stream<QuerySnapshot> getStatus() {
    var ref = _firestore.collection("Taksirequest").snapshots();

    return ref;
  }

  Future<void> durakEkle(String durakad, String durakadres, LatLng durakkonum,
      int durakmenzil) async {
    var durakref = await _firestore
        .collection("durak")
        .add({
          "durakad": durakad,
          "durakadres": durakadres,
          "durakkonum": GeoPoint(durakkonum.latitude, durakkonum.longitude),
          "durakmenzil": durakmenzil,
        })
        .then((value) => print("Durak eklendi"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> taksiEkle(String driver1tel, String driver2tel, String durakad,
      String plaka, LatLng taksikonum) async {
    var durakref = await _firestore
        .collection("taksi")
        .add({
          "driver1tel": driver1tel,
          "driver2tel": driver2tel,
          "durakad": durakad,
          "plaka": plaka,
          "taksikonum": GeoPoint(taksikonum.latitude, taksikonum.longitude),
        })
        .then((value) => print("taksi eklendi"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> soforEkle(LatLng driverkonum, String durak, String ehliyet,
      String password, String telefon) async {
    var durakref = await _firestore
        .collection("driver")
        .add({
          "driverkonum": GeoPoint(driverkonum.latitude, driverkonum.longitude),
          "durak": durak,
          "ehliyet": ehliyet,
          "password": password,
          "telefon": telefon,
        })
        .then((value) => print("sofor eklendi"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> userEkle(String telefon, String password, String durak) async {
    var durakref = await _firestore
        .collection("user")
        .add({
          "durak": durak,
          "password": password,
          "telefon": telefon,
        })
        .then((value) => print("User eklendi"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  getdata() async {
    await _firestore.collection("user").get().then((querySnapshot) {
      for (var result in querySnapshot.docs) {
        taksiliste.add(result.data());
      }
    });

    return taksiliste;
  }

  Future getauth() async {
    try {
      //to get data from a single/particular document alone.
      // var temp = await collectionRef.doc("<your document ID here>").get();

      // to get data from all documents sequentially
      await _firestore.collection("user").get().then((querySnapshot) {
        for (var result in querySnapshot.docs) {
          userList.add(result.data());
        }
      });

      return userList;
    } catch (e) {
      debugPrint("Error - $e");
      return e;
    }
  }
}
