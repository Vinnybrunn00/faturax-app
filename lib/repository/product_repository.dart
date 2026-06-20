import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faturax_app/constants/constants_values.dart';
import 'package:faturax_app/viewmodels/date_time_app.dart';
import 'package:faturax_app/viewmodels/items_model.dart';
import 'package:faturax_app/viewmodels/product_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductRepository with ChangeNotifier {
  ProductRepository() {
    _update();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  StreamSubscription? _itemsSubscription;

  User? get _currentUser => FirebaseAuth.instance.currentUser;

  DocumentReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users').doc(_currentUser?.uid);

  CollectionReference<Map<String, dynamic>> get _items =>
      _users.collection('items');

  int _price = 0;
  int _priceBefore = 0;

  bool _loading = false;
  bool get loading => _loading;

  int get price => _price;

  int get timeStamp => DateTime.now().millisecondsSinceEpoch;

  String convertCentInReais(int cent) {
    final NumberFormat formatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
    );

    double real = cent / 100;
    return formatter.format(real);
  }

  int _convertForCent(String formatText) {
    if (formatText.isNotEmpty) {
      String onlyDigit = formatText.replaceAll(RegExp(r'[^\d]'), '');

      if (onlyDigit.isEmpty) return 0;

      return int.parse(onlyDigit);
    }
    return 0;
  }

  Future<String> deleteCompra(String id) async {
    changeLoading();
    try {
      final DocumentReference<Map<String, dynamic>> docRef = _items.doc(id);

      await docRef.delete();

      final snapshot = await docRef.get();

      changeLoading();

      if (!snapshot.exists) {
        return 'Compra excluida com sucesso';
      }
      return 'Error ao deletar compra, tente novamente';
    } catch (_) {
      _loading = false;
      return 'Error ao deletar compra, tente novamente';
    } finally {
      _loading = false;
    }
  }

  Future<void> changeParcelas(ItemsModel itemsModel, String id) async {
    if (_currentUser != null) {
      changeLoading();

      await _items.doc(id).update({'parcelas_parciais': itemsModel.parcelas});

      changeLoading();
    }
  }

  Future<void> saveProduct(
    ProductModel product,
    DateTimeApp dateTimeApp,
  ) async {
    final int? parcelas = int.tryParse(product.parcelas);

    bool fixed = false;

    if (product.fixed != null) fixed = product.fixed!;

    if (!fixed && (parcelas == null || parcelas <= 0)) return;

    await _items.doc(itemId).set({
      'name': product.name,
      'parcelas_parciais': 0,
      'parcelas_totais': fixed ? 0 : parcelas,
      'price_int': _convertForCent(product.price),
      'start_date': fixed ? null : dateTimeApp.datePicker,
      'timestamp': timeStamp,
      'month': dateTimeApp.month,
      'year': dateTimeApp.year,
      'isFixed': product.fixed,
    });
  }

  Future<void> changePriceTotal({bool? isAfter}) async {
    await _itemsSubscription?.cancel();

    if (_currentUser == null) return;

    final snapshots = _items.snapshots();

    _itemsSubscription = snapshots.listen((onData) async {
      int temp = 0;

      for (int i = 0; i < onData.docs.length; i++) {
        final QueryDocumentSnapshot<Map<String, dynamic>> doc = onData.docs[i];
        final Map<String, dynamic> data = doc.data();

        if (data.containsKey('price_int') && data['price_int'] != null) {
          final DateTime now = DateTime.now();

          final int startMonth = int.parse(data['month'].toString());

          final int startYear = int.parse(
            data['year']?.toString() ?? now.year.toString(),
          );

          final int parcelasTotais = int.parse(
            data['parcelas_totais'].toString(),
          );

          final DateTime startDate = DateTime(startYear, startMonth);
          final DateTime nowDate = DateTime(
            now.year,
            now.month + ((isAfter ?? false) ? 1 : 0),
          );

          final int parcelasPagas =
              (nowDate.year - startDate.year) * 12 +
              nowDate.month -
              startDate.month +
              1;

          final bool isFixed = parcelasTotais == 0;

          if (!startDate.isAfter(nowDate) &&
              (isFixed || parcelasPagas <= parcelasTotais)) {
            final int parse = int.parse(data['price_int'].toString());
            temp += parse;
          }
        }
      }

      if (temp == _priceBefore) return;

      _price = temp;
      _priceBefore = temp;
      notifyListeners();

      if (isAfter == null) {
        await _updatePriceTotal();
      }
    });
  }

  Future<void> _updatePriceTotal() async {
    await _users.set({'total': _price}, SetOptions(merge: true));
  }

  void _update() async {
    await changePriceTotal();
  }

  void changeLoading() {
    _loading = !_loading;
    notifyListeners();
  }

  void stopLoading() {
    _loading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _itemsSubscription?.cancel();
    super.dispose();
  }
}
