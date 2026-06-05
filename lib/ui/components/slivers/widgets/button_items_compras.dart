import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faturax/constants/constants_color.dart';
import 'package:faturax/models/product/new_product.dart';
import 'package:faturax/models/user/user_model.dart';
import 'package:faturax/ui/pages/items/items_page.dart';
import 'package:flutter/material.dart';

class ButtonItemsCompras extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> docs;
  final UserView userView;
  final NewProduct product;

  Map<String, dynamic> get _items => docs.data();

  String get _name => _items['name'] as String;
  String get _startDate => _items['start_date'] as String;
  bool get _isFixed => _items['isFixed'] as bool;
  int get _priceInt => _items['price_int'] as int;
  int get _parcelasParciais => _items['parcelas_parciais'] as int;
  int get _parcelasTotais => _items['parcelas_totais'] as int;
  int get _timeStamp => _items['timestamp'];

  int get _lastParcelas => _parcelasTotais - _parcelasParciais;

  bool get _isPago {
    if (_isFixed) return !_isFixed;
    return _parcelasTotais == _parcelasParciais;
  }

  Text _showParcelasFormat() {
    if (_parcelasTotais == 1) {
      return Text(
        'Pagamento único',
        style: TextStyle(color: AppColor.cyanColor, fontSize: 11),
      );
    }
    return Text(
      '$_parcelasParciais/$_parcelasTotais Parcelas',
      style: TextStyle(
        color: _isPago
            ? Colors.black.withAlpha(90)
            : Colors.black.withAlpha(145),
        fontSize: 12,
      ),
    );
  }

  const ButtonItemsCompras({
    super.key,
    required this.docs,
    required this.userView,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Tooltip(
      waitDuration: Duration(seconds: 1),
      message: 'Adicionado em ${userView.formatDate}',
      onTriggered: () => userView.dateViewer(_timeStamp),
      child: InkWell(
        onTap: _isFixed
            ? null
            : () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        ItemsPage(newProduct: product, document: docs),
                  ),
                );
              },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 650),
          padding: EdgeInsets.all(13),
          height: 80,
          child: Column(
            mainAxisAlignment: .center,
            spacing: 3,
            children: [
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  SizedBox(
                    width: size.width * .72,
                    child: Row(
                      spacing: _lastParcelas == 1 ? 5 : 0,
                      children: [
                        _lastParcelas == 1
                            ? Container(
                                height: 8,
                                width: 8,
                                decoration: BoxDecoration(
                                  color: AppColor.cyanColor,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              )
                            : SizedBox.shrink(),
                        Expanded(
                          child: Text(
                            _name,
                            style: TextStyle(
                              color: _isPago
                                  ? AppColor.blackBlue.withAlpha(90)
                                  : AppColor.blackBlue,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              overflow: .ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Text(
                    product.convertCentInReais(_priceInt),
                    style: TextStyle(
                      color: _isPago
                          ? AppColor.blackBlueLow.withAlpha(90)
                          : AppColor.blackBlueLow,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Row(
                    spacing: 8,
                    children: [
                      _isFixed
                          ? Container(
                              padding: EdgeInsets.fromLTRB(18, 3, 18, 3),
                              decoration: BoxDecoration(
                                color: AppColor.cyanColor.withAlpha(30),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Text(
                                'Assinatura',
                                style: TextStyle(
                                  color: AppColor.cyanColor,
                                  fontWeight: .w500,
                                  fontSize: 12.5,
                                ),
                              ),
                            )
                          : _showParcelasFormat(),

                      if (_isPago)
                        Container(
                          padding: EdgeInsets.fromLTRB(10, .5, 10, .5),
                          decoration: BoxDecoration(
                            color: AppColor.greenColor.withAlpha(20),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Text(
                            'Pago',
                            style: TextStyle(
                              color: AppColor.greenColor.withAlpha(200),
                              fontSize: 11,
                            ),
                          ),
                        ),
                    ],
                  ),

                  _isFixed
                      ? Text(
                          "Adicionado em ${userView.showDataCompra(_timeStamp)}",
                          style: TextStyle(
                            color: _isPago
                                ? AppColor.greyColor.withAlpha(90)
                                : AppColor.greyColor,
                            fontSize: 12,
                          ),
                        )
                      : Text(
                          'Início em $_startDate',
                          style: TextStyle(
                            color: _isPago
                                ? AppColor.greyColor.withAlpha(110)
                                : AppColor.greyColor,
                            fontSize: 12,
                          ),
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
