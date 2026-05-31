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

  const ButtonItemsCompras({
    super.key,
    required this.docs,
    required this.userView,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                spacing: 5,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
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
                      : Text(
                          '$_parcelasParciais/$_parcelasTotais Parcelas',
                          style: TextStyle(
                            color: Colors.black.withAlpha(145),
                            fontSize: 11,
                          ),
                        ),
                ],
              ),
              Column(
                crossAxisAlignment: .end,
                mainAxisAlignment: .center,
                children: [
                  Text(
                    product.convertCentInReais(_priceInt),
                    style: TextStyle(
                      color: AppColor.blackBlueLow,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  _isFixed
                      ? Text(
                          "Adicionado em ${userView.showDataCompra(_timeStamp)}",
                          style: TextStyle(
                            color: AppColor.greyColor,
                            fontSize: 12,
                          ),
                        )
                      : Text(
                          'Inicio em $_startDate',
                          style: TextStyle(
                            color: AppColor.orangerColor,
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
