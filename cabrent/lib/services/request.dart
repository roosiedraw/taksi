import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class RequestService {
  late final LatLng konum;
  String telefon = "";
  bool taksiBulundu = false;
  Future<void> addUser(LatLng konum, String telefon, bool taksiBulundu) async {
    CollectionReference request =
        FirebaseFirestore.instance.collection('Taksirequest');
    var def = await request.doc(telefon);
    var documentRef = await request
        .add({
          'id': def,
          'konum': GeoPoint(konum.latitude, konum.longitude), // konum bilgisi
          'telefon': telefon,
          'taksibulundu': taksiBulundu
        })
        .then((value) => print("UTaksi İsteği yapıldı"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}
