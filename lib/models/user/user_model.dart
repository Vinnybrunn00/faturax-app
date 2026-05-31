
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserModel with ChangeNotifier {
  UserModel() {
    _update();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get _currentUser => FirebaseAuth.instance.currentUser;

  DocumentReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users').doc(_currentUser?.uid);

  CollectionReference<Map<String, dynamic>> get items =>
      _users.collection('items');

  bool _isOwner = false;
  String? _username;

  bool get isOwner => _isOwner;
  String? get username => _username;

  Future<void> _getUsername() async {
    final DocumentSnapshot<Map<String, dynamic>> get = await _users.get();

    final Map<String, dynamic>? data = get.data();

    if (data != null) {
      _username = data['username'];
      notifyListeners();
    }
  }

  void _owner() {
    if (_currentUser != null) {
      _isOwner = _currentUser?.uid == 'OZVP2wz5mRXq1cnKf9g0wZSW3Tk2';
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  void _update() async {
    await _getUsername();
    _owner();
  }
}

// ----------------------------------------------- //
class UserView with ChangeNotifier {
  UserView() {
    _update();
  }

  final ScrollController _scrollController = ScrollController();

  ScrollController get scrollController => _scrollController;

  bool _colapsed = false;
  String? _formatDate;

  bool get colapsed => _colapsed;
  String? get formatDate => _formatDate;

  void _addListener() {
    _scrollController.addListener(() {
      final bool isColapsed = _scrollController.offset > 140;

      if (_colapsed != isColapsed) {
        _colapsed = isColapsed;
        notifyListeners();
      }
    });
  }

  String showDataCompra(int timestamp) {
    final DateTime data = DateTime.fromMillisecondsSinceEpoch(timestamp);

    return DateFormat('dd/MM/yyyy').format(data);
  }

  void dateViewer(int timestamp) {
    final DateTime data = DateTime.fromMillisecondsSinceEpoch(timestamp);

    final String format = DateFormat('dd/MM/yyyy - HH:mm').format(data);

    _formatDate = format;
    notifyListeners();
  }

  void _update() {
    _addListener();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
