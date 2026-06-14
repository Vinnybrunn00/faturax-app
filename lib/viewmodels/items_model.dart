import 'package:flutter/material.dart';

class ItemsModel with ChangeNotifier {
  bool _enabled = false;
  int _parcelas = 0;

  bool get enabled => _enabled;
  int get parcelas => _parcelas;

  void onChange(String parcelas, int parcelasTotais) {
    if (parcelas.trim().isEmpty) {
      _enabled = false;
      notifyListeners();
      return;
    }

    final int? parser = int.tryParse(parcelas);

    if (parser != null) {
      final int parciais = parcelasTotais;
      _enabled = parser <= parciais;
      _parcelas = parser;
      notifyListeners();
    }
  }
}
