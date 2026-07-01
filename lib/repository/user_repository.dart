import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faturax_app/services/logs_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class UserRepository with ChangeNotifier {
  UserRepository() {
    _update();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get _currentUser => FirebaseAuth.instance.currentUser;

  DocumentReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users').doc(_currentUser?.uid);


  bool _notVisibility = false;
  bool get notVisibility => _notVisibility;

  void setVisibity() {
    _notVisibility = !_notVisibility;
    notifyListeners();
  }

  bool _isOwner = false;
  String? _username;

  bool get isOwner => _isOwner;
  String? get username => _username;

  Future<void> _loadUserData() async {
    final DocumentSnapshot<Map<String, dynamic>> get = await _users.get();

    final Map<String, dynamic>? data = get.data();

    if (data != null) {
      _username = data['username'];
      _isOwner = data['rules'];
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  void _update() async {
    await _loadUserData();

    if (!kDebugMode) {
      LogsServices(message: 'novo login', type: 'INFO', username: _username);
    }
  }
}
