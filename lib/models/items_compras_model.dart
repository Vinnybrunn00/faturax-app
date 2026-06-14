import 'package:faturax_app/constants/constants_color.dart';
import 'package:flutter/material.dart';

class ItemsComprasModel {
  final Map<String, dynamic> _items;

  ItemsComprasModel({required this._items});

  String get name => _items['name'] as String;
  String get startDate => _items['start_date'] as String;
  bool get isFixed => _items['isFixed'] as bool;
  int get priceInt => _items['price_int'] as int;
  int get _parcelasParciais => _items['parcelas_parciais'] as int;
  int get _parcelasTotais => _items['parcelas_totais'] as int;
  int get timeStamp => _items['timestamp'];

  int get lastParcelas => _parcelasTotais - _parcelasParciais;

  bool get isPago {
    if (isFixed) return !isFixed;
    return _parcelasTotais == _parcelasParciais;
  }

  Text showParcelasFormat() {
    if (_parcelasTotais == 1) {
      return Text(
        'Pagamento único',
        style: TextStyle(color: AppColor.cyanColor, fontSize: 11),
      );
    }
    return Text(
      '$_parcelasParciais/$_parcelasTotais Parcelas',
      style: TextStyle(
        color: isPago
            ? Colors.black.withAlpha(90)
            : Colors.black.withAlpha(145),
        fontSize: 12,
      ),
    );
  }
}
