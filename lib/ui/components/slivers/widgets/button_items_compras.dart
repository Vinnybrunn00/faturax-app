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
import 'package:material_ui/material_ui.dart';
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
              margin: EdgeInsets.only(left: 12, top: 10, right: 12),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: _itemsComprasModel.isFixed
                    ? null
                    : () async => await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ItemsPage(items: _itemsComprasModel),
                        ),
                      ),
                child: Ink(
                  padding: EdgeInsets.fromLTRB(14, 12, 14, 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColor.borderColor),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.blackBlue.withAlpha(8),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: .center,
                    spacing: 7,
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
                                      ? AppColor.greyColor.withAlpha(110)
                                      : AppColor.greyColor,
                                  fontSize: 12,
                                  fontWeight: .w500,
                                ),
                              ),
                              Container(
                                height: 3,
                                width: 3,
                                decoration: BoxDecoration(
                                  color: AppColor.greyColor.withAlpha(120),
                                  shape: BoxShape.circle,
                                ),
                              ),

                              if (_itemsComprasModel.isFixed)
                                BoxStatusCompras(
                                  title: 'Assinatura',
                                  bgColor: Color(0xFFE0F2FE),
                                  textColor: Color(0xFF0369A1),
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
                                  bgColor: Color(0xFFFFF1E0),
                                  textColor: Color(0xFFC2410C),
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
                                        fontSize: 15.5,
                                        fontWeight: FontWeight.w600,
                                        overflow: .ellipsis,
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
                              fontSize: 15.5,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.2,
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
