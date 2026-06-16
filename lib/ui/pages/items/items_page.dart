import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faturax_app/constants/constants_color.dart';
import 'package:faturax_app/services/logs_services.dart';
import 'package:faturax_app/ui/helpers/helpers.dart';
import 'package:faturax_app/ui/widgets/box_circular_progress.dart';
import 'package:faturax_app/viewmodels/items_model.dart';
import 'package:faturax_app/repository/product_repository.dart';
import 'package:faturax_app/ui/widgets/event_button.dart';
import 'package:faturax_app/ui/widgets/input_text.dart';
import 'package:flutter/material.dart';
import 'package:iconsx_plus/iconsx_plus.dart';
import 'package:provider/provider.dart';

class ItemsPage extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> document;

  ItemsPage({super.key, required this.document});

  final Helpers _helpers = Helpers();

  Map<String, dynamic> get _items => document.data();

  String get _id => document.id;
  int get _parcelasTotais => document['parcelas_totais'] as int;

  @override
  Widget build(BuildContext context) {
    final ItemsModel itemsModel = Provider.of<ItemsModel>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Editar Compra'),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () async {
              await showDialog<bool>(
                context: context,
                barrierDismissible: false,
                builder: (context) => Dialog(
                  backgroundColor: AppColor.whiteColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Consumer<ProductRepository>(
                    builder: (context, product, _) {
                      return Padding(
                        padding: EdgeInsets.all(24),
                        child: Stack(
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade50,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.delete_outline_rounded,
                                    color: Colors.red.shade400,
                                    size: 36,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Apagar compra',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Tem certeza que deseja apagar esta compra?\nEsta ação não pode ser desfeita.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColor.greyColor,
                                    height: 1.5,
                                  ),
                                ),
                                SizedBox(height: 28),
                                Row(
                                  spacing: 12,
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        style: OutlinedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 14,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          side: BorderSide(
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                        child: Text(
                                          'Cancelar',
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          final String deleteMsg = await product
                                              .deleteCompra(_id);

                                          if (!context.mounted) return;

                                          _helpers.showMessageInfo(
                                            context,
                                            message: deleteMsg,
                                          );
                                          if (!context.mounted) return;
                                          // LOG - Delete compra
                                          final priceFormat = product
                                              .convertCentInReais(
                                                _items['price_int'],
                                              );

                                          LogsServices(
                                            context: context,
                                            message:
                                                'deletou a compra ${_items['name']} de $priceFormat',
                                            type: 'INFO',
                                          );

                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                        },

                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red.shade500,
                                          foregroundColor: Colors.white,
                                          padding: EdgeInsets.symmetric(
                                            vertical: 14,
                                          ),
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          'Apagar',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            product.loading
                                ? BoxCircularProgress()
                                : SizedBox.shrink(),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            },
            child: Icon(BoxIcons.bx_trash, color: AppColor.redColor),
          ),
        ],
        actionsPadding: EdgeInsets.only(right: 18),
      ),
      body: SizedBox.expand(
        child: Consumer<ProductRepository>(
          builder: (context, product, child) {
            return Padding(
              padding: EdgeInsets.all(10),
              child: Stack(
                children: [
                  Column(
                    spacing: 25,
                    children: [
                      Column(
                        spacing: 5,
                        crossAxisAlignment: .start,
                        children: [
                          Text('Nome da Compra'),
                          InputText(
                            readOnly: true,
                            enabled: false,
                            hintText: _items['name'],
                          ),
                        ],
                      ),
                      Column(
                        spacing: 5,
                        crossAxisAlignment: .start,
                        children: [
                          Text('Valor da Compra'),
                          InputText(
                            readOnly: true,
                            enabled: false,
                            hintText: product.convertCentInReais(
                              _items['price_int'],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        spacing: 5,
                        crossAxisAlignment: .start,
                        children: [
                          Text('Numero de parcelas pagas'),
                          InputText(
                            enabled: !product.loading,
                            maxLength: 2,
                            onChanged: (String parcelas) =>
                                itemsModel.onChange(parcelas, _parcelasTotais),
                            hintText: 'ex: 5',
                            keyboardType: TextInputType.number,
                            errorText:
                                'Parcelado em $_parcelasTotais vezes (${_items["parcelas_parciais"]} parcelas pagas)',
                          ),
                        ],
                      ),
                      EventButton(
                        title: 'Salvar Compra',
                        onTap: itemsModel.enabled
                            ? () async {
                                await product.changeParcelas(itemsModel, _id);

                                if (!context.mounted) return;
                                // LOG - editar compra
                                LogsServices(
                                  context: context,
                                  message:
                                      'editou a compra "${_items["name"]}" para ${itemsModel.parcelas} parcela(s)',
                                  type: 'INFO',
                                );

                                Navigator.of(context).pop();
                              }
                            : null,
                        color: itemsModel.enabled
                            ? AppColor.pupleColor
                            : Color(0x834150F7),
                      ),
                    ],
                  ),
                  product.loading ? BoxCircularProgress() : SizedBox.shrink(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
