import 'package:flutter/material.dart';

class ProductModel with ChangeNotifier {
  String name = '';
  String price = '';
  String parcelas = '';

  bool? _fixed = false;
  bool? get fixed => _fixed;

  bool get isEmpty {
    final bool isFixed = _fixed ?? false;
    bool priceAndName = name == '' || price == '';

    if (isFixed) {
      return priceAndName;
    }
    return priceAndName || parcelas == '';
  }

  void changeButton(bool? value) {
    _fixed = value;
    notifyListeners();
  }

  void reset() {
    name = '';
    price = '';
    parcelas = '';
    _fixed = false;
    notifyListeners();
  }
}
