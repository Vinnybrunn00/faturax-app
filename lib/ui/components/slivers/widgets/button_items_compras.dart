import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faturax_app/constants/constants_color.dart';
import 'package:faturax_app/controller/home_view_model.dart';
import 'package:faturax_app/models/items_compras_model.dart';
import 'package:faturax_app/repository/user_repository.dart';
import 'package:faturax_app/repository/next_month_product.dart';
import 'package:faturax_app/repository/product_repository.dart';
import 'package:faturax_app/ui/pages/items/items_page.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ButtonItemsCompras extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> docs;

  const ButtonItemsCompras({super.key, required this.docs});

  Map<String, dynamic> get _items => docs.data();

  ItemsComprasModel get _itemsComprasModel => ItemsComprasModel(items: _items);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Consumer4<
      ProductRepository,
      NextMonthProduct,
      UserView,
      UserRepository
    >(
      builder: (context, product, afterMonth, userView, userRepository, _) {
        return Tooltip(
          waitDuration: Duration(seconds: 1),
          message: 'Adicionado em ${userView.formatDate}',
          onTriggered: () => userView.dateViewer(_itemsComprasModel.timeStamp),
          child: InkWell(
            onTap: _itemsComprasModel.isFixed
                ? null
                : () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ItemsPage(document: docs),
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
                          spacing: _itemsComprasModel.lastParcelas == 1 ? 5 : 0,
                          children: [
                            _itemsComprasModel.lastParcelas == 1
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
                                _itemsComprasModel.name,
                                style: TextStyle(
                                  color: _itemsComprasModel.isPago
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
                        userRepository.notVisibility
                            ? '****'
                            : product.convertCentInReais(
                                _itemsComprasModel.priceInt,
                              ),
                        style: TextStyle(
                          color: _itemsComprasModel.isPago
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
                          _itemsComprasModel.isFixed
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
                              : _itemsComprasModel.showParcelasFormat(),

                          if (_itemsComprasModel.isPago)
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

                      _itemsComprasModel.isFixed
                          ? Text(
                              "Adicionado em ${userView.showDataCompra(_itemsComprasModel.timeStamp)}",
                              style: TextStyle(
                                color: _itemsComprasModel.isPago
                                    ? AppColor.greyColor.withAlpha(90)
                                    : AppColor.greyColor,
                                fontSize: 12,
                              ),
                            )
                          : Text(
                              'Início em ${_itemsComprasModel.startDate}',
                              style: TextStyle(
                                color: _itemsComprasModel.isPago
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
      },
    );
  }
}
