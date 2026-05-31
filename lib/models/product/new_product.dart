import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faturax/models/product/product_model.dart';
import 'package:faturax/ui/widgets/theme_data_picker.dart';
import 'package:faturax/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewProduct with ChangeNotifier {
  NewProduct() {
    _update();
  }

  String _initialDate = DateFormat(
    "MMMM 'de' yyyy",
    'pt_BR',
  ).format(DateTime.now());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get _currentUser => FirebaseAuth.instance.currentUser;

  StreamSubscription? _itemsSubscription;

  DocumentReference<Map<String, dynamic>> get users =>
      _firestore.collection('users').doc(_currentUser?.uid);

  CollectionReference<Map<String, dynamic>> get items =>
      users.collection('items');

  String? _date;

  int _month = DateTime.now().month;
  int _year = DateTime.now().year;

  int _price = 0;
  int _priceBefore = 0;

  int get price => _price;
  String? get date => _date;

  set setDate(String value) {
    _date = value;
  }

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

  int _timeStamp() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  Future<void> saveProduct(ProductModel product) async {
    final int? parcelas = int.tryParse(product.installments);

    bool fixed = false;

    if (product.fixed != null) fixed = product.fixed!;

    if (!fixed && (parcelas == null || parcelas <= 0)) return;

    final String itemId = Utils.randomNumber.toString();

    await items.doc(itemId).set({
      'name': product.name,
      'parcelas_parciais': 0,
      'parcelas_totais': fixed ? 0 : parcelas,
      'price_int': _convertForCent(product.price),
      'start_date': fixed ? null : _initialDate,
      'timestamp': _timeStamp(),
      'month': _month,
      'year': _year,
      'isFixed': product.fixed,
    });
  }

  Future<void> _changePriceTotal() async {
    await _itemsSubscription?.cancel();

    if (_currentUser == null) return;

    final snapshots = items.snapshots();

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
          final DateTime nowDate = DateTime(now.year, now.month);

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

      await _updateValueTotal();
    });
  }

  Future<void> _updateValueTotal() async {
    await users.set({'total': _price}, SetOptions(merge: true));
  }

  void _update() async {
    await _changePriceTotal();
    //await _updateValueTotal();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? showDataPicker = await showDatePicker(
      barrierDismissible: true,
      context: context,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      firstDate: DateTime.now(),
      lastDate: DateTime(2500),
      locale: const Locale('pt', 'BR'),
      builder: (context, child) {
        return ThemeDataPicker(child: child);
      },
    );

    if (showDataPicker != null) {
      final String format = DateFormat(
        "MMMM 'de' yyyy",
        'pt_BR',
      ).format(showDataPicker);

      _date = format;
      _initialDate = format;
      _month = showDataPicker.month;
      _year = showDataPicker.year;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _itemsSubscription?.cancel();
    super.dispose();
  }
}
