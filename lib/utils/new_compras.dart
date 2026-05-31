import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:faturax/constants/constants_color.dart';
import 'package:faturax/models/product/new_product.dart';
import 'package:faturax/models/product/product_model.dart';
import 'package:faturax/ui/components/inputs/input_compras.dart';
import 'package:faturax/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NewCompras {
  final Utils _utils = Utils();

  final CurrencyTextInputFormatter _formatter =
      CurrencyTextInputFormatter.currency(
        locale: 'pt_BR',
        symbol: 'R\$',
        decimalDigits: 2,
      );

  Future<void> showModal(BuildContext context, NewProduct newProduct) async {
    final ProductModel productModel = context.read<ProductModel>();
    final Size size = MediaQuery.of(context).size;
    await showModalBottomSheet(
      useSafeArea: true,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      context: context,
      builder: (ctx) => ChangeNotifierProvider.value(
        value: newProduct,
        child: Consumer2<NewProduct, ProductModel>(
          builder: (ctxz, value, productModel, _) {
            return Container(
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
              ),
              padding: EdgeInsets.only(left: 12, right: 12),
              height: size.height - 250,
              width: size.width,
              child: SingleChildScrollView(
                child: Column(
                  spacing: 10,
                  children: [
                    Text(
                      'Nova Compra',
                      style: TextStyle(fontSize: 17, fontWeight: .w600),
                    ),

                    InputCompras(
                      title: 'Nome da Compra',
                      onChanged: (name) => productModel.name = name,
                      hintText: 'Ex: Mercado Livre, JD, etc...',
                    ),

                    InputCompras(
                      title: 'Valor da Compra',
                      onChanged: (_) =>
                          productModel.price = _formatter.getFormattedValue(),
                      hintText: 'R\$ 0,00',
                      keyboardType: TextInputType.number,
                      inputFormatters: [_formatter],
                    ),

                    if (productModel.fixed != null) ...[
                      if (!productModel.fixed!)
                        InputCompras(
                          title: 'Numero de parcelas',
                          onChanged: (installments) =>
                              productModel.installments = installments,
                          hintText: 'ex: 5',
                          keyboardType: TextInputType.number,
                        ),

                      if (!productModel.fixed!)
                        Column(
                          spacing: 5,
                          crossAxisAlignment: .start,
                          children: [
                            Text('Começa a ser cobrado em'),
                            InkWell(
                              onTap: () async {
                                await newProduct.selectDate(context);
                              },
                              child: Container(
                                padding: EdgeInsets.only(left: 12),
                                height: 50,
                                width: size.width,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppColor.blackColorAlpha55,
                                  ),
                                ),
                                child: Row(
                                  spacing: 8,
                                  children: [
                                    Icon(BoxIcons.bx_calendar),
                                    Text(
                                      newProduct.date ??
                                          DateFormat(
                                            "MMMM 'de' yyyy",
                                            'pt_BR',
                                          ).format(DateTime.now()),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                    Row(
                      children: [
                        Transform.scale(
                          alignment: Alignment.centerLeft,
                          scale: 1,
                          child: Checkbox(
                            activeColor: AppColor.pupleColor,
                            value: productModel.fixed,
                            onChanged: (bool? value) {
                              productModel.changeButton(value);
                            },
                          ),
                        ),
                        Text('É assinatura?'),
                      ],
                    ),
                    InkWell(
                      onTap: () async {
                        if (productModel.isEmpty) {
                          Navigator.pop(context);
                          _utils.showMessageInfo(
                            ctxz,
                            message: 'Os Campos não podem estar vazios.',
                          );
                          return;
                        }

                        await newProduct.saveProduct(productModel);

                        if (!context.mounted) return;
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 55,
                        width: size.width,
                        decoration: BoxDecoration(
                          color: Color(0xff4150F7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'Salvar Compra',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ).then((_) {
      productModel.reset();
      newProduct.setDate = DateFormat(
        "MMMM 'de' yyyy",
        'pt_BR',
      ).format(DateTime.now());
    });
  }
}
