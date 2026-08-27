import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faturax_app/constants/constants_color.dart';
import 'package:faturax_app/ui/components/slivers/widgets/box_status_compras.dart';
import 'package:faturax_app/ui/pages/home_page.dart';
import 'package:faturax_app/viewmodels/home_view_model.dart';
import 'package:faturax_app/models/items_compras_model.dart';
import 'package:faturax_app/repository/user_repository.dart';
import 'package:faturax_app/repository/next_month_product.dart';
import 'package:faturax_app/repository/product_repository.dart';
import 'package:faturax_app/ui/components/slivers/widgets/text_parcelas.dart';
import 'package:faturax_app/ui/pages/items/items_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ButtonItemsCompras extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> docs;

  const ButtonItemsCompras({super.key, required this.docs});

  ItemComprasModel get _itemsComprasModel =>
      ItemComprasModel.fromQueryDocument(queryDocument: docs);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Consumer5<
      ProductRepository,
      NextMonthProduct,
      UserView,
      UserRepository,
      ChangePage
    >(
      builder:
          (
            context,
            product,
            afterMonth,
            userView,
            userRepository,
            changePage,
            _,
          ) {
            final bool belongsToCurrentTab = changePage.index != 0
                ? _itemsComprasModel.isPago
                : !_itemsComprasModel.isPago;

            if (!belongsToCurrentTab) return const SizedBox.shrink();

            return AnimatedContainer(
              duration: Duration(milliseconds: 650),
              margin: EdgeInsets.only(left: 8, top: 8, right: 8),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: _itemsComprasModel.isFixed
                    ? null
                    : () async => await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ItemsPage(items: _itemsComprasModel),
                        ),
                      ),
                child: Ink(
                  padding: EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColor.borderColor, width: 1.5),
                  ),
                  child: Column(
                    mainAxisAlignment: .center,
                    spacing: 6,
                    children: [
                      Row(
                        mainAxisAlignment: .spaceBetween,
                        children: [
                          Row(
                            spacing: 8,
                            children: [
                              Text(
                                userView.dateViewer(
                                  _itemsComprasModel.timeStamp,
                                ),
                                style: TextStyle(
                                  color: _itemsComprasModel.isPago
                                      ? AppColor.greyColor.withAlpha(90)
                                      : AppColor.greyColor,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                '|',
                                style: TextStyle(color: AppColor.greyColor),
                              ),

                              if (_itemsComprasModel.isFixed)
                                BoxStatusCompras(
                                  title: 'Assinatura',
                                  bgColor: AppColor.cyanColor.withAlpha(30),
                                  textColor: AppColor.cyanColor,
                                ),

                              if (_itemsComprasModel.isPago)
                                BoxStatusCompras(
                                  title: 'Pago',
                                  bgColor: Color(0xFFD1FAE5),
                                  textColor: Color(0xFF065F46),
                                ),

                              if (_itemsComprasModel.pending)
                                BoxStatusCompras(
                                  title: 'Em Aberto',
                                  bgColor: Color(0xFFFFEDD5),
                                  textColor: Color(0xFFEA580C),
                                ),
                            ],
                          ),
                          //if (!_itemsComprasModel.isFixed)
                          //DeleteButton(items: _itemsComprasModel),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: .spaceBetween,
                        children: [
                          Expanded(
                            child: SizedBox(
                              width: size.width * .72,
                              child: Row(
                                spacing: _itemsComprasModel.lastParcela ? 5 : 0,
                                children: [
                                  _itemsComprasModel.lastParcela
                                      ? Container(
                                          height: 8,
                                          width: 8,
                                          decoration: BoxDecoration(
                                            color: AppColor.cyanColor,
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                        )
                                      : SizedBox.shrink(),
                                  Expanded(
                                    child: Text(
                                      _itemsComprasModel.name,
                                      style: TextStyle(
                                        color: _itemsComprasModel.isPago
                                            ? AppColor.blackBlue.withAlpha(130)
                                            : AppColor.blackBlue,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        overflow: .fade,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
                                  ? AppColor.blackBlue.withAlpha(130)
                                  : AppColor.blackBlue,
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
                              if (!_itemsComprasModel.isFixed)
                                TextParcelas(
                                  itemComprasModel: _itemsComprasModel,
                                ),
                            ],
                          ),

                          if (!_itemsComprasModel.isFixed)
                            Text(
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
