import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final String _username;
  final String _password;

  AuthServices({required this._username, required this._password});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> signIn() async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: '$_username@faturax.com',
        password: _password,
      );
    } on FirebaseException catch (error) {
      log(error.toString());
      throw error.message ?? 'Invalid Argument';
    }
  }

  Future<void> signUp() async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(
            email: '$_username@faturax.com',
            password: _password,
          );

      final User? user = userCredential.user;

      if (user != null) {
        await user.updateDisplayName(_username);

        final doc = _firestore.collection('users').doc(user.uid);

        await doc.set({
          'id': user.uid,
          'username': _username,
          'password': _password,
          'total': 0,
          'rules': false,
        });
      }
      return;
    } on FirebaseException catch (error) {
      throw error.message ?? 'Invalid Argument';
    }
  }
}
