import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class ItemsModel with ChangeNotifier {
  User? get _currentUser => FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _itemsCollection =>
      _firestore.collection('users').doc(_currentUser?.uid).collection('items');

  bool _enabled = false;
  int _parcelas = 0;
  bool _deleteLoading = false;

  bool get enabled => _enabled;
  int get parcelas => _parcelas;
  bool get deleteLoading => _deleteLoading;

  Future<void> changeParcelas(ItemsModel itemsModel, String id) async {
    if (_currentUser != null) {
      await _itemsCollection.doc(id).update({
        'parcelas_parciais': itemsModel.parcelas,
      });
    }
  }

  void changeLoading() {
    _deleteLoading = !_deleteLoading;
    notifyListeners();
  }

  Future<String> deleteCompra(String id) async {
    changeLoading();

    final DocumentReference<Map<String, dynamic>> docRef = _itemsCollection.doc(
      id,
    );

    await docRef.delete();

    final snapshot = await docRef.get();

    changeLoading();

    if (!snapshot.exists) {
      return 'Compra excluida com sucesso';
    }
    return 'Error ao deletar compra, tente novamente';
  }

  void onChange(String parcelas, int parcelasTotais) {
    if (parcelas.trim().isEmpty) {
      _enabled = false;
      notifyListeners();
      return;
    }

    final int? parser = int.tryParse(parcelas);

    if (parser != null) {
      int parciais = parcelasTotais;

      _enabled = parser <= parciais;
      _parcelas = parser;
      notifyListeners();
    }
  }
}
