import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faturax/constants/constants_color.dart';
import 'package:faturax/models/items/items_model.dart';
import 'package:faturax/models/product/new_product.dart';
import 'package:faturax/ui/widgets/event_button.dart';
import 'package:faturax/ui/widgets/input_text.dart';
import 'package:faturax/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

class ItemsPage extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> document;
  final NewProduct newProduct;

  ItemsPage({super.key, required this.document, required this.newProduct});

  final Utils _utils = Utils();

  Map<String, dynamic> get _items => document.data();

  String get _id => document.id;
  int get _parcelasTotais => document['parcelas_totais'] as int;

  @override
  Widget build(BuildContext context) {
    final ItemsModel provider = Provider.of<ItemsModel>(context);
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
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
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
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  side: BorderSide(color: Colors.grey.shade300),
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
                                  final String deleteMsg = await provider
                                      .deleteCompra(_id);

                                  if (!context.mounted) return;

                                  _utils.showMessageInfo(
                                    context,
                                    message: deleteMsg,
                                  );
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },

                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red.shade500,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'Apagar',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
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
            child: Icon(BoxIcons.bx_trash, color: AppColor.redColor),
          ),
        ],
        actionsPadding: EdgeInsets.only(right: 18),
      ),
      body: SizedBox.expand(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
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
                    hintText: newProduct.convertCentInReais(
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
                    maxLength: 2,
                    onChanged: (String parcelas) =>
                        provider.onChange(parcelas, _parcelasTotais),
                    hintText: 'ex: 5',
                    keyboardType: TextInputType.number,
                    errorText:
                        'Parcelado em $_parcelasTotais vezes (${_items["parcelas_parciais"]} parcelas pagas)',
                  ),
                ],
              ),
              EventButton(
                title: 'Salvar Compra',
                onTap: provider.enabled
                    ? () async {
                        await provider.changeParcelas(provider, _id);

                        if (!context.mounted) return;
                        Navigator.of(context).pop();
                      }
                    : null,
                color: provider.enabled
                    ? AppColor.pupleColor
                    : Color(0x834150F7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
