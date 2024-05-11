import 'package:cabrent/widgets/phonereg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Kayıt ol fonksiyonu
  Future registerUser(String name, String phone, String email, String password,
      BuildContext context) async {
    var user = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    _firestore.collection("Person").doc(user.user?.uid).set({
      'name': name,
      'email': email,
      'telefon': phone,
      'password': password,
    });

    await _auth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
      codeSent: (String verificationId, int? forceResendingToken) {},
      verificationFailed: (FirebaseAuthException error) {},
    );
    return user;
  }
}
