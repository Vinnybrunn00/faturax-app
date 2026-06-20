import 'package:faturax_app/constants/constants_color.dart';
import 'package:faturax_app/models/items_compras_model.dart';
import 'package:flutter/material.dart';

class TextParcelas extends StatelessWidget {
  final ItemComprasModel _itemComprasModel;

  const TextParcelas({super.key, required this._itemComprasModel});

  Text _showParcelasFormat() {
    if (_itemComprasModel.parcelasTotais == 1) {
      return Text(
        'Pagamento único',
        style: TextStyle(color: AppColor.cyanColor, fontSize: 11),
      );
    }
    return Text(
      '${_itemComprasModel.parcelasParciais}/${_itemComprasModel.parcelasTotais} Parcelas',
      style: TextStyle(
        color: _itemComprasModel.isPago
            ? Colors.black.withAlpha(90)
            : Colors.black.withAlpha(145),
        fontSize: 12,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _showParcelasFormat();
  }
}
