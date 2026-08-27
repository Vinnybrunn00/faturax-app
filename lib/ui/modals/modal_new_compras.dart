import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:faturax_app/constants/constants_color.dart';
import 'package:faturax_app/constants/constants_values.dart';
import 'package:faturax_app/services/logs_services.dart';
import 'package:faturax_app/ui/helpers/helpers.dart';
import 'package:faturax_app/ui/widgets/box_circular_progress.dart';
import 'package:faturax_app/viewmodels/date_picker.dart';
import 'package:faturax_app/viewmodels/product_model.dart';
import 'package:faturax_app/repository/product_repository.dart';
import 'package:faturax_app/ui/components/inputs/input_compras.dart';
import 'package:flutter/material.dart';
import 'package:iconsx_plus/iconsx_plus.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ModalNewCompras {
  final Helpers _helpers = Helpers();

  final CurrencyTextInputFormatter _formatter =
      CurrencyTextInputFormatter.currency(
        locale: 'pt_BR',
        symbol: 'R\$',
        decimalDigits: 2,
      );

  Future<void> showModalNewCompras(
    BuildContext context,
    DatePicker datePicker,
    ProductRepository product,
  ) async {
    final ProductModel productModels = context.read<ProductModel>();
    final Size size = MediaQuery.of(context).size;
    await showModalBottomSheet(
      sheetAnimationStyle: AnimationStyle(
        duration: Duration(milliseconds: 450),
        curve: Curves.fastOutSlowIn,
      ),
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: AppColor.backgroundColorWhite,
      context: context,
      builder: (ctx) => MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: datePicker),
          ChangeNotifierProvider.value(value: productModels),
          ChangeNotifierProvider.value(value: product),
        ],
        child: Consumer3<ProductRepository, DatePicker, ProductModel>(
          builder: (ctxz, product, datePicker, productModel, _) {
            return Container(
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
              ),
              height: size.height - (productModel.fixed! ? 500 : 330),
              width: size.width,
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    Column(
                      spacing: 10,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                          height: 55,
                          decoration: BoxDecoration(
                            color: AppColor.whiteColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(18),
                              topRight: Radius.circular(18),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: .spaceBetween,
                            children: [
                              Text(
                                'Nova Compra',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: .w600,
                                ),
                              ),
                              InkWell(
                                onTap: () => Navigator.pop(context),
                                child: Icon(BoxIcons.bx_x, size: 28),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.only(left: 12, right: 12, top: 2),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColor.whiteColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColor.borderColor),
                          ),
                          child: Column(
                            spacing: 6,
                            children: [
                              InputCompras(
                                enabled: !product.loading,
                                title: 'Nome da Compra',
                                onChanged: (name) => productModel.name = name,
                                hintText: 'Ex: Mercado Livre, JD, etc...',
                              ),

                              InputCompras(
                                enabled: !product.loading,
                                title: 'Valor da Compra',
                                onChanged: (_) => productModel.price =
                                    _formatter.getFormattedValue(),
                                hintText: 'R\$ 0,00',
                                keyboardType: TextInputType.number,
                                inputFormatters: [_formatter],
                              ),

                              if (productModel.fixed != null) ...[
                                if (!productModel.fixed!)
                                  InputCompras(
                                    enabled: !product.loading,
                                    title: 'Numero de parcelas',
                                    onChanged: (parcelas) =>
                                        productModel.parcelas = parcelas,
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
                                        onTap: product.loading
                                            ? null
                                            : () async {
                                                await datePicker.selectDate(
                                                  context,
                                                );
                                              },
                                        child: Container(
                                          padding: EdgeInsets.only(left: 12),
                                          height: 46,
                                          width: size.width,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              5,
                                            ),
                                            border: Border.all(
                                              color: AppColor.blackColorAlpha55,
                                            ),
                                          ),
                                          child: Row(
                                            spacing: 8,
                                            children: [
                                              Icon(BoxIcons.bx_calendar),
                                              Text(
                                                datePicker.date ??
                                                    DateFormat(
                                                      formatDatePt,
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
                                      activeColor: AppColor.purpleColor,
                                      value: productModel.fixed,
                                      onChanged: product.loading
                                          ? null
                                          : (bool? value) {
                                              productModel.changeButton(value);
                                            },
                                    ),
                                  ),
                                  Text('É assinatura?'),
                                ],
                              ),
                              InkWell(
                                onTap: product.loading
                                    ? null
                                    : () async {
                                        try {
                                          if (productModel.isEmpty) {
                                            Navigator.pop(context);
                                            _helpers.showMessageInfo(
                                              ctxz,
                                              message:
                                                  'Os Campos não podem estar vazios.',
                                            );
                                            return;
                                          }

                                          product.changeLoading();

                                          await product.saveProduct(
                                            productModel,
                                            datePicker.dateTimeApp,
                                          );

                                          product.changeLoading();

                                          if (!context.mounted) return;
                                          // LOG - salvar nova compra
                                          LogsServices(
                                            context: context,
                                            message:
                                                'salvou uma nova compra -> "${productModel.name}" - ${productModel.price} em ${productModel.parcelas} parcela(s)',
                                            type: 'INFO',
                                          );
                                          Navigator.pop(context);
                                        } catch (err) {
                                          if (!context.mounted) return;
                                          Navigator.pop(context);
                                          _helpers.showMessageInfo(
                                            context,
                                            message:
                                                'Preencha a data de inicio do pagamento',
                                          );
                                        } finally {
                                          product.stopLoading();
                                        }
                                      },
                                child: Container(
                                  height: 55,
                                  width: size.width,
                                  decoration: BoxDecoration(
                                    color: AppColor.purpleColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Adicionar nova compra',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    product.loading ? BoxCircularProgress() : SizedBox.shrink(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ).then((_) {
      productModels.reset();
      datePicker.reset();
    });
  }
}
